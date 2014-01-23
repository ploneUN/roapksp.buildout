from setuptools import setup, find_packages
import sys,os

version = '0.1.4'

long_description = ''

setup(name='ilo.intranet',
      version=version,
      description="ILO Intranet",
      long_description=long_description,
      # Get more strings from http://www.python.org/pypi?%3Aaction=list_classifiers
      classifiers=[
        "Programming Language :: Python",
        "Topic :: Software Development :: Libraries :: Python Modules",
        ],
      keywords='',
      author='',
      author_email='',
      url='http://www.ilobkk.or.th',
      license='GPL',
      packages=find_packages('src',exclude=['ez_setup', 'var']),
      namespace_packages=['ilo'],
      package_dir={'': 'src'},
      include_package_data=True,
      zip_safe=False,
      install_requires=[
          'setuptools',
          'Plone',
      ],
      entry_points={
      }
      )
