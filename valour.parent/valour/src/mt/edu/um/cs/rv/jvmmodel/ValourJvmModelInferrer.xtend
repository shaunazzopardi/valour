/*
 * generated by Xtext 2.9.2
 */
package mt.edu.um.cs.rv.jvmmodel

import com.google.inject.Inject
import com.google.inject.Provider
import java.util.List
import mt.edu.um.cs.rv.jvmmodel.handler.InferrerHandler
import mt.edu.um.cs.rv.valour.Action
import mt.edu.um.cs.rv.valour.AdditionalTrigger
import mt.edu.um.cs.rv.valour.CategorisationClause
import mt.edu.um.cs.rv.valour.Condition
import mt.edu.um.cs.rv.valour.Declarations
import mt.edu.um.cs.rv.valour.Event
import mt.edu.um.cs.rv.valour.EventBody
import mt.edu.um.cs.rv.valour.ForEach
import mt.edu.um.cs.rv.valour.Model
import mt.edu.um.cs.rv.valour.ParForEach
import mt.edu.um.cs.rv.valour.Rule
import mt.edu.um.cs.rv.valour.Rules
import mt.edu.um.cs.rv.valour.SimpleTrigger
import mt.edu.um.cs.rv.valour.StateBlock
import mt.edu.um.cs.rv.valour.ValourBody
import mt.edu.um.cs.rv.valour.WhenClause
import mt.edu.um.cs.rv.valour.WhereClauses
import org.eclipse.xtext.common.types.JvmDeclaredType
import org.eclipse.xtext.naming.IQualifiedNameProvider
import org.eclipse.xtext.xbase.jvmmodel.AbstractModelInferrer
import org.eclipse.xtext.xbase.jvmmodel.IJvmDeclaredTypeAcceptor
import org.eclipse.xtext.xbase.jvmmodel.IJvmModelAssociations
import org.eclipse.xtext.xbase.jvmmodel.JvmTypesBuilder
import org.eclipse.xtext.xbase.jvmmodel.JvmTypeReferenceBuilder
import org.eclipse.xtext.xbase.jvmmodel.JvmAnnotationReferenceBuilder

/**
 * <p>Infers a JVM model from the source model.</p> 
 * 
 * <p>The JVM model should contain all elements that would appear in the Java code 
 * which is generated from the source model. Other models link against the JVM model rather than the source model.</p>     
 */
class ValourJvmModelInferrer extends AbstractModelInferrer {

	/**
	 * convenience API to build and initialize JVM types and their members.
	 */
	@Inject extension JvmTypesBuilder

	@Inject extension IJvmModelAssociations

	@Inject extension IQualifiedNameProvider

	@Inject Provider<List<InferrerHandler>> inferrerHandlersProvider

	/**
	 * The dispatch method {@code infer} is called for each instance of the
	 * given element's type that is contained in a resource.
	 * 
	 * @param element
	 *            the model to create one or more
	 *            {@link JvmDeclaredType declared
	 *            types} from.
	 * @param acceptor
	 *            each created
	 *            {@link JvmDeclaredType type}
	 *            without a container should be passed to the acceptor in order
	 *            get attached to the current resource. The acceptor's
	 *            {@link IJvmDeclaredTypeAcceptor#accept(org.eclipse.xtext.common.types.JvmDeclaredType)
	 *            accept(..)} method takes the constructed empty type for the
	 *            pre-indexing phase. This one is further initialized in the
	 *            indexing phase using the closure you pass to the returned
	 *            {@link IPostIndexingInitializing#initializeLater(org.eclipse.xtext.xbase.lib.Procedures.Procedure1)
	 *            initializeLater(..)}.
	 * @param isPreIndexingPhase
	 *            whether the method is called in a pre-indexing phase, i.e.
	 *            when the global index is not yet fully updated. You must not
	 *            rely on linking using the index if isPreIndexingPhase is
	 *            <code>true</code>.
	 */
	def dispatch void infer(Model element, IJvmDeclaredTypeAcceptor acceptor, boolean isPreIndexingPhase) {
		// Here you explain how your model is mapped to Java elements, by writing the actual translation code.
		// An implementation for the initial hello world example could look like this:
//   		acceptor.accept(element.toClass("my.company.greeting.MyGreetings")) [
//   			for (greeting : element.greetings) {
//   				members += greeting.toMethod("hello" + greeting.name, typeRef(String)) [
//   					body = '''
//							return "Hello «greeting.name»";
//   					'''
//   				]
//   			}
//   		]


		if (!isPreIndexingPhase) {
			val List<InferrerHandler> inferrerHandlers = inferrerHandlersProvider.get
			inferrerHandlers.forEach[
				setup(this._annotationTypesBuilder, this._typeReferenceBuilder)
				//initialise
				initialise(element, acceptor)
				//and call handle imports
				handleImports(element.imports)
			]

			handleValourBody(element.body, inferrerHandlers)
		}
	}

	def void handleValourBody(ValourBody vb, List<InferrerHandler> inferrerHandlers) {
		// handle declarations
		if (vb.declarations != null) {
			handleDeclarations(vb.declarations, inferrerHandlers)
		}

		// handle rules
		if (vb.rules != null) {
			handleRules(vb.rules, inferrerHandlers)
		}
	}

	def void handleDeclarations(Declarations declarations, List<InferrerHandler> inferrerHandlers) {
		if (declarations.declarations != null && declarations.declarations.length > 0) {
			inferrerHandlers.forEach[handleDeclarationsBlockStart]
			
			for (d : declarations.declarations) {
				if (d.category != null) {
					inferrerHandlers.forEach[handleCategoryDeclaration(d.category)]
				} else if (d.event != null) {
					handleEventDeclaration(d.event, inferrerHandlers)
				} else if (d.condition != null) {
					handleConditionDeclaration(d.condition, inferrerHandlers)
				} else if (d.action != null) {
					handleActionDeclaration(d.action, inferrerHandlers)
				}
			}
			
			inferrerHandlers.forEach[handleDeclarationsBlockEnd]
		}
	}

	def void handleEventDeclaration(Event event, List<InferrerHandler> inferrerHandlers) {

		inferrerHandlers.forEach[handleEventDeclarationBegin(event)]

		handleEventBody(event.eventBody, inferrerHandlers)
		
		inferrerHandlers.forEach[handleEventDeclarationEnd(event)]
	}
	
	def void handleEventBody(EventBody eventBody, List<InferrerHandler> inferrerHandlers) {
		
		handleSimpleTrigger(eventBody.trigger, false, inferrerHandlers)
		if (eventBody.additionalTrigger != null) {
			handleAdditionalTrigger(eventBody.additionalTrigger, inferrerHandlers)
		}

		if (eventBody.where != null) {
			handleWhereClauses(eventBody.where, inferrerHandlers)
		}

		if (eventBody.when != null) {
			handleWhen(eventBody.when, inferrerHandlers)
		}

		if (eventBody.categorisation != null) {
			handleCategorisation(eventBody.categorisation, inferrerHandlers)
		}
		
	}

	def void handleSimpleTrigger(SimpleTrigger simpleTrigger, Boolean additionalTrigger, List<InferrerHandler> inferrerHandlers) {
		if (simpleTrigger.controlFlowTrigger != null) {
			inferrerHandlers.forEach[handleControlFlowTrigger(simpleTrigger.controlFlowTrigger, additionalTrigger)]
		} else if (simpleTrigger.eventTrigger != null) {
			inferrerHandlers.forEach[handleEventTrigger(simpleTrigger.eventTrigger, additionalTrigger)]
		} else if (simpleTrigger.monitorTrigger != null) {
			inferrerHandlers.forEach[handleMonitorTrigger(simpleTrigger.monitorTrigger, additionalTrigger)]
		}

		if (simpleTrigger.whereClauses != null) {
			handleWhereClauses(simpleTrigger.whereClauses, inferrerHandlers)
		}
	}
	
	def void handleAdditionalTrigger(AdditionalTrigger additionalTrigger, List<InferrerHandler> inferrerHandlers) {
		handleSimpleTrigger(additionalTrigger.trigger, true, inferrerHandlers)

		if (additionalTrigger.additionalTrigger != null) {
			handleAdditionalTrigger(additionalTrigger.additionalTrigger, inferrerHandlers)
		}
	}
	
	
	
	def void handleConditionDeclaration(Condition condition, List<InferrerHandler> inferrerHandlers) {
		
		inferrerHandlers.forEach[handleConditionDeclarationStart(condition)]
		
		inferrerHandlers.forEach[handleConditionDeclarationExpression(condition)]
			
		inferrerHandlers.forEach[handleConditionDeclarationEnd(condition)]

//		val conditionsClass = scaffoldClass.findAllNestedTypesByName("Conditions").findFirst[true]
//		conditionsClass.members += condition.toMethod(
//			condition.name,
//			typeRef(Boolean),
//			[
//				static = true
//				visibility = JvmVisibility.PUBLIC
//				for (p : condition.conditionFormalParameters.parameters) {
//					parameters += p.toParameter(p.name, p.parameterType)
//				}
//
//				body = handleConditionExpression(condition.conditionExpression)
//			]
//		)
	}

	def void handleActionDeclaration(Action action, List<InferrerHandler> inferrerHandlers) {
		
		inferrerHandlers.forEach[handleActionDeclarationStart(action)]
		
		inferrerHandlers.forEach[handleActionDeclarationActionBlock(action)]
			
		inferrerHandlers.forEach[handleActionDeclarationEnd(action)]

//		val actionsClass = scaffoldClass.findAllNestedTypesByName("Actions").findFirst[true]
//		actionsClass.members += action.toMethod(
//			action.name,
//			typeRef(void),
//			[
//				static = true
//				visibility = JvmVisibility.PUBLIC
//				for (p : action.actionFormalParameters.parameters) {
//					parameters += p.toParameter(p.name, p.parameterType)
//				}
//
//				body = handleActionBlock(action.action as ActionBlock)
//			]
//		)
	}


	def void handleWhereClauses(WhereClauses whereClauses, List<InferrerHandler> inferrerHandlers) {
		
		inferrerHandlers.forEach[handleWhereClausesStart(whereClauses)]
		
		for (whereClause : whereClauses.clauses) {
			inferrerHandlers.forEach[handleWhereClause(whereClause)]
		}
		
		inferrerHandlers.forEach[handleWhereClausesEnd(whereClauses)]
	}
	
	def void handleWhen(WhenClause whenClause, List<InferrerHandler> inferrerHandlers) {
		inferrerHandlers.forEach[handleWhenClauseStart(whenClause)]

		inferrerHandlers.forEach[handleWhenClauseExpression(whenClause)]
		
		inferrerHandlers.forEach[handleWhenClauseEnd(whenClause)]
	}
	

	def void handleCategorisation(CategorisationClause categorisationClause, List<InferrerHandler> inferrerHandlers) {
		inferrerHandlers.forEach[handleCategorisationClauseStart(categorisationClause)]

		inferrerHandlers.forEach[handleCategorisationClauseExpression(categorisationClause)]
		
		inferrerHandlers.forEach[handleCategorisationClauseEnd(categorisationClause)]
	}


	def void handleRules(Rules rules, List<InferrerHandler> inferrerHandlers) {
		for (rule : rules.rules) {
			handleRule(rule, inferrerHandlers)
		}
	}

	def void handleRule(Rule rule, List<InferrerHandler> inferrerHandlers) {
		
		inferrerHandlers.forEach[handleRuleStart(rule)]
		
		if (rule.basicRule != null) {
			inferrerHandlers.forEach[handleBasicRule(rule.basicRule)]
		}

		if (rule.stateBlock != null) {
			handleStateBlock(rule.stateBlock, inferrerHandlers)
		}

		if (rule.forEach != null) {
			handleForEach(rule.forEach, inferrerHandlers)
		}

		if (rule.parForEach != null) {
			handleParForEach(rule.parForEach, inferrerHandlers)
		}
		
		inferrerHandlers.forEach[handleRuleEnd(rule)]
	}
	
	
	def handleStateBlock(StateBlock stateBlock, List<InferrerHandler> inferrerHandlers) {
		
		inferrerHandlers.forEach[handleStateBlockStart(stateBlock)]
		
		for (stateDeclaration : stateBlock.stateDec) {
			inferrerHandlers.forEach[handleStateDeclaration(stateDeclaration)]
		}
		
		inferrerHandlers.forEach[handleStateBlockStateDeclarationsEnd(stateBlock)]
		
		handleValourBody(stateBlock.valourBody, inferrerHandlers)
		
		inferrerHandlers.forEach[handleStateBlockEnd(stateBlock)]
	}
	

	def handleForEach(ForEach forEach, List<InferrerHandler> inferrerHandlers) {
		inferrerHandlers.forEach[handleForEachBlockStart(forEach)]
			
		for (stateDeclaration : forEach.stateDec) {
			inferrerHandlers.forEach[handleStateDeclaration(stateDeclaration)]
		}
		
		inferrerHandlers.forEach[handleForEachCategoryDefinitionStart(forEach)]
	
		handleValourBody(forEach.valourBody, inferrerHandlers)
		
		inferrerHandlers.forEach[handleForEachBlockEnd(forEach)]
	
	}

	def handleParForEach(ParForEach parForEach, List<InferrerHandler> inferrerHandlers) {
		inferrerHandlers.forEach[handleParForEachBlockStart(parForEach)]
		
		for (stateDeclaration : parForEach.stateDec) {
			inferrerHandlers.forEach[handleStateDeclaration(stateDeclaration)]
		}
		inferrerHandlers.forEach[handleParForEachCategoryDefinitionStart(parForEach)]
		
		handleValourBody(parForEach.valourBody, inferrerHandlers)
		inferrerHandlers.forEach[handleParForEachBlockEnd(parForEach)]
		
	}

}
