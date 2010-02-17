use inc::Module::Install;
name 'Acme-Text-Inao';
all_from 'lib/Acme/Text/Inao.pm';
readme_from 'lib/Acme/Text/Inao.pm';
readme_pod_from 'lib/Acme/Text/Inao.pm';
githubmeta;

requires 'Parse::RecDescent';

tests 't/*.t t/*/*.t';
author_tests 'xt';

build_requires 'Test::More';
auto_set_repository;
auto_include;
WriteAll;
