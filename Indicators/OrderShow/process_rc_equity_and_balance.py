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
        buy_equity = sum((low - buy_df["Open Price"]) * buy_df["Lots"] * 100)
        sell_equity = sum((sell_df["Open Price"] - high) * sell_df["Lots"] * 100)
        return buy_equity + sell_equity

    def calc_current_closing_orders_balance(df):
        buy_df, sell_df = df[df["Action"] == "Buy"], df[df["Action"] == "Sell"]
        buy_balance = sum((buy_df["Close Price"] - buy_df["Open Price"]) * buy_df["Lots"] * 100)
        sell_balance = sum((sell_df["Open Price"] - sell_df["Close Price"]) * sell_df["Lots"] * 100)
        return buy_balance + sell_balance

    eb_df = pd.DataFrame(columns=["dt", "equity", "balance"])
    eb_df["dt"] = pd.to_datetime(eb_df["dt"])
    for idx, row in data_df.iterrows():
        cur_holding_df = rc_df[(rc_df["Open Date"] <= row["dt"])
                                & (row["dt"] < rc_df["Close Date"])].reset_index()
        cur_closing_df = rc_df[(rc_df["Close Date"] == row["dt"])]
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
    data_df = pd.read_csv("../../Files/XAUUSD1.csv",
                          header=None, names=["date", "time", "open", "high", "low", "close", "volume"],
                          parse_dates={"dt": ["date", "time"]})
    # data_df = data_df.iloc[0:1000]
    rc_df = pd.read_csv("../../Files/whmg.csv",
                        header=0, parse_dates=["Open Date", "Close Date"])
    equity, balance = 0, 0
    print("run main")
    eb_df = parallelize(data_df, calc_eb_df, rc_df)
    eb_df["balance"] = eb_df["balance"].cumsum()
    eb_df["equity"] = eb_df["balance"] + eb_df["equity"]
    eb_df[["equity", "balance"]].plot()

    import matplotlib.pyplot as plt

    plt.show()
    eb_df.to_csv("../../Records/whmg_eb.csv")
