import os
import logging
import requests
from typing import Optional, Dict, Any


GEO_IP_API_URL = os.getenv("GEO_IP_API_URL", "https://ipapi.co/{ip}/json/")
GEO_IP_API_KEY = os.getenv("GEO_IP_API_KEY")


def lookup(ip: str) -> Optional[Dict[str, Any]]:
    if not ip or ip == 'unknown':
        return None
    
    try:
        url = GEO_IP_API_URL.format(ip=ip)
        headers = {}
        params = {}

        if GEO_IP_API_KEY:
            params['apiKey'] = GEO_IP_API_KEY
        
        resp = requests.get(url, headers=headers, params=params, timeout=2.0)

        if resp.status_code == 429:
            logging.warning("Rate Limited for %s", ip)
            return None
        elif resp.status_code != 200:
            logging.debug("Lookup failed for %s: status %d", ip, resp.status_code)
            return None

        data = resp.json()
        if data.get('error'):
            logging.debug("Error for %s: %s", ip, data.get("message", "Unknown Error"))
            return None
        
        return {
            "country"   : data.get("country_name") or data.get("country"),
            "region"    : data.get("region") or data.get("region_name"),
            "city"      : data.get("city"),
            "latitude"  : data.get("latitude") or data.get("lat"),
            "longitude" : data.get("longitude") or data.get("lon"),
        }
    except requests.exceptions.Timeout:
        logging.warning("Lookup timeout for %s", ip)
        return None
    except Exception as e:
        logging.warning("Lookup failed for %s: %s", ip, e)
        return None
