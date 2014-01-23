ILO Regional Office of Asia and Pacific Knowledge Sharing Portal
=================================================================

Plone buildout for roap-ksp.ilo.org. 


Requirements
-------------

* Linux/\*NIX system

* Python2.6

* LibreOffice headless

* poppler-utils

* docsplit 0.6.4

* ejabberd-2.1.12

Deploying
----------

For development::

  svn co https://dev.inigo-tech.com/svn/ilo/buildout/trunk ksp
  cd ksp
  python2.6 bootstrap.py
  ./bin/buildout -vvvv 

For deployment::

  svn co https://dev.inigo-tech.com/svn/ilo/buildout/trunk ksp
  cd ksp
  python2.6 bootstrap.py
  ./bin/buildout -vvvv -c deployment.cfg


