Upgrading from Plone 3 to Plone 4
==================================

ILO KSP (intranet)
===================

1. To ensure smooth running, please clear and rebuild index to clear out broken
   contents

#. remove project_workflow from portal_workflow. (NOTE: not sure what this will
   break)

#. open intranet/@@upgrade-plone and run migrator

#. open intranet/portal_skins/manage_properties and change default skin to
   sunburst

#. open intranet/portal_kss/manage_kssForm and remove
   ++resource++navigation.kss

#. open intranet/portal_quickinstaller/manage_installProductsForm and reinstall these
   products according to order below:

   1) Kupu
   #) ContentWellPortlets
   #) CompoundField
   #) Attachment Support
   #) All the rest that need upgrade, except Ploneboard and ILO Theme

#. Uninstall Ploneboard

#. Go to /intranet/kupu_library_tool/zmi_resource_types and save 'Map resource
   types' settings (this is to remove Ploneboard from linkable type)

#  open intranet/portal_quickinstaller/manage_installProductsForm and reinstall
   Ploneboard

#. delete portal_calendar, and create a new one using 'CMF Calendar Tool'

#. clear and rebuild catalog
