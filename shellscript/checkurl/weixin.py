#!/usr/bin/env python
#-*- coding:utf-8 -*-
import urllib2
import json
import simplejson
import sys

url = "https://qyapi.weixin.qq.com/cgi-bin/gettoken?corpid=wxb6d2d36daab9428d&corpsecret=mqJpHsAmo-De0gpt-MqxFL_xvm2W9Rgi_TJJ2VBXYRM"
token = json.loads(urllib2.urlopen(url).read())['access_token']
send_url = "https://qyapi.weixin.qq.com/cgi-bin/message/send?access_token=" + token
message = sys.argv[1]
send_values = { 
		"touser":"@all",
		"msgtype":"text",
        "agentid":"1000002",
        "text":{"content":message},
        "safe":"0" }
send_data = simplejson.dumps(send_values, ensure_ascii=False).encode('utf-8')
#print send_data
urllib2.urlopen(urllib2.Request(send_url, send_data)).read()
