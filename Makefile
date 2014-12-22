
CFLAGS += -Wall -std=c11 -I./include

BINDIR := bin

PROGRAMS := $(wildcard *.c)
PROGNAMES := $(PROGRAMS:.c=)
PROGBINS := $(patsubst %,$(BINDIR)/%,$(PROGNAMES))

COMMONSRC := $(wildcard ./common/*.c)
COMMONOBJ := $(COMMONSRC:.c=.o)
COMMONAR := ./common.a

.PHONY: all clean
all: $(PROGBINS)

$(BINDIR):
	@mkdir $(BINDIR)

%.o: %.c
	@echo "$< -o $@"
	@$(CC) $(CFLAGS) -c $< -o $@

$(COMMONAR): $(COMMONOBJ)
	@echo "common/*.o -o ./common.a"
	@$(AR) rcs $@ $(COMMONOBJ)

define prog_shortcut
.PHONY: $(1)
$(1): $$(BINDIR)/$(1)
endef

$(foreach prog,$(PROGNAMES),$(eval $(call prog_shortcut,$(prog))))

$(BINDIR)/%: %.c $(COMMONAR) | $(BINDIR)
	@echo "$< -o $@"
	@$(CC) $(CFLAGS) $< $(COMMONAR) -o $@

clean:
	@rm -f $(COMMONAR)
	@rm -f $(COMMONOBJ)
	@rm -f $(PROGBINS)
	@rm -fr $(BINDIR)

