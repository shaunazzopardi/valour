/*
 * generated by Xtext 2.9.2
 */
package mt.edu.um.cs.rv.idea

import org.eclipse.xtext.ISetup
import org.eclipse.xtext.idea.extensions.EcoreGlobalRegistries

class ValourIdeaSetup implements ISetup {

	override createInjectorAndDoEMFRegistration() {
		EcoreGlobalRegistries.ensureInitialized
		new ValourStandaloneSetupIdea().createInjector
	}

}
