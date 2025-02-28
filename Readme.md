# Vivado Basic Scripted Workflow

# Proj file structure

    - workspace
        | - ip(not used so far)
        | - proj
            | - {xilinx auto-work dir}
        | - script(genertaed tcl script)
        | - src
            | - constraints
            | - hdl
            | - testbench
            | - blockdesign

# Reference

- [Xilinx-UG894.](https://www.xilinx.com/support/documents/sw_manuals/xilinx2022_2/ug894-vivado-tcl-scripting.pdf)
- Vivado cmd help manual.
- [基于 Makefile 的 FPGA 构建系统.](https://blog.csdn.net/qq_36525177/article/details/135377399)
- [编写Tcl脚本创建整个Vivado工程并通过Git对Tcl脚本进行管理.](https://blog.csdn.net/m0_73063250/article/details/130096267)
- porperty.json 所有属性解说(来自官方文档):
- ```json
    {
        // 当前使用的第三方工具链
        "toolChain": "xilinx", 
        "toolVersion" : "2023.2.307",

        // 工程命名 
        // PL : 编程逻辑设计部分即之前的FPGA
        // PS : 处理系统设计部分即之前的SOC
        "prjName": {
            "PL": "template",
            "PS": "template"
        },

        // 自定义工程结构，若无该属性则认为是标准文件结构（详见下文说明）
        "arch" : {
            "structure" : "", // standard | xilinx | custom
            "prjPath" : "",   // 放置工程运行时的中间文件
            "hardware" : {    
                "src"  : "",  // 放置设计源文件，注: src上一级为IP&bd
                "sim"  : "",  // 放置仿真文件，会直接反应在树状结构上
                "data" : ""   // 放置约束、数据文件，约束会自动添加进vivado工程
            },
            "software" : {
                "src"  : "",  // 放置软件设计文件
                "data" : ""   // 放置软件相关数据文件
            }
        },

        // 代码库管理，支持远程和本地两种调用方式（详见下文库管理）
        // 使用UI来进行配置，不建议用户直接更改
        "library" : {
            "state": "", // local | remote
            "hardware" : {
                "common": [], // 插件提供的常见库
                "custom": []  // 用户自己的设计库
            }
        },

        // xilinx的IP仓库，直接添加到vivado的IP repo中
        // 目前支持ADI和ARM提供的IP repo （adi | arm）
        "IP_REPO" : [],

        // 当设计时用到PL+PS即为SOC开发
        // 当其中core不为none的时候即为混合开发
        "soc": {
            "core": "none",
            "bd": "",
            "os": "",
            "app": ""
        },
        
        "device": "none"
    }
```