Class {
	#name : #FLWSelector,
	#superclass : #Object,
	#instVars : [
		'task',
		'deployment',
		'selector'
	],
	#category : #'FlowSwimLane-Query'
}

{ #category : #defaults }
FLWSelector class >> default [
	^ #default
]

{ #category : #accessing }
FLWSelector >> = anOtherSelector [
	^ anOtherSelector species = self species
		and: [ task = anOtherSelector task and: [ deployment = anOtherSelector deployment ] ]
]

{ #category : #accessing }
FLWSelector >> deployment [
	^ deployment
]

{ #category : #accessing }
FLWSelector >> deployment: anObject [
	deployment := anObject
]

{ #category : #accessing }
FLWSelector >> hash [
	^ (task hash bitXor: deployment hash) bitXor: selector hash
]

{ #category : #accessing }
FLWSelector >> initializeWith: aPragma [
	aPragma keyword = #task:
		ifTrue: [ ^ self task: aPragma arguments first method: aPragma method ].
	aPragma keyword = #task:deployment:
		ifTrue:
			[ ^ self task: aPragma arguments first deployment: aPragma arguments second method: aPragma method ].
	FLWError signal: 'Unexected pragma keyword: ' , aPragma keyword
]

{ #category : #accessing }
FLWSelector >> satisfy: anOtherSelector [
	^ self = anOtherSelector 
]

{ #category : #accessing }
FLWSelector >> selector [
	^ selector
]

{ #category : #accessing }
FLWSelector >> task [
	^ task
]

{ #category : #accessing }
FLWSelector >> task: anObject [
	task := anObject
]

{ #category : #initializing }
FLWSelector >> task: aString deployment: aString2 method: aMethod [
	task := aString.
	deployment := aString2.
	selector := aMethod selector
]

{ #category : #initializing }
FLWSelector >> task: aString method: aCollection [ 
	^ self task: aString deployment: self class default method: aCollection 
]
