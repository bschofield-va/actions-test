#
# THIS FILE INTENTIONALLY CONTAINS VULNERABLE CODE TO TEST INTEGRATING
# CODEQL SECURITY FINDINGS WITH TILT HAMMER WORKFLOWS.
#
import requests
from flask import Flask, request

app = Flask(__name__)

@app.route("/full_ssrf")
def full_ssrf():
    target = request.args["target"]
    # BAD: user has full control of URL
    # https://codeql.github.com/codeql-query-help/python/py-full-ssrf/
    resp = requests.get("https://" + target + ".example.com/data/")