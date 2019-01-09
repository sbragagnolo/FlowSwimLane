"
A conditional path represents the connection in between one flow and n others, representing the final state of a flow, and the connection to the starting tasks of other n flows. 
   This construction is handy to implement 'switch case'

   Flow 1                                              | Flow1.A [ [ Start Task ] -next-> [ Task ] -next-> ... -next-> [ End ]]
   [... - next -> [ Task ] -next-> [ Conditional ? ]]  | Flow1.B [ [ Start Task ] -next-> [ Task ] -next-> ... -next-> [ End ]]
                                                       | Flow1.C [ [ Start Task ] -next-> [ Task ] -next-> ... -next-> [ End ]]
"
Class {
	#name : #FLWMultiConditionalTask,
	#superclass : #FLWAbstractTask,
	#instVars : [
		'cases'
	],
	#category : #'FlowSwimLane-Kernel'
}

{ #category : #testing }
FLWMultiConditionalTask >> acceptVisitor: aVisitor [
	aVisitor visitMultipleConditionalTask: self
]

{ #category : #accessing }
FLWMultiConditionalTask >> cases: aFLWMultiConditionalTaskFlowBuilder [ 
	cases := aFLWMultiConditionalTaskFlowBuilder
]

{ #category : #testing }
FLWMultiConditionalTask >> hasNext [
	^ false 
]

{ #category : #testing }
FLWMultiConditionalTask >> isConditionalTask [
	^ true
]

{ #category : #testing }
FLWMultiConditionalTask >> next: aFLWTask [
	^ FLWError signal: 'Conditional states are final states in this diagram'
]
