#include <ThirdPartyLib/MqlExtendLib/Collection/all.mqh>
#include <ThirdPartyLib/AdvancedTradingSystemLib/Common/all.mqh>

class LineContent {
    public:
        LineContent() : col_size_(0), sep_(","), index_col_(0) {
            this.line_vec_ = new Vector<string>();
        };
        ~LineContent() {
            SafeDeleteCollectionPtr(this.line_vec_);
        };

    public:
        Vector<string>* GetLineVec() {
            return this.line_vec_;
        }
        string get(int i) {
            return this.line_vec_.get(i);
        }
        string GetIndexCol() {
            return this.line_vec_.get(this.index_col_);
        }
        void SetIndexCol(int index_col_in) {
            this.index_col_ = index_col_in;
        }
        int SetLineContent(string line_str_in) {
            return this.SetLineContent(line_str_in, this.sep_);
        }
        int SetLineContent(string line_str_in, string sep) {
            this.col_size_ = 0;
            string line_arr[];
            StringSplit(line_str_in, StringGetCharacter(sep, 0), line_arr);
            this.col_size_ = ArraySize(line_arr);
            for (int i = 0; i < ArraySize(line_arr); i++) {
                this.line_vec_.add(line_arr[i]);
            }
            return this.col_size_;
        };

    private:
        Vector<string>* line_vec_;
        int index_col_;
        int col_size_;
        string sep_;
};