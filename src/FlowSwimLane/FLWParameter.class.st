"
A parameter is an object that defines the relation of requirement of a task. 
"
Class {
	#name : #FLWParameter,
	#superclass : #Object,
	#instVars : [
		'name'
	],
	#category : #'FlowSwimLane-Kernel'
}

{ #category : #testing }
FLWParameter >> acceptVisitor: aVisitor [
	aVisitor visitParameter: self
]

{ #category : #testing }
FLWParameter >> isDocument [
	^ false
]

{ #category : #accessing }
FLWParameter >> name [
	^ name
]

{ #category : #accessing }
FLWParameter >> name: aString [
	name := aString
]
