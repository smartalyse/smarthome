/*
 * generated by Xtext
 */
package org.eclipse.smarthome.model.ui.contentassist


import java.util.Set
import org.eclipse.emf.ecore.EObject
import org.eclipse.smarthome.core.items.GroupItem
import org.eclipse.smarthome.core.items.Item
import org.eclipse.smarthome.core.items.ItemRegistry
import org.eclipse.smarthome.designer.ui.UIActivator
import org.eclipse.xtext.Assignment
import org.eclipse.xtext.ui.editor.contentassist.ContentAssistContext
import org.eclipse.xtext.ui.editor.contentassist.ICompletionProposalAcceptor


/**
 * see http://www.eclipse.org/Xtext/documentation.html#contentAssist on how to customize content assistant
 */
class ItemsProposalProvider extends AbstractItemsProposalProvider {
	protected static final Set<String> ITEMTYPES = newHashSet("Group", "Switch", "Number", "String", "Dimmer", "Color", "Contact", "Rollershutter", "DateTime", "Location")

	override void completeModelNormalItem_Type(EObject model,
			Assignment assignment, ContentAssistContext context,
			ICompletionProposalAcceptor acceptor) {
		super.completeModelNormalItem_Type(model, assignment, context, acceptor);
		for(String itemType : ITEMTYPES) {
			if(itemType.startsWith(context.getPrefix())) {
				acceptor.accept(createCompletionProposal(itemType, context));
			}
		}
	}

	override void completeModelItem_Groups(EObject model, Assignment assignment,
			ContentAssistContext context, ICompletionProposalAcceptor acceptor) {
		super.completeModelItem_Groups(model, assignment, context, acceptor);

		val registry = UIActivator.itemRegistryTracker.getService() as ItemRegistry
		if(registry!=null) {
			for(Item item : registry.getItems(context.getPrefix() + "*")) {
				if(item instanceof GroupItem) {
					val completionProposal = createCompletionProposal(item.getName(), context);
					acceptor.accept(completionProposal);
				}
			}
		}
	
	}
}
