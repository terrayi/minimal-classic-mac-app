MPW=~/mpw/bin/mpw
RINCLUDES=~/mpw/Interfaces/RIncludes
ObjDir=obj
Targ=Test
# Arch = m68k | ppc
Arch?=ppc
SrcFiles=main.c
ObjFiles=$(SrcFiles:%.c=$(ObjDir)/%.c.$(Arch).o)
ToolboxFlags=-d OLDROUTINENAMES=1 -i {MPW}Interfaces:CIncludes

ifeq ($(Arch),m68k)
	CC=SC
	CFLAGS=${ToolboxFlags}
	Linker=Link
	LDFLAGS=-w -c 'MTST' -t APPL \
		-sn STDIO=Main -sn INTENV=Main -sn %A5Init=Main -d
	LibFiles={Libraries}Stubs.o \
		{Libraries}MacRuntime.o \
		{Libraries}IntEnv.o \
		{Libraries}Interface.o \
		{Libraries}ToolLibs.o \
		{CLibraries}StdClib.o
else
	CC=MrC
	CFLAGS=${ToolboxFlags}
	Linker=PPCLink
	LDFLAGS=-m main -w -c 'MTST' -t APPL -c ttxt -sym off -d
	LibFiles={SharedLibraries}StdCLib \
		{SharedLibraries}InterfaceLib \
		{PPCLibraries}StdCRuntime.o \
		{PPCLibraries}PPCCRuntime.o \
		{PPCLibraries}PPCToolLibs.o \
		{PPCLibraries}PPCSIOW.o
endif

$(ObjDir)/%.c.$(Arch).o: %.c
	$(MPW) $(CC) $(CFLAGS) $< -o $@

all: $(Targ).$(Arch) Resource

$(Targ).$(Arch): $(ObjFiles) 
	$(MPW) $(Linker) \
	$(LDFLAGS) \
	$(ObjFiles) \
	$(LibFiles) \
	-o $(Targ).$(Arch)

Resource:
	Rez main.r -o $(Targ).$(Arch) -a -t APPL -c ttxt -i $(RINCLUDES)

clean:
	rm -f -v $(Targ).m68k* $(Targ).ppc* $(ObjDir)/*.c.*.o

