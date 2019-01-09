"
A document is production of the system. Is used for transmitting information and as session of control. 
Order, invoice, etc, 
"
Class {
	#name : #FLWDocument,
	#superclass : #Object,
	#instVars : [
		'name',
		'properties'
	],
	#category : #'FlowSwimLane-Kernel'
}

{ #category : #accessing }
FLWDocument >> acceptVisitor: aVisitor [
	aVisitor visitDocuments: self
]

{ #category : #accessing }
FLWDocument >> initialize [
	super initialize.
	properties := Dictionary new
]

{ #category : #testing }
FLWDocument >> isDocument [
	^ true 
]

{ #category : #accessing }
FLWDocument >> isEmpty [
	^ properties isEmpty
]

{ #category : #accessing }
FLWDocument >> name [
	^ name
]

{ #category : #accessing }
FLWDocument >> name: aString [ 
	name := aString
]
