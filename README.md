# Demo Jsonnet

Pour lancer la demo :

```
$ demoit -dev .
```

La demo est en http://localhost:8888/
Les notes sont dans http://localhost:8888/speakernotes

# First-time


## Installation

Install go (version 1.14+ required) then demoit :

```
go get -u github.com/dgageot/demoit
```

Then install it :

````
cd $HOME/go/src/github.com/dgageot/demoit
go install -mod=vendor
````

Also ensure that $HOME/go/bin is in your path