#include "%{SerialController}.h"
#include "stm32.h"
//generate help https://doc.qt.io/qtcreator/creator-project-wizards-json.html

typedef struct {
    uint32_t namesz;
    uint32_t descsz;
    uint32_t type;
    uint8_t data[];
} ElfNoteSection_t;

extern const ElfNoteSection_t g_note_build_id;

typedef struct {
    union{
        struct {
        uint8_t major;
        uint8_t minor;
        uint16_t subversion;
        } versionStruct;
        uint32_t versionData;
    }version;
    union{
        struct {
        uint16_t year;
        uint8_t month;
        uint8_t day;
        } dateStruct;
        uint32_t dateData;
    }date;

    union{
        struct {
        uint8_t minute;
        uint8_t hour;
        } timeStruct;
        uint16_t timeData;
    }time;
    uint16_t gitComitSize;

    uint8_t data[];
} ElfFirmwareData_t;

extern const ElfFirmwareData_t note_build_specification;

int main(void)
{
    while(1)
    {

    }
}

void __attribute__ ((weak)) _init(void)  {}
