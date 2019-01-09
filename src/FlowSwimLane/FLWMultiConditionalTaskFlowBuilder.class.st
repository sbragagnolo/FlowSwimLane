Class {
	#name : #FLWMultiConditionalTaskFlowBuilder,
	#superclass : #Object,
	#instVars : [
		'flowBuilder',
		'cases'
	],
	#category : #'FlowSwimLane-Building'
}

{ #category : #building }
FLWMultiConditionalTaskFlowBuilder >> build [
	^ cases
]

{ #category : #buildinFlows }
FLWMultiConditionalTaskFlowBuilder >> case: aString then: aBlockClosure [
	| case builder |
	case := FLWCase new.
	case value: aString.
	builder := flowBuilder new.
	aBlockClosure value: builder.
	builder isLooping
		ifTrue: [ ^ FLWError signal: 'Looping tasks are forbidden in multi-conditional tasks. Use simple conditional ' ].
	case flow: builder internalBuild.
	cases add: case.
	^ case
]

{ #category : #accessing }
FLWMultiConditionalTaskFlowBuilder >> flowBuilder: aClass [
	flowBuilder := aClass
]

{ #category : #building }
FLWMultiConditionalTaskFlowBuilder >> initialize [
	super initialize.
	cases := OrderedCollection new
]

{ #category : #case }
FLWMultiConditionalTaskFlowBuilder >> otherwise: aBlockClosure [
	^ self case: #OtherWise then: aBlockClosure
]
