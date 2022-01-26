#include <ThirdPartyLib/MqlExtendLib/Utils/File.mqh>
#include <ThirdPartyLib/MqlExtendLib/Collection/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/Common/all.mqh>
#include "DataStructure.mqh"

class DataFrame {
    public:
        DataFrame(string fname, string sep, int title_line)
                  : fname_(fname), sep_(sep), title_line_(title_line) {
            this.CommonConstructor(fname, sep, title_line);
        }
        DataFrame(string fname) {
            this.CommonConstructor(fname, ",", -1);
        }
        ~DataFrame() {
            SafeDeleteCollectionPtr(this.df_content_list_);
            SafeDeleteCollectionPtr(this.df_index_map_);
        };
    public:
        // TODO: to implement
        void PrintDataFrame() {
            foreachm(string, dt_key, LineContent*, line_content, this.df_index_map_) {
                Vector<string>* line_vec = line_content.GetLineVec();
                string cur_pf = "";
                for (int i = 0; i < line_vec.size(); i++) {
                    StringAdd(cur_pf, StringFormat("%s, ", line_vec.get(i)));
                }
                PrintFormat("dt_key: %s, content: %s", dt_key, cur_pf);
            }
        }
        LinkedList<LineContent*>* GetDFContent() {
            return this.df_content_list_;
        }
        HashMap<string, LineContent*>* GetDFIndexMap() {
            return this.df_index_map_;
        }
    private:
        bool CommonConstructor(string fname, string sep, int title_line) {
            TextFile txt(this.fname_, FILE_READ);
            string terminal_data_path = TerminalInfoString(TERMINAL_DATA_PATH);
            if (!txt.valid()) {
                PrintFormat("The file name %s is invalid.", this.fname_);
                PrintFormat("terminal_data_path: %s", terminal_data_path);
                HandleLastError("[DataFrame] File Read Error.");
                return false;
            }
            this.df_content_list_ = new LinkedList<LineContent*>();
            this.df_index_map_ = new HashMap<string, LineContent*>();
            int line_idx = 0;

            while (!txt.end() && !IsStopped()) {
                string line = txt.readLine();

                if (StringLen(line) == 0) {
                    line_idx++;
                    continue;
                }
                if (this.title_line_ == 0 && line_idx == 0) {
                    line_idx++;
                    continue;
                }

                LineContent* line_content = new LineContent();
                line_content.SetLineContent(line, this.sep_);
                line_content.SetIndexCol(1);
                string key = TimeToStr(CommonUtils::GetDatetimeFromString(line_content.get(1)));
                df_index_map_.set(key, line_content);
                this.df_content_list_.add(line_content);
                line_idx++;
            }
            this.row_size_ = line_idx;
            return true;
        }
    private:
        LinkedList<LineContent*>* df_content_list_;
        HashMap<string, LineContent*>* df_index_map_;
        int row_size_;
        int col_size_;
        string fname_;
        string sep_;
        int title_line_;
};