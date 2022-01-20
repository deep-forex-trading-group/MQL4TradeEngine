from dir_utils import go_to_root_dir
import os


def get_lower_case_name(text):
    lst = []
    for index, char in enumerate(text):
        if char.isupper() and index != 0:
            lst.append("_")
        lst.append(char)

    return "".join(lst).lower()


def read_file(path="", fname="sample.txt"):
    file_content = ""
    with open(os.path.join(path, fname), "r") as file:
        file_content = file.read()
    return file_content


def write_file(str_in="", path="", fname="sample.txt"):
    with open(os.path.join(path, fname), "w") as out_file:
        out_file.write(str_in)


def gen_st_mqh_file(st_name="Template"):
    # process naming cases
    st_params_name = st_name + "StrategyParams"
    st_title = st_name.split("Strategy")[0]

    title_to_field_dict = get_st_config_title_to_field_dict(st_title)
    st_params_mqh_code = get_st_params_mqh_code(st_params_name, title_to_field_dict)

    output_path = "Include/ThirdPartyLib/AdvancedTradingSystemLib/Strategy/Strategies/" \
                  + (st_name + "Strategy") \
                  + "/DataStructure.mqh "
    with open(output_path, "w") as out_file:
        out_file.write(st_params_mqh_code)


def get_config_fname(str_in):
    words_list = []
    word = ""
    for i in range(len(str_in)):
        if (str_in[i].isupper()) and word != "":
            words_list.append(word.lower())
            word = ""
        word += str_in[i]
        if i == len(str_in) - 1:
            words_list.append(word.lower())
    return '_'.join(words_list) + "_config.txt"


def get_st_config_title_to_field_dict(st_title):
    f = open(("config/" + get_config_fname(st_title)), "r")
    title_field_name = "invalid"
    title_to_field_dict = {}
    for line in f.readlines():
        line = line.strip()
        if len(line) == 0 or line.startswith("#"):
            continue
        if line.startswith("["):
            title_field_name = line.split("[")[1].split("]")[0]
            continue
        if title_field_name not in title_to_field_dict.keys():
            title_to_field_dict[title_field_name] = []
        title_to_field_dict[title_field_name].append(line)
    print(title_to_field_dict)
    return title_to_field_dict


def get_st_params_mqh_code(st_params_name, title_to_field_dict):
    code_str = ""
    code_str += "#include <ThirdPartyLib/AdvancedTradingSystemLib/ConfigManagement/all.mqh>\n"
    code_str += "#include <ThirdPartyLib/AdvancedTradingSystemLib/Strategy/StrategyBase/DataStructure.mqh>\n"
    code_str += "\n"
    code_str += "class " + st_params_name + " : StrategyParams {\n"
    code_str += "\tpublic:\n"
    code_str += "\t\t" + st_params_name + "(ConfigFile* config_file) : StrategyParams(config_file) {\n"
    for title in title_to_field_dict.keys():
        code_str += "// " + title + "\n"
        for field_pair in title_to_field_dict[title]:
            code_str += "\t\t\tthis." + field_pair.split(":")[0] + " = INTEGER_MIN_INT;\n"
    code_str += "// Refresh at the final step\n"
    code_str += "\t\t\tthis.RefreshStrategyParams();\n"
    code_str += "\t\t}\n"
    code_str += "\t\t~" + st_params_name + "() {};\n"

    code_str += "\tpublic:\n"
    code_str += "\t\tvoid PrintAllParams();\n"
    code_str += "\t\tvoid RefreshStrategyParams();\n"
    code_str += "\t\tbool IsParamsValid();\n"

    code_str += "\tpublic:\n"
    for title in title_to_field_dict.keys():
        code_str += "// " + title + "\n"
        for field_pair in title_to_field_dict[title]:
            code_str += "\t\t\tdouble " + field_pair.split(":")[0] + ";\n"
    code_str += "};\n\n"

    code_str += "bool " + st_params_name + "::IsParamsValid() {\n"
    code_str += "\treturn true;\n"
    code_str += "};\n"

    code_str += "void " + st_params_name + "::PrintAllParams() {\n"
    code_str += "\tPrintFormat(\"-------------------------- Starts " + st_params_name + " --------------------\");\n"
    for title in title_to_field_dict.keys():
        code_str += "// " + title + "\n"
        for field_pair in title_to_field_dict[title]:
            field_name = field_pair.split(":")[0]
            code_str += "\tPrintFormat(\"" + st_params_name + " [%s:%.4f]\", \"" + field_name + "\", this." + field_name + ");\n"
    code_str += "\tPrintFormat(\"-------------------------- Ends " + st_params_name + " --------------------\");\n"
    code_str += "};\n"

    code_str += "void " + st_params_name + "::RefreshStrategyParams() {\n"
    code_str += "\tthis.config_file_.RefreshConfigFile();\n"
    for title in title_to_field_dict.keys():
        code_str += "// " + title + "\n"
        for field_pair in title_to_field_dict[title]:
            code_str += "\tthis." + field_pair.split(":")[
                0] + " = StringToDouble(this.AssignConfigItem(\"" + title + "\", \"" + field_pair.split(":")[
                            0] + "\"));\n"
    code_str += "};"

    return code_str
