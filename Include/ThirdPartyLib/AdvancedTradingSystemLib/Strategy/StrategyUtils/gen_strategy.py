#!/usr/bin/env python
# -*- coding: utf-8 -*-

import argparse
import os
from dir_utils import go_to_root_dir, go_to_current_dir
from config_utils import gen_st_mqh_file, write_file, read_file, get_lower_case_name

parser = argparse.ArgumentParser(description='manual to this script')
parser.add_argument('--st_name', type=str, default="Trending")

args = parser.parse_args()
args.st_name = args.st_name.strip()
print("Generate Strategy for Strategy Name as {", args.st_name, "}")

go_to_root_dir()
st_parent_base_path = "Include/ThirdPartyLib/AdvancedTradingSystemLib/Strategy/"
st_base_path = "Include/ThirdPartyLib/AdvancedTradingSystemLib/Strategy/Strategies/"
st_path = os.path.join(st_base_path, (args.st_name + "Strategy"))
lower_case_st_name = get_lower_case_name(args.st_name)

experts_base_path = "Experts/"
st_experts_path = os.path.join(experts_base_path, (args.st_name + "Robot"))

if os.path.isdir(st_experts_path):
    print(st_experts_path, " is already exists!!")
    exit(-1)
os.makedirs(st_experts_path, exist_ok=True)

template_experts_content = read_file(os.path.join(experts_base_path, "TemplateRobot"), "TemplateRobot.mq4")
st_experts_content = template_experts_content\
                     .replace("Template", args.st_name)\
                     .replace("template", lower_case_st_name)
write_file(st_experts_content, st_experts_path, (args.st_name + "Robot.mq4"))

ds_content = read_file(os.path.join(experts_base_path, "TemplateRobot"), "DataStructure.mqh")
st_ds_content = ds_content\
                     .replace("Template", args.st_name)\
                     .replace("template", lower_case_st_name)
write_file(st_ds_content, st_experts_path, "DataStructure.mqh")

if os.path.isdir(st_path):
    print(args.st_name, " is already exists!!")
    exit(-1)
os.makedirs(st_path, exist_ok=True)

template_config_content = read_file("config", "template_config.txt")
st_config_content = template_config_content \
    .replace("Template", args.st_name) \
    .replace("template", lower_case_st_name)
write_file(st_config_content, "config", (lower_case_st_name + "_config.txt"))
gen_st_mqh_file(args.st_name)

template_st_mqh_content = read_file(os.path.join(st_base_path, "TemplateStrategy"),
                                     "TemplateStrategy.mqh")
st_strategy_mqh_content = template_st_mqh_content\
                    .replace("Template", args.st_name)\
                    .replace("template_config.txt", (lower_case_st_name + "_config.txt"))
write_file(st_strategy_mqh_content, st_path, (args.st_name + "Strategy.mqh"))

template_strategy_impl_mqh_content = read_file(os.path.join(st_base_path, "TemplateStrategy"),
                                               "TemplateStrategyImpl.mqh")
st_strategy_impl_mqh_content = template_strategy_impl_mqh_content.replace("Template", args.st_name)
write_file(st_strategy_impl_mqh_content, st_path, (args.st_name + "StrategyImpl.mqh"))

template_all_mqh_content = read_file(os.path.join(st_base_path, "TemplateStrategy"), "all.mqh")
st_all_mqh_content = template_all_mqh_content.replace("Template", args.st_name)
write_file(st_all_mqh_content, st_path, "all.mqh")

st_all_mqh_content = read_file(st_base_path, "all.mqh")
st_all_mqh_content.replace("#include \"" + args.st_name + "Strategy/all.mqh\"", "")
st_all_mqh_content = st_all_mqh_content.strip()
st_all_mqh_content += "\n"
st_all_mqh_content += "#include \"" + args.st_name + "Strategy/all.mqh\""
write_file(st_all_mqh_content, st_base_path, "all.mqh")


# os.system("mkdir -p ../tester/files/config "
#           "&& mkdir -p ../Files/config "
#           "&& mkdir -p ./Files/config "
#           "&& cp Config/* ../tester/files/config/. "
#           "&& cp Config/* ../Files/config/. "
#           "&& cp Config/* ./Files/config/.")
