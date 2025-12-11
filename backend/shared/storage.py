import os
from datetime import datetime, timezone
from typing import Optional, Dict, Any, List


from azure.cosmos import CosmosClient, exceptions


COSMOS_ENDPOINT = os.getenv("COSMOS_ENDPOINT")
if not COSMOS_ENDPOINT:
    raise RuntimeError("Could not initialize COSMOS_ENDPOINT")
COSMOS_KEY = os.getenv("COSMOS_KEY")
if not COSMOS_KEY:
    raise RuntimeError("Could not initialize COSMOS_KEY")
COSMOS_DB_NAME = os.getenv("COSMOS_DB_NAME")
if not COSMOS_DB_NAME:
    raise RuntimeError("Could not initialize COSMOS_DB_NAME")
COSMOS_CONTAINER = os.getenv("COSMOS_CONTAINER")
if not COSMOS_CONTAINER:
    raise RuntimeError("Could not initialize COSMOS_CONTAINER")
COSMOS_TIMELINE = os.getenv("COSMOS_TIMELINE_CONTAINER")
if not COSMOS_TIMELINE:
    raise RuntimeError("Could not initialize COSMOS_TIMELINE")


client = CosmosClient(COSMOS_ENDPOINT, credential=COSMOS_KEY)
db = client.get_database_client(COSMOS_DB_NAME)
container = db.get_container_client(COSMOS_CONTAINER)
timeline_container = db.get_container_client(COSMOS_TIMELINE)


def save_url(short_id: str, long_url: str) -> Dict[str, Any]:
    now = datetime.utcnow().isoformat() + "Z"
    item = {
        "id":          short_id,
        "long_url":    long_url,
        "created_at":  now,
        "click_count": 0,
        "last_access": None,
    }
    container.upsert_item(item)
    return item


def increment(short_id: str, timestamp: Optional[str]) -> None:
    try:
        item = container.read_item(item=short_id, partition_key=short_id)
    except exceptions.CosmosHttpResponseError:
        return

    item["click_count"] = item.get("click_count", 0) + 1
    item["last_access"] = timestamp or datetime.utcnow().isoformat() + "Z"
    container.upsert_item(item)


def get_item(short_id: str) -> Optional[Dict[str, Any]]:
    try:
        return container.read_item(item=short_id, partition_key=short_id)
    except exceptions.CosmosHttpResponseError:
        return None


def get_stats(short_id: str) -> Optional[Dict[str, Any]]:
    base = get_item(short_id)
    if not base:
        return None

    query = "SELECT c.date, c.click_count FROM c WHERE c.shortId = @sid ORDER BY c.date"
    params: List[Dict[str, Any]] = [
        {
            "name":  "@sid",
            "value": short_id,
        }
    ]
    timeline = list[dict[str, Any]](
        timeline_container.query_items(
            query=query,
            parameters=params,
            enable_cross_partition_query=True,
        )
    )

    return {
        "shortId":    short_id,
        "longUrl":    base.get("long_url"),
        "clickCount": base.get("click_count", 0),
        "lastAccess": base.get("last_access"),
        "timeline":   timeline,
    }


def record_click_timeline(short_id: str, timestamp: Optional[str]) -> None:
    if timestamp:
        try:
            if timestamp.endswith("Z"):
                dt = datetime.fromisoformat(timestamp.replace("Z", "+00:00"))
            else:
                dt = datetime.fromisoformat(timestamp)
        except (ValueError, AttributeError):
            dt = datetime.now(timezone.utc)
    else:
        dt = datetime.now(timezone.utc)
    day_str = dt.date().isoformat()

    doc_id = f"{short_id}-{day_str}"
    partition_key = short_id

    try:
        doc = timeline_container.read_item(
            item=doc_id,
            partition_key=partition_key
        )
        doc["click_count"] = doc.get("click_count", 0) + 1
    except exceptions.CosmosHttpResponseError:
        doc = {
            "id":          doc_id,
            "shortId":     short_id,
            "date":        day_str,
            "click_count": 1
        }
    
    timeline_container.upsert_item(doc)
