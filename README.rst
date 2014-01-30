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

  git https://github.com/ploneUN/roapksp.buildout
  cd roapksp.buildout
  python2.6 bootstrap.py
  ./bin/buildout -vvvv 

For deployment::

  git https://github.com/ploneUN/roapksp.buildout
  cd roapksp.buildout
  python2.6 bootstrap.py
  ./bin/buildout -vvvv -c deployment.cfg


Notes
-----

Installing docsplit
~~~~~~~~~~~~~~~~~~~

http://documentcloud.github.io/docsplit

Install docsplit with rubygems ::

        gem install --version '0.6.4' docsplit
