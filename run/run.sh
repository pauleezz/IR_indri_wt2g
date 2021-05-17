#!/bin/sh
#######################################################################
# THIS IS THE TEST SCRIPT FOR THE INDRI QUERY LANGUAGE                #
#######################################################################
# First erase any existing files 
./clean.sh
mkdir index
mkdir res
# Then prepare parameters
cp params/*.param .
#######################################################################
# The following command builds a position index of the CACM database  #
#  directly from a simple SGML format source                          #
# Note that the version of database.sgml used has been modified to    #
# include <TEXT> tags around the body of each document.               #
# Uses the stopword list provided in smallstop_param.                 #
#######################################################################

../indri-5.14/buildindex/IndriBuildIndex index_indri.param
../indri-5.14/buildindex/IndriBuildIndex index_indri_with_stemming.param
# IndriBuildIndex index_indri.param
# Build index with stemming (porter)
# IndriBuildIndex index_indri_with_stemming.param

#######################################################################
# The following shows how to run simple retrieval                     #
# experiments with indri query language queries.                      #
#######################################################################

# simple query retrieval example
# ../indri-5.14/runquery/IndriRunQuery ret.param query.txt > res.txt
# ../indri-5.14/runquery/IndriRunQuery ret_stem.param query.txt > res_stem.txt
../indri-5.14/runquery/IndriRunQuery ret_okapi.param query.txt > res/res_okapi.txt
../indri-5.14/runquery/IndriRunQuery ret_stem_okapi.param query.txt > res/res_stem_okapi.txt
../indri-5.14/runquery/IndriRunQuery ret_lm.param query.txt > res/res_lm.txt
../indri-5.14/runquery/IndriRunQuery ret_stem_lm.param query.txt > res/res_stem_lm.txt
../indri-5.14/runquery/IndriRunQuery ret_lm_jm.param query.txt > res/res_lm_jm.txt
../indri-5.14/runquery/IndriRunQuery ret_stem_lm_jm.param query.txt > res/res_stem_lm_jm.txt
../indri-5.14/runquery/IndriRunQuery ret_okapi_rf.param query.txt > res/res_okapi_rf.txt
../indri-5.14/runquery/IndriRunQuery ret_stem_okapi_rf.param query.txt > res/res_stem_okapi_rf.txt

echo "{" > all_result.json
# echo '"ret.param":' >> all_result.json
# perl trec_eval qrels.401-450.txt res.txt | jq --slurp --raw-input 'split("\n")' >> all_result.json
# echo "," >> all_result.json
# echo '"ret_stem.param":' >> all_result.json
# perl trec_eval qrels.401-450.txt res_stem.txt | jq --slurp --raw-input 'split("\n")' >> all_result.json
# echo "," >> all_result.json
echo '"ret_okapi.param":' >> all_result.json
perl trec_eval qrels.401-450.txt res/res_okapi.txt | jq --slurp --raw-input 'split("\n")' >> all_result.json
echo "," >> all_result.json
echo '"ret_stem_okapi.param":' >> all_result.json
perl trec_eval qrels.401-450.txt res/res_stem_okapi.txt | jq --slurp --raw-input 'split("\n")' >> all_result.json
echo "," >> all_result.json
echo '"ret_lm.param":' >> all_result.json
perl trec_eval qrels.401-450.txt res/res_lm.txt | jq --slurp --raw-input 'split("\n")' >> all_result.json
echo "," >> all_result.json
echo '"ret_stem_lm.param":' >> all_result.json
perl trec_eval qrels.401-450.txt res/res_stem_lm.txt | jq --slurp --raw-input 'split("\n")' >> all_result.json
echo "," >> all_result.json
echo '"ret_lm_jm.param":' >> all_result.json
perl trec_eval qrels.401-450.txt res/res_lm_jm.txt | jq --slurp --raw-input 'split("\n")' >> all_result.json
echo "," >> all_result.json
echo '"ret_stem_lm_jm.param":' >> all_result.json
perl trec_eval qrels.401-450.txt res/res_stem_lm_jm.txt | jq  --slurp --raw-input 'split("\n")' >> all_result.json
echo "," >> all_result.json
echo '"ret_okapi_rf.param":' >> all_result.json
perl trec_eval qrels.401-450.txt res/res_okapi_rf.txt | jq  --slurp --raw-input 'split("\n")' >> all_result.json
echo "," >> all_result.json
echo '"ret_stem_okapi_rf.param":' >> all_result.json
perl trec_eval qrels.401-450.txt res/res_stem_okapi_rf.txt | jq  --slurp --raw-input 'split("\n")' >> all_result.json
echo "}" >> all_result.json

rm -r results

python3 plot.py