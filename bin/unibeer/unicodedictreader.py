#!/usr/bin/python

import csv, codecs

class UnicodeDictReader( object ):
	def __init__( self, *args, **kw ):
		self.encoding = kw.pop('encoding', 'latin-1')
		print self.encoding
		self.reader = csv.DictReader( *args, **kw )
	def __iter__( self ):
		decode = codecs.getdecoder( self.encoding )
		for row in self.reader:
			t = dict( (k,decode(row[k])[0]) for k in row )
			yield t
