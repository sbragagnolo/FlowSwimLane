"
The role is the reification of the aspect of responsibility 
"
Class {
	#name : #FLWRole,
	#superclass : #Object,
	#instVars : [
		'name'
	],
	#category : #'FlowSwimLane-Kernel'
}

{ #category : #accessing }
FLWRole >> acceptVisitor: aVisitor [
	aVisitor visitActor: self
]

{ #category : #accessing }
FLWRole >> name [
	^ name
]

{ #category : #accessing }
FLWRole >> name: aString [ 
	name := aString
]
