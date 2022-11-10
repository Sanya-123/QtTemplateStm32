#ifndef STM32_H
#define STM32_H

#if defined (STM32F100xB) || defined (STM32F100xE) || defined (STM32F101x6) || \\
    defined (STM32F101xB) || defined (STM32F101xE) || defined (STM32F101xG) || \\
    defined (STM32F102x6) || defined (STM32F102xB) || defined (STM32F103x6) || \\
    defined (STM32F103xB) || defined (STM32F103xE) || defined (STM32F103xG) || \\
    defined (STM32F105xC) || defined (STM32F107xC)
#include "stm32f1xx.h"
#endif

#if defined (STM32F301x8) || defined (STM32F302x8) || defined (STM32F318xx) || \
    defined (STM32F302xC) || defined (STM32F303xC) || defined (STM32F358xx) || \
    defined (STM32F303x8) || defined (STM32F334x8) || defined (STM32F328xx) || \
    defined (STM32F302xE) || defined (STM32F303xE) || defined (STM32F398xx) || \
    defined (STM32F373xC) || defined (STM32F378xx)
#include "stm32f3xx.h"
#endif

#if defined (STM32F405xx) || defined (STM32F415xx) || defined (STM32F407xx) || defined (STM32F417xx) || \\
    defined (STM32F427xx) || defined (STM32F437xx) || defined (STM32F429xx) || defined (STM32F439xx) || \\
    defined (STM32F401xC) || defined (STM32F401xE) || defined (STM32F410Tx) || defined (STM32F410Cx) || \\
    defined (STM32F410Rx) || defined (STM32F411xE) || defined (STM32F446xx) || defined (STM32F469xx) || \\
    defined (STM32F479xx) || defined (STM32F412Cx) || defined (STM32F412Rx) || defined (STM32F412Vx) || \\
    defined (STM32F412Zx) || defined (STM32F413xx) || defined (STM32F423xx)
#include "stm32f4xx.h"
#endif

#if defined (STM32G071xx) || defined (STM32G081xx) || defined (STM32G070xx) || \\
    defined (STM32G030xx) || defined (STM32G031xx) || defined (STM32G041xx) || \\
    defined (STM32G0B0xx) || defined (STM32G0B1xx) || defined (STM32G0C1xx) || \\
    defined (STM32G050xx) || defined (STM32G051xx) || defined (STM32G061xx)
#include "stm32g0xx.h"
#endif

#if defined (STM32G431xx) || defined (STM32G441xx) || defined (STM32G471xx) || \
    defined (STM32G473xx) || defined (STM32G474xx) || defined (STM32G484xx) || \
    defined (STM32GBK1CB) || defined (STM32G491xx) || defined (STM32G4A1xx)
#include "stm32g4xx.h"
#endif

#endif // STM32_H
