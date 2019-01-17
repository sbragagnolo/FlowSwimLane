"
A conditional path represents the connection in between one flow and two others, representing the final state of a flow, and the connection to the starting tasks of other two flows. This kind of task may be used for building behaviours equivalents to 'If', 'While', 'DoWhile' .


   Flow 1                                              / Flow1.A [ [ Start Task ] -next-> [ Task ] -next-> ... -next-> [ End ]]
   [... - next -> [ Task ] -next-> [ Conditional ? ]]
 										                        \ Flow1.B [ [ Start Task ] -next-> [ Task ] -next-> ... -next-> [ End ]]
"
Class {
	#name : #FLWConditionalTask,
	#superclass : #FLWInbetweenTask,
	#instVars : [
		'truePath',
		'falsePath'
	],
	#category : #'FlowSwimLane-Kernel'
}

{ #category : #visiting }
FLWConditionalTask >> acceptVisitor: aVisitor [
	aVisitor visitConditionalTask: self
]

{ #category : #accessing }
FLWConditionalTask >> falsePath [
	^ falsePath
]

{ #category : #accessing }
FLWConditionalTask >> falsePath: aFLWFlow [ 
	falsePath := aFLWFlow
]

{ #category : #testing }
FLWConditionalTask >> flows [
	^ {falsePath.
	truePath}
]

{ #category : #testing }
FLWConditionalTask >> hasNext [
	^ false 
]

{ #category : #accessing }
FLWConditionalTask >> isConditionalTask [
	^ true
]

{ #category : #accessing }
FLWConditionalTask >> next: aFLWTask [
	^ FLWError signal: 'Conditional states are final states in this diagram'
]

{ #category : #accessing }
FLWConditionalTask >> truePath [
	^ truePath
]

{ #category : #accessing }
FLWConditionalTask >> truePath: aFLWFlow [
	aFLWFlow ifNil: [ self halt ].
	truePath := aFLWFlow
]
