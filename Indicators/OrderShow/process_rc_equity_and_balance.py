import datetime
import pandas as pd

from functools import wraps


def calc_time(input_func):
    @wraps(input_func)
    def wrap_the_input_func(*args, **kwargs):
        start = datetime.datetime.utcnow()
        ret = input_func(*args, **kwargs)
        end = datetime.datetime.utcnow()
        print(input_func.__name__, '程序执行时间: ', (end - start).total_seconds())
        return ret

    return wrap_the_input_func


@calc_time
def calc_eb_df(data_df, rc_df):
    def calc_current_holding_orders_equity(df, high, low):
        buy_df, sell_df = df[df["Action"] == "Buy"], df[df["Action"] == "Sell"]
        buy_equity = sum((low - buy_df["Open Price"]) * buy_df["Lots"] * 10000)
        sell_equity = sum((sell_df["Open Price"] - high) * sell_df["Lots"] * 10000)
        return buy_equity + sell_equity

    def calc_current_closing_orders_balance(df):
        buy_df, sell_df = df[df["Action"] == "Buy"], df[df["Action"] == "Sell"]
        buy_balance = sum((buy_df["Close Price"] - buy_df["Open Price"]) * buy_df["Lots"] * 10000)
        sell_balance = sum((sell_df["Open Price"] - sell_df["Close Price"]) * sell_df["Lots"] * 10000)
        return buy_balance + sell_balance

    eb_df = pd.DataFrame(columns=["dt", "equity", "balance"])
    eb_df["dt"] = pd.to_datetime(eb_df["dt"])
    for idx, row in data_df.iterrows():
        cur_holding_df = rc_df[(rc_df["Open Date"] <= row["dt"])
                               & (row["dt"] < rc_df["Close Date"])].reset_index()
        rc_df["Open Date"], rc_df["Close Date"] = pd.to_datetime(rc_df["Open Date"]), pd.to_datetime(rc_df["Close Date"])
        cur_closing_df = rc_df[(rc_df["CloseOnlyDate"] == row["OnlyDate"])
                               & (rc_df["CloseOnlyHour"] == row["OnlyHour"])]
        cur_floating_equity = calc_current_holding_orders_equity(cur_holding_df, row["high"], row["low"])
        cur_balance = calc_current_closing_orders_balance(cur_closing_df)
        equity, balance = cur_floating_equity, cur_balance
        eb_df = eb_df.append({"dt": row["dt"], "equity": equity, "balance": balance}, ignore_index=True)
    return eb_df


from multiprocessing import cpu_count, Pool
import numpy as np

partitions = CORES = cpu_count()


def parallelize(data_df, func, rc_df):
    df_split_list = np.array_split(data_df, CORES)
    pool = Pool(CORES)
    items = [(dt_df, rc_df) for dt_df in df_split_list]
    rs = pool.starmap(func, items)
    res_df = pd.concat(rs).reset_index(drop=True)
    pool.close()
    pool.join()
    return res_df


if __name__ == "__main__":
    print("main")
    # DATA_FILE_NAME = "XAUUSD1.csv"
    # RC_FILE_NAME = "whmg.csv"
    # OUT_FILE_NAME = "whmg_eb.csv"
    #

    DATA_FILE_NAME = "EURUSD60.csv"
    RC_FILE_NAME = "260eu.csv"
    OUT_FILE_NAME = "260eu_eb.csv"

    data_df = pd.read_csv(("../../Files/" + DATA_FILE_NAME),
                          header=None, names=["date", "time", "open", "high", "low", "close", "volume"],
                          parse_dates={"dt": ["date", "time"]})
    # data_df = data_df.iloc[0:1000]
    rc_df = pd.read_csv(("../../Files/" + RC_FILE_NAME),
                        header=0, parse_dates=["Open Date", "Close Date"])
    data_df = data_df[(data_df["dt"] >= "2017.08.07")
                      & (data_df["dt"] <= "2018.01.22")]
    data_df["OnlyDate"], data_df["OnlyHour"] = data_df["dt"].dt.date, data_df["dt"].dt.hour
    rc_df["OpenOnlyDate"], rc_df["CloseOnlyDate"] = rc_df["Open Date"].dt.date, rc_df["Close Date"].dt.date
    rc_df["OpenOnlyHour"], rc_df["CloseOnlyHour"] = rc_df["Open Date"].dt.hour, rc_df["Close Date"].dt.hour
    equity, balance = 0, 0
    print("run main")
    eb_df = parallelize(data_df, calc_eb_df, rc_df)
    eb_df["balance"] = eb_df["balance"].cumsum()
    eb_df["equity"] = eb_df["balance"] + eb_df["equity"]
    eb_df[["equity", "balance"]].plot()

    import matplotlib.pyplot as plt

    plt.show()
    eb_df.to_csv(("../../Records/" + OUT_FILE_NAME))
