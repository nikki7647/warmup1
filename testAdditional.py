"""
Each file that starts with test... in this directory is scanned for subclasses of unittest.TestCase or testLib.RestTestCase
"""

import unittest
import os
import testLib


class AddTwiceTest(testLib.RestTestCase):
    def testUnit(self):
        req1 = self.makeRequest("/users/add", method="POST", data={'user':'1', 'password':'asdf'})
        req2 = self.makeRequest("/users/add", method="POST", data={'user':'1', 'password':'asdf'})
        self.assertEquals(req2['errCode'],-2)

class OverSizedPasswordTest(testLib.RestTestCase):
    def testUnit(self):
        req1 = self.makeRequest("/users/add", method="POST", data={'user':'1', 'password':' aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'})
        self.assertEquals(req1['errCode'],-4)

class EmptyPasswordTest(testLib.RestTestCase):
    def testUnit(self):
        req1 = self.makeRequest("/users/add", method="POST", data={'user':'1', 'password':''})
        self.assertEquals(req1['errCode'],1)

class OverSizedUsernameTest(testLib.RestTestCase):
    def testUnit(self):
        req1 = self.makeRequest("/users/add", method="POST", data={'user':'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa', 'password':'asdf'})
        self.assertEquals(req1['errCode'],-4)
        
class EmptyUsernameTest(testLib.RestTestCase):
    def testUnit(self):
        req1 = self.makeRequest("/users/add", method="POST", data={'user':'', 'password':'asdf'})
        self.assertEquals(req1['errCode'],-3)
        
class LoginTest(testLib.RestTestCase):
    def testUnit(self):
        req1 = self.makeRequest("/users/add", method="POST", data={'user':'1', 'password':'asdf'})
        req2 = self.makeRequest("/users/login", method="POST", data={'user':'1', 'password':'asdf'})
        self.assertEquals(req2['errCode'],1)

class WrongUsernameLoginTest(testLib.RestTestCase):
    def testUnit(self):
        req1 = self.makeRequest("/users/add", method="POST", data={'user':'2', 'password':'asdf})
        req2 = self.makeRequest("/users/login", method="POST", data={'user':'1', 'password':'asdf'})
        self.assertEquals(req2['errCode'],-1)
                                                                   
class WrongPasswordLoginTest(testLib.RestTestCase):
    def testUnit(self):
        req1 = self.makeRequest("/users/add", method="POST", data={'user':'1', 'password':'asdf})
        req2 = self.makeRequest("/users/login", method="POST", data={'user':'1', 'password':'ghjk'})
        self.assertEquals(req2['errCode'],-1)

class IncrementationTest():
    def testUnit(self):
        req1 = self.makeRequest("/users/add", method="POST", data={'user':'1', 'password':'asdf'})
        req2 = self.makeRequest("/users/login", method="POST", data={'user':'1', 'password':'asdf'})
        self.assertEquals(req2['count'],2)

