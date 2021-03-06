package mt.edu.um.cs.rv.compilation

import javax.inject.Inject
import org.eclipse.xtext.common.types.TypesFactory
import org.eclipse.xtext.common.types.JvmAnnotationReference
import org.eclipse.xtext.common.types.JvmTypeReference
import org.eclipse.xtext.common.types.util.TypeReferences
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.common.types.JvmType
import org.eclipse.xtext.common.types.JvmAnnotationType
import java.util.HashMap
import org.eclipse.xtext.common.types.JvmTypeAnnotationValue
import org.eclipse.xtext.common.types.JvmStringAnnotationValue
import org.eclipse.xtext.common.types.JvmBooleanAnnotationValue

class ValourAnnotationDecorator {

	@Inject
	private TypeReferences references;

	@Inject
	private TypesFactory typesFactory;

	def toAnnotationRef(EObject context, String annotationTypeName, Pair<String, JvmTypeReference> ... values) {
		val JvmAnnotationReference result = typesFactory.createJvmAnnotationReference();
		val JvmType jvmType = references.findDeclaredType(annotationTypeName, context);
		if (jvmType == null) {
			throw new IllegalArgumentException("The type " + annotationTypeName + " is not on the classpath.");
		}
		if (!(jvmType instanceof JvmAnnotationType)) {
			throw new IllegalArgumentException("The given class " + annotationTypeName + " is not an annotation type.");
		}
		val jvmAnnotationType = jvmType as JvmAnnotationType

		result.setAnnotation(jvmAnnotationType)

		val valueMap = new HashMap()

		for (value : values) {

			val JvmTypeAnnotationValue annoValue = valueMap.computeIfAbsent(value.key, [ k |
				val JvmTypeAnnotationValue annoValue = typesFactory.createJvmTypeAnnotationValue
				annoValue.operation = jvmAnnotationType.declaredOperations.findFirst[simpleName == value.key]
				result.explicitValues.add(annoValue)
				annoValue
			])

			annoValue.values += value.value

		}

		return result
	}

	def toAnnotationRefMultipleValues(EObject context, String annotationTypeName, Pair<String, JvmTypeReference[]> ... values) {
		val JvmAnnotationReference result = typesFactory.createJvmAnnotationReference();
		val JvmType jvmType = references.findDeclaredType(annotationTypeName, context);
		if (jvmType == null) {
			throw new IllegalArgumentException("The type " + annotationTypeName + " is not on the classpath.");
		}
		if (!(jvmType instanceof JvmAnnotationType)) {
			throw new IllegalArgumentException("The given class " + annotationTypeName + " is not an annotation type.");
		}
		val jvmAnnotationType = jvmType as JvmAnnotationType

		result.setAnnotation(jvmAnnotationType)

		val valueMap = new HashMap()

		for (value : values) {

			val JvmTypeAnnotationValue annoValue = valueMap.computeIfAbsent(value.key, [ k |
				val JvmTypeAnnotationValue annoValue = typesFactory.createJvmTypeAnnotationValue
				annoValue.operation = jvmAnnotationType.declaredOperations.findFirst[simpleName == value.key]
				result.explicitValues.add(annoValue)
				annoValue
			])

			annoValue.values += value.value


		}

		return result
	}
	
	def toAnnotationRefWithStringPair(EObject context, String annotationTypeName, Pair<String, String> ... values) {
		val JvmAnnotationReference result = typesFactory.createJvmAnnotationReference();
		val JvmType jvmType = references.findDeclaredType(annotationTypeName, context);
		if (jvmType == null) {
			throw new IllegalArgumentException("The type " + annotationTypeName + " is not on the classpath.");
		}
		if (!(jvmType instanceof JvmAnnotationType)) {
			throw new IllegalArgumentException("The given class " + annotationTypeName + " is not an annotation type.");
		}
		val jvmAnnotationType = jvmType as JvmAnnotationType

		result.setAnnotation(jvmAnnotationType)

		val valueMap = new HashMap()

		for (value : values) {

			val JvmStringAnnotationValue annoValue = valueMap.computeIfAbsent(value.key, [ k |
				val JvmStringAnnotationValue annoValue = typesFactory.createJvmStringAnnotationValue
				annoValue.operation = jvmAnnotationType.declaredOperations.findFirst[simpleName == value.key]
				result.explicitValues.add(annoValue)
				annoValue
			])

			annoValue.values += value.value

		}

		return result
	}
	
	def toAnnotationRefWithStringBooleanPair(EObject context, String annotationTypeName, Pair<String, Boolean> ... values) {
		val JvmAnnotationReference result = typesFactory.createJvmAnnotationReference();
		val JvmType jvmType = references.findDeclaredType(annotationTypeName, context);
		if (jvmType == null) {
			throw new IllegalArgumentException("The type " + annotationTypeName + " is not on the classpath.");
		}
		if (!(jvmType instanceof JvmAnnotationType)) {
			throw new IllegalArgumentException("The given class " + annotationTypeName + " is not an annotation type.");
		}
		val jvmAnnotationType = jvmType as JvmAnnotationType

		result.setAnnotation(jvmAnnotationType)

		val valueMap = new HashMap()

		for (value : values) {

			val JvmBooleanAnnotationValue annoValue = valueMap.computeIfAbsent(value.key, [ k |
				val JvmBooleanAnnotationValue annoValue = typesFactory.createJvmBooleanAnnotationValue
				annoValue.operation = jvmAnnotationType.declaredOperations.findFirst[simpleName == value.key]
				result.explicitValues.add(annoValue)
				annoValue
			])

			annoValue.values += value.value

		}

		return result
	}
	
}
