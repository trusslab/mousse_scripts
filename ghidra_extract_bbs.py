#Extract basic blocks of the program
#@author Hsin-Wei Hung
#@category _NEW_
#@keybinding
#@menupath
#@toolbar

from ghidra.program.model.block import BasicBlockModel

f = open("{}.bbs".format(currentProgram.getName()), "w+")
f.write("{}\n".format(currentProgram.getName()))

base = currentProgram.getImageBase().getOffset()
bbm = BasicBlockModel(currentProgram)
bbs = bbm.getCodeBlocks(monitor)
while (bbs.hasNext()):
    bb = bbs.next()
#    print("cb {} {}".format(bb.getMinAddress(), bb.getMaxAddress()))
    addrs = bb.getAddresses(True)
    nextStartAddr = bb.getMinAddress()
    while (addrs.hasNext()):
        addr = addrs.next()
        instr = getInstructionAt(addr)
        if instr is not None:
            if not instr.getFlowType().isFallthrough():
                instrSize = instr.getLength()
#                print("bb {} {}".format(nextStartAddr, addr.add(instrSize-1)))
                f.write("{} {}\n".format(nextStartAddr.getOffset()-base,
                                         addr.getOffset()-base))
                nextStartAddr = addr.add(instrSize)

f.close()
