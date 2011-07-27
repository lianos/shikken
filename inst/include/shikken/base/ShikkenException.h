#ifndef __SHIKKEN_EXCEPTION_H__
#define __SHIKKEN_EXCEPTION_H__

namespace shikken {

class ShikkenException {
    void init(const char* str);

public:
    /** constructor
     *
     * @param str exception string
     */
    ShikkenException(const char* str);

    /** copy constructor
     *
     * @param orig source object
     */
    ShikkenException(const ShikkenException& orig);

    /** destructor
     */
    virtual ~ShikkenException();

    /** get exception string
     *
     * @return the exception string
     */
    inline const char* get_exception_string() { return msg; }

private:
    /** The exception string */
    char *msg;
};

}

#endif

