/*
 * generated by Xtext 2.9.2
 */
package mt.edu.um.cs.rv.idea.lang.psi.impl;

import com.intellij.openapi.fileTypes.FileType;
import com.intellij.psi.FileViewProvider;
import mt.edu.um.cs.rv.idea.lang.ValourFileType;
import mt.edu.um.cs.rv.idea.lang.ValourLanguage;
import org.eclipse.xtext.psi.impl.BaseXtextFile;

public final class ValourFileImpl extends BaseXtextFile {

	public ValourFileImpl(FileViewProvider viewProvider) {
		super(viewProvider, ValourLanguage.INSTANCE);
	}

	@Override
	public FileType getFileType() {
		return ValourFileType.INSTANCE;
	}
}
