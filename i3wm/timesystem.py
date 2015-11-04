#!/usr/bin/python

import os
import pycurl
import re
import time
import json

from subprocess import Popen, call, PIPE
from math import floor
from ConfigParser import SafeConfigParser

import urllib, cookielib, urllib2

import pprint, sys

stampInThresholdHours = 8
stampIn = 2
stampOut = 1

class TimeSystem:
    def __init__(self, username, password, filename):
        self.filename = filename
        self.username = username
        self.password = password
        self.baseUrl = 'timesystem.sportradar.ag'

        if (os.path.isfile(self.filename)):
            f = open(self.filename, 'r')
            self.stored = json.loads(f.read())
            f.close()
        else:
            self.stored = {
                'lastActive': int(time.time()),
                'savetime': 0,
                'lastStamp': {
                    'time': 0,
                    'status': 'None',
                    'message': 'No timesystem info available'
                }
            }

    def getLastActive(self):
        p = Popen(["xprintidle"], shell=True, stdout=PIPE)
        millis = p.stdout.readline()
        if millis:
            seconds = float(millis) / 1000.0
            return int(time.time() - seconds)
        return int(self.stored['lastActive'])

    def getPrevLastActive(self):
        return int(self.stored['lastActive'])

    def setLastActive(self, lastActive):
        self.stored['lastActive'] = int(lastActive)

    def getLastMessage(self):
        return self.stored['lastStamp']['message']

    def getLastStatus(self):
        return self.stored['lastStamp']['status']

    def getLastStampTime(self):
        return self.stored['lastStamp']['time']

    def save(self):
        self.stored['savetime'] = int(time.time())
        self.stored['lastActive'] = self.getLastActive()
        f = open(self.filename, 'w')
        f.write(json.dumps(self.stored))
        f.close()

    def stamp(self, status):
        if (status not in (stampIn, stampOut)):
            return

        phpsessid = self.createSession()

        opener = urllib2.build_opener()
        opener.addheaders.append(('Cookie', 'PHPSESSID=' + phpsessid))
        f = opener.open('https://' + self.baseUrl + '/stampinout/index/status/' + str(status))
        message = json.loads(f.read())['message']

        self.stored['lastStamp'] = {
            'time': int(time.time()),
            'status': 'in' if (status == stampIn) else 'out',
            'message': message
        }

    def createSession(self):
        post_data = {
            "username": self.username,
            "password": self.password,
            "login": "Login"
        }
        cj = cookielib.CookieJar()
        opener = urllib2.build_opener(urllib2.HTTPCookieProcessor(cj))
        urllib2.install_opener(opener)
        data = urllib.urlencode(post_data)
        req = urllib2.Request('https://' + self.baseUrl + '/auth', data)
        resp = urllib2.urlopen(req)
        headers = resp.info()

        PHPSESSID = cj._cookies[self.baseUrl]['/']['PHPSESSID'].value
        
        return PHPSESSID

def humanReadable(seconds):
    units = [ "d", "h", "m", "s" ]
    unitSeconds = [ 86400, 3600, 60, 1 ]
    ret = []
    for i, s in enumerate(unitSeconds):
        if (seconds > s or len(ret) > 0):
            ret.append(str(int(seconds / s)) + units[i])
            seconds = seconds % s
    return ' '.join(ret)

def main():
    config = SafeConfigParser()
    config.read(os.path.join(os.path.abspath(os.path.dirname(__file__)), 'timesystem.ini'))
    ts = TimeSystem(config.get('main', 'username'), config.get('main', 'password'), config.get('main', 'cachefile'))

    if ts.getLastActive() - ts.getPrevLastActive() > stampInThresholdHours * 60 * 60:
        ts.stamp(stampIn)
        text = 'Stamped {}: {}'.format(ts.getLastStatus(), ts.getLastMessage())
    else:
        text = 'Stamped {} {} ago (message: {})'.format(ts.getLastStatus(), humanReadable(int(time.time()) - ts.getLastStampTime()), ts.getLastMessage())

    ts.save()

    print text

if __name__ == '__main__':
    main()