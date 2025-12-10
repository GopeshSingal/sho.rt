import os
import json
from datetime import datetime
from azure.eventhub import EventHubProducerClient, EventData


EVENTHUB_SEND_CONNECTION = os.getenv("EVENTHUB_SEND_CONNECTION") or os.getenv("EVENTHUB_CONNECTION")
if not EVENTHUB_SEND_CONNECTION:
    raise RuntimeError("Could not initialize EVENTHUB_SEND_CONNECTION")
EVENTHUB_NAME = os.getenv("EVENTHUB_NAME")
if not EVENTHUB_NAME:
    raise RuntimeError("Could not initialize EVENTHUB_NAME")

_producer_client = None

def _get_producer() -> EventHubProducerClient:
    global _producer_client
    if not _producer_client:
        _producer_client = EventHubProducerClient.from_connection_string(
            conn_str=EVENTHUB_SEND_CONNECTION, # type: ignore
            eventhub_name=EVENTHUB_NAME,
        )
    return _producer_client


def publish_event(short_id: str, ip: str, user_agent: str, referrer: str = "") -> None:
    event = {
        "shortId": short_id,
        "ip": ip,
        "userAgent": user_agent,
        "referrer": referrer,
        "timestamp": datetime.utcnow().isoformat() + "Z"
    }
    producer = _get_producer
    batch = producer.create_batch()
    batch.add(EventData(json.dumps(event)))
    producer.send_batch(batch)