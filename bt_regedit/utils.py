
def hex_to_colon(string: str) -> str:
    string_len = len(string)
    out_string = ""
    for i in range(0, string_len, 2):
        out_string = out_string + f"{string[i]}{string[i+1]}"

        if i+2 == string_len:
            break
        out_string = out_string + ":"

    return out_string


def pretty_print(reg_dict: dict):
    for item in reg_dict:
        print(f"[{item}]: Key={reg_dict[item]}")
