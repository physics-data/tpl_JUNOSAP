.PHONY: all

all: figures.pdf test.pdf

data.h5: geo.h5
	python3 simulate.py -n 4000 -g $^ -o $@

figures.pdf: data.h5
	python3 draw.py $^ -o $@

test.pdf: data.h5
	python3 test.py $^ -o $@
