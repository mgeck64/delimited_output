#
# Compiler flags
#
CCXX   = g++
CC     = gcc
CXXFLAGS = -Wall -Werror -Wextra -std=c++17
CFLAGS   = -Wall -Werror -Wextra

#
# Project files
#
CPPSRCS = $(wildcard *.cpp)
CSRCS = $(wildcard *.c)
OBJS = $(CPPSRCS:.cpp=.o) $(CSRCS:.c=.o)
EXE  = test

#
# Debug build settings
#
DBGDIR = debug
DBGEXE = $(DBGDIR)/$(EXE)
DBGOBJS = $(addprefix $(DBGDIR)/, $(OBJS))
DBGDEPS = $(DBGOBJS:%.o=%.d)
DBGFLAGS = -g -O0 -DDEBUG

#
# Release build settings
#
RELDIR = release
RELEXE = $(RELDIR)/$(EXE)
RELOBJS = $(addprefix $(RELDIR)/, $(OBJS))
RELDEPS = $(RELOBJS:%.o=%.d)
RELFLAGS = -O3 -DNDEBUG

.PHONY: all clean debug prep release remake

# Default build
all: prep release

#
# Debug rules
#
debug: $(DBGEXE)

$(DBGEXE): $(DBGOBJS)
		$(CCXX) -o $(DBGEXE) $^

-include $(DBGDEPS)

$(DBGDIR)/%.o: %.cpp
		$(CCXX) -c $(CXXFLAGS) $(DBGFLAGS) -MMD -o $@ $<

$(DBGDIR)/%.o: %.c
		$(CC) -c $(CFLAGS) $(DBGFLAGS) -MMD -o $@ $<

#
# Release rules
#
release: $(RELEXE)

$(RELEXE): $(RELOBJS)
		$(CCXX) -o $(RELEXE) $^

-include $(RELDEPS)

$(RELDIR)/%.o: %.cpp
		$(CCXX) -c $(CXXFLAGS) $(RELFLAGS) -MMD -o $@ $<

$(RELDIR)/%.o: %.c
		$(CC) -c $(CFLAGS) $(RELFLAGS) -MMD -o $@ $<

#
# Other rules
#
prep:
		@mkdir -p $(DBGDIR) $(RELDIR)

remake: clean all

clean:
		rm -f $(RELEXE) $(RELOBJS) $(RELDEPS) $(DBGEXE) $(DBGOBJS) $(DBGDEPS)