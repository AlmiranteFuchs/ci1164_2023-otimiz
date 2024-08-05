# PROGRAMA
        PROG = matmult
        OBJS = $(PROG).o matriz.o utils.o
		LIKWID_HOME=/home/soft/likwid

# Compilador
        CC = gcc -Wall
		LIKWID_PERFMON = -DLIKWID_PERFMON
		LIKWID_INCLUDE = /home/soft/likwid/include
		LIKWID_LIB = /home/soft/likwid/lib

        CFLAGS = -O3 -march=native -L/home/soft/likwid/lib -I$(LIKWID_HOME)/include -DLIKWID_PERFMON
       	LFLAGS = -lm -L/home/soft/likwid/lib -llikwid

# Lista de arquivos para distribuição
DISTFILES = *.c *.h README.md Makefile perfctr
DISTDIR = `basename ${PWD}`

.PHONY: all debug clean purge dist

%.o: %.c %.h
	$(CC) -c $(CFLAGS) -o $@ $< $(LFLAGS)

all: $(PROG)

debug:         CFLAGS += -g -D_DEBUG_
debug:         $(PROG)

$(PROG): $(OBJS) 
	$(CC) $(CFLAGS) -o $@ $^ $(LFLAGS)

utils.o: utils/utils/utils.c utils/utils/utils.h
	$(CC) $(CFLAGS) -c $<

clean:
	@echo "Limpando ...."
	@rm -f *~ *.bak *.tmp core 

purge:   clean
	@echo "Faxina ...."
	@rm -f  $(PROG) *.o a.out $(DISTDIR) $(DISTDIR).tar
	@rm -f *.png marker.out

dist: purge
	@echo "Gerando arquivo de distribuição ($(DISTDIR).tar) ..."
	@ln -s . $(DISTDIR)
	@tar -cvf $(DISTDIR).tar $(addprefix ./$(DISTDIR)/, $(DISTFILES))
	@rm -f $(DISTDIR)

