# IR_indri_wt2g

## Installation

### Install Homebrew

```
sudo apt-get install build-essential curl file git
sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)" 
export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"

brew install jq
```
### Build Indri

1. Download Indri from [SourceForge](#https://sourceforge.net/projects/lemur/files/lemur/)
2. go to indri directory
3. change configure permission
`chmod 744 configure`
4. `./configure`
5. `sudo apt-get install libz-dev`
6. `sudo make`
7. `sudo make install`

## Run Query

```
chmod a+x run.sh
sh run.sh
```
### Build Index

* index with stemming
`../indri-5.14/buildindex/IndriBuildIndex index_indri.param`

* index without stemming
`../indri-5.14/buildindex/IndriBuildIndex index_indri_with_stemming.param`

### Search
`../indri-5.14/runquery/IndriRunQuery <model-name>.param query.txt `


## Evaluate

`perl trec_eval qrels.401-450.txt res/res_<model>_rf.txt`
