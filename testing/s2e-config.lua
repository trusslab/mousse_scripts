--[[
This is the main S2E configuration file
=======================================

This file was automatically generated by s2e-env.
Changes can be made by the user where appropriate.
Modified by Yingtong Liu and Hsin-Wei hung
]]--

-------------------------------------------------------------------------------
-- This section configures the S2E engine.
s2e = {
    logging = {
        -- Possible values include "info", "warn", "debug", "none".
        -- See Logging.h in libs2ecore.
        console = "debug",
        logLevel = "debug",
    },

    -- All the cl::opt options defined in the engine can be tweaked here.
    -- This can be left empty most of the time.
    -- Most of the options can be found in S2EExecutor.cpp and Executor.cpp.
    kleeArgs = {
        --"-suppress-external-warnings=true",
        --"-print-llvm-instructions",
        "-print-mode-switch=true",
        "-verbose-on-symbolic-address",
        --"-mousse-concretize-wo-constraints=true",
    },
}

-- Declare empty plugin settings. They will be populated in the rest of
-- the configuration file.
plugins = {}
pluginsConfig = {}

-- Include various convenient functions
dofile('library.lua')

-------------------------------------------------------------------------------
-- This plugin contains the core custom instructions.
-- Some of these include s2e_make_symbolic, s2e_kill_state, etc.
-- You always want to have this plugin included.

add_plugin("BaseInstructions")
pluginsConfig.BaseInstructions = {
    logLevel = "debug",
    --feed random inputs instead of using symbolic inputs
    useFuzzer = false,
    --always use initial inputs
    useInitialInputs = false,
    --stop the program before s2e_make_concolic is called
    stopBeforeTesting = false,
    restrict = false,
}

-------------------------------------------------------------------------------
-- This plugin implements "shared folders" between the host and the guest.
-- Use it in conjunction with s2eget and s2eput guest tools in order to
-- transfer files between the guest and the host.

add_plugin("HostFiles")
pluginsConfig.HostFiles = {
    logLevel = "debug",
    baseDirs = {
        "/data/local",
        
    },
    allowWrite = true,
}

-------------------------------------------------------------------------------
-- This plugin provides support for virtual machine introspection and binary
-- formats parsing. S2E plugins can use it when they need to extract
-- information from binary files that are either loaded in virtual memory
-- or stored on the host's file system.

add_plugin("Vmi")
pluginsConfig.Vmi = {
    logLevel = "debug",
    baseDirs = {
        "/data/local",
        
    },
    modules = {
    },
}
-------------------------------------------------------------------------------
pluginsConfig.CorePlugin = {
    logLevel = "debug",
}
-------------------------------------------------------------------------------
-- This plugin collects various execution statistics and sends them to a QMP
-- server that listens on an address:port configured by the S2E_QMP_SERVER
-- environment variable.
--
-- The "s2e run test" command sets up such a server in order to display
-- stats on the dashboard.
--
-- You may also want to use this plugin to integrate S2E into a larger
-- system. The server could collect information about execution from different
-- S2E instances, filter them, and store them in a database.

add_plugin("WebServiceInterface")
pluginsConfig.WebServiceInterface = {
    logLevel = "debug",
    statsUpdateInterval = 2
}

-------------------------------------------------------------------------------
-- This is the main execution tracing plugin.
-- It generates the ExecutionTracer.dat file in the s2e-last folder.
-- That files contains trace information in a binary format. Other plugins can
-- hook into ExecutionTracer in order to insert custom tracing data.
--
-- This is a core plugin, you most likely always want to have it.

add_plugin("ExecutionTracer")
pluginsConfig.ExecutionTracer = {
    logLevel = "debug",
    useCircularBuffer = false,
}

-------------------------------------------------------------------------------
-- This plugin records events about module loads/unloads and stores them
-- in ExecutionTracer.dat.
-- This is useful in order to map raw program counters and pids to actual
-- module names.

--add_plugin("ModuleTracer")

-------------------------------------------------------------------------------
-- This is a generic plugin that let other plugins communicate with each other.
-- It is a simple key-value store.
--
-- The plugin has several modes of operation:
--
-- 1. local: runs an internal store private to each instance (default)
-- 2. distributed: the plugin interfaces with an actual key-value store server.
-- This allows different instances of S2E to communicate with each other.

add_plugin("KeyValueStore")
pluginsConfig.KeyValueStore = {
    logLevel = "debug",
    type = "local",
    server = "localhost",
    port = 11211,
}
-------------------------------------------------------------------------------
-- This plugin controls the forking behavior of S2E.

add_plugin("ForkLimiter")
pluginsConfig.ForkLimiter = {
    logLevel = "debug",
    -- How many times each program counter is allowed to fork.
    -- -1 for unlimited.
    maxForkCount = -1,

    -- How many seconds to wait before allowing an S2E process
    -- to spawn a child. When there are many states, S2E may
    -- spawn itself into multiple processes in order to leverage
    -- multiple cores on the host machine. When an S2E process A spawns
    -- a process B, A and B each get half of the states.
    --
    -- In some cases, when states fork and terminate very rapidly,
    -- one can see flash crowds of S2E instances. This decreases
    -- execution efficiency. This parameter forces S2E to wait a few
    -- seconds so that more states can accumulate in an instance
    -- before spawning a process.
    --processForkDelay = 5,
    processForkDelay = 0,
}
-------------------------------------------------------------------------------

add_plugin("ProcessMonitor")
pluginsConfig.ProcessMonitor = {
    debugLevel = 0,
    logLevel = "debug",
}

-------------------------------------------------------------------------------

add_plugin("StackMonitor")
pluginsConfig.StackMonitor = {
    debugLevel = 0,
    logLevel = "debug",
    userMode = true
}

-------------------------------------------------------------------------------

add_plugin("FunctionMonitor")
pluginsConfig.FunctionMonitor = {
    logLevel = "debug",
    monitorLocalFunctions = false
}
-------------------------------------------------------------------------------
-- This is Mousse distributed execution plugin.

add_plugin("DistributedExecution")
pluginsConfig.DistributedExecution = {
    logLevel = "debug",
    forkLimiterThreshold = 10,
    initAddress = 0x100,
    cameraProviderTestCode= -1;
    
    testAudioProvider = false,
    testAudioServer = false,
    blockingIoctlFiles = {"/dev/hwbinder",},
    blockingIoctlThreshold = 60,
    blockingIoctlDetection = true,

    -- Set to true if you want to reboot the device after the device finish its work --
    rebootAfterTerminate = false,
    -- set to > 2: allow (offloadThreshold - 1) number of concurrent Mousse processes in each device -- 
    offloadThreshold = 3,
    -- set to >= 2: allow statesForkedOnConcretization number of concurrent Mousse processes forked because of syscall arguments concretization -- 
    statesForkedOnConcretization = 1,
    -- Max seconds allowed to execute each Mousse process --
    stateExecutionThreshold = 3600,
    -- Set to true to use Strategy II in Mousse paper --
    makeSyscallReturnConcolic = false,
    -- Set to true to always make environment symbolic
    makeEnvReturnConcolic = false,
    -- This is the default setting for Testing Audio Provider in Pixel 3 --
    -- Don't enable this unless you set testAudioProvider to true -- 
    syscalls = {
        --Fill them with syscall numbers
        stateRevealing = {3,145},
        stateModifying ={54, 4, 146},
        checkFd = {4, 54, 3, 145, 146},
        makeReturnConcolic = {4, 54, 3, 145, 146},
        stateModifyingIoctlFiles = {"/dev/this_is_an_example_to_show_you_the_format",},
        EnvIoctlFiles = {"/dev/this_is_an_example_to_show_you_the_format",},
    },

    --disable forking in those libraries-- 
    noForkingFiles = {
    },
    portNum = 8000,
    legacyMode = true,
    standaloneMode = false,
}

-------------------------------------------------------------------------------
-- These two plugins are for Mousse Memory bug checkers 
-- Enable it when you want to use Mousse to find memory bugs and vulnerabilities
-- Attention: Those checkers cause non-trival overhead and they may have false positives and false negatives.
-- You should make sure all the offsets of the memory usage APIs matches the device's /system/lib/libc.so libarary. You can use ghidra to do it.

--[[
add_plugin("MemoryTracer")

add_plugin("LibcMemoryChecker")
pluginsConfig.LibcMemoryChecker = {
    logLevel = "debug",
    debugLevel = 0,
    checkDoubleFreeBug = true,
    freeOffset = 0x00018560,
    mallocOffset = 0x000185a0,
    callocOffset = 0x0001854c,
    reallocOffset = 0x00018604,
    posixMemalignOffset = 0x000185dc,
    pvallocOffset = 0x00018618,
    vallocOffset = 0x0001862c,
}

add_plugin("MemoryBugChecker")
pluginsConfig.MemoryBugChecker = {
   debugLevel = 0,
   logLevel = "debug",

   checkDoubleFreeBug = true,
   checkNullPtrDereferenceBug = true,
   checkReturnPtrOverrideBug = true,
   checkOOBAccessBug = true,
   checkMemoryBugs = true,
}
--]]

-------------------------------------------------------------------------------
-- This is Mousse coverage plugin
-- Enable it when you want to measure target program's coverage. see README for more details before you enable it
--add_plugin("MousseCoverage")
--pluginsConfig.MousseCoverage = {
--    sendCoverageOnStateKill = true,
--}
