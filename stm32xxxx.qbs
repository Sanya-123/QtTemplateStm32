import qbs
import qbs.FileInfo

Product {
    type: ["application", "bin", "hex", "size"/*, "disassembly"*/]
    Depends { name:"cpp" }
    cpp.positionIndependentCode: false
    cpp.enableExceptions: false
    cpp.executableSuffix: ".elf"

    property stringList stm32f0xx_param: ["-mcpu=cortex-m0plus", "-mfloat-abi=soft", "-mfpu=auto"]
    property stringList stm32f1xx_param: ["-mcpu=cortex-m3", "-mfloat-abi=soft", "-mfpu=auto"]
    property stringList stm32f2xx_param: ["-mcpu=cortex-m3", "-mfloat-abi=soft", "-mfpu=auto"]
    property stringList stm32f3xx_param: ["-mcpu=cortex-m4", "-mfloat-abi=hard", "-mfpu=fpv4-sp-d16"]
    property stringList stm32f4xx_param: ["-mcpu=cortex-m4", "-mfloat-abi=hard", "-mfpu=fpv4-sp-d16"]
    property stringList stm32f7xx_param: ["-mcpu=cortex-m7", "-mfloat-abi=hard", "-mfpu=fpv5-sp-d16"]
    property stringList stm32h7xx_param: ["-mcpu=cortex-m7", "-mfloat-abi=hard", "-mfpu=fpv5-d16"]
    property stringList stm32g0xx_param: ["-mcpu=cortex-m0plus", "-mfloat-abi=soft", "-mfpu=auto"]
    property stringList stm32g4xx_param: ["-mcpu=cortex-m4", "-mfloat-abi=hard", "-mfpu=fpv4-sp-d16"]
    property stringList stm32l0xx_param: ["-mcpu=cortex-m0plus", "-mfloat-abi=soft", "-mfpu=auto"]
    property stringList stm32l1xx_param: ["-mcpu=cortex-m3", "-mfloat-abi=soft", "-mfpu=auto"]
    property stringList stm32l4xx_param: ["-mcpu=cortex-m4", "-mfloat-abi=hard", "-mfpu=fpv4-sp-d16"]
    property stringList stm32l5xx_param: ["-mcpu=cortex-m33", "-mfloat-abi=hard", "-mfpu=fpv5-sp-d16"]
    property stringList stm32u5xx_param: ["-mcpu=cortex-m33", "-mfloat-abi=hard", "-mfpu=fpv5-sp-d16"]
    property stringList stm32wbxx_param: ["-mcpu=cortex-m4", "-mfloat-abi=hard", "-mfpu=fpv4-sp-d16"]
    property stringList stm32wlxx_cm4_param: ["-mcpu=cortex-m4", "-mfloat-abi=soft", "-mfpu=auto"]
    property stringList stm32wlxx_cm0_param: ["-mcpu=cortex-m0plus", "-mfloat-abi=soft", "-mfpu=auto"]

    property stringList cpuParam: %{SerialController}_param

    cpp.defines: [
        "%{TypeDef}",
    ]

    files: [
        "CMSIS/Source/Templates/gcc/startup_%{TypeDef}.s",
        "CMSIS/Source/Templates/system_%{SerialController}.c",
        "*.c",
    ]

    cpp.includePaths: [
        "CMSIS/Include/",
        "Driver/",
        "./",
    ]
    
    cpp.dynamicLibraries: [

    ]

    cpp.driverFlags: [
        "-mthumb",
        cpuParam[0],
        cpuParam[1],
        cpuParam[2],
        "-fno-strict-aliasing",
        "-fdata-sections",
        "-ffunction-sections",
        "-fshort-enums",
        //"-flto",
        "-finput-charset=UTF-8",
        "-fexec-charset=cp1251",
        "-std=gnu11",
        "-Wall",
        "-Wpedantic",
        "-Wno-main",
        "-Wno-unused-function",
        "-Wno-old-style-declaration",
        "-specs=nano.specs",
    ]

    cpp.commonCompilerFlags: [

    ]

    cpp.linkerFlags :  [
        "-print-memory-usage",
        "-start-group",
        "-gc-sections",
        "-Map=output.map",
        "-lnosys",
        "-nostdlib",
        "-T" + path + "/%{TypeDef}_FLASH.ld",
        "-end-group",
    ]

    Properties {
        condition: qbs.buildVariant === "debug"
        cpp.driverFlags: outer.concat(["-Og", "-ggdb", "-DDEBUG=1"])
    }

    Properties {
        condition: qbs.buildVariant === "release"
        cpp.driverFlags: outer.concat(["-Og", "-g0", "-s", "-DDEBUG=0"])
    }

    Rule {
        id: bin
        inputs: "application"
        Artifact {
            fileTags: ["bin"]
           filePath: FileInfo.baseName(input.filePath) + ".bin"
        }
        prepare: {
                var args = ["-O", "binary", input.filePath, output.filePath];
                var cmd = new Command("arm-none-eabi-objcopy", args);
                cmd.description = "converting to bin: "+FileInfo.fileName(input.filePath);
                cmd.highlight = "linker";
                return cmd;
        }
    }

    Rule {
        id: hex
        inputs: "application"
        Artifact {
            fileTags: ["hex"]
            filePath: FileInfo.baseName(input.filePath) + ".hex"
        }
        prepare: {
            var args = ["-O", "ihex", input.filePath, output.filePath];
            var cmd = new Command("arm-none-eabi-objcopy", args);
            cmd.description = "converting to hex: "+FileInfo.fileName(input.filePath);
            cmd.highlight = "linker";
            return cmd;
        }
    }

    Rule {
        id: size
        inputs: ["application"]
        Artifact {
            fileTags: ["size"]
            filePath: "-"
        }
        prepare: {
            var args = [input.filePath];
            var cmd = new Command("arm-none-eabi-size", args);
            cmd.description = "File size: " + FileInfo.fileName(input.filePath);
            cmd.highlight = "linker";
            return cmd;
        }
    }
    Rule {
        id: disassmbly
        inputs: "application"
        Artifact {
            fileTags: ["disassembly"]
            filePath: FileInfo.baseName(input.filePath) + ".lst"
        }
        prepare: {
            var args = [input.filePath, "-D","-S"];
            var cmd = new Command("arm-none-eabi-objdump", args);
            cmd.stdoutFilePath = output.filePath;//TODO output file
            cmd.description = "Disassembly listing for " + FileInfo.fileName(input.filePath);
            cmd.highlight = "disassembler";

            return cmd;
        }
    }
}
