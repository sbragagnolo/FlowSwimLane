"
A case is a an object related with the multiConditional tasks: each case counts with a matching value and with a related flow. 
"
Class {
	#name : #FLWCase,
	#superclass : #Object,
	#instVars : [
		'value',
		'flow'
	],
	#category : #'FlowSwimLane-Kernel'
}

{ #category : #accessing }
FLWCase >> acceptVisitor: aVisitor [
	aVisitor visitCase: self
]

{ #category : #accessing }
FLWCase >> flow: aFLWFlow [
	flow := aFLWFlow
]

{ #category : #accessing }
FLWCase >> value: aString [
	value := aString asSymbol
]
