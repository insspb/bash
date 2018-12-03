# PowerShell
Коллекция небольших функций, используемых в различных более сложных скриптах на PowerShell.

## Общие
| Скрипт | Функционал | Проверялось на | Требуемые модули PowerShell | 
|:---:|:---:|:---:|:---:|
| [Check-Admin.ps1](Functions/General/Check-Admin.ps1) | Проверяет наличие прав администратора при запуске скрипта | Windows 2012R2 | - |

## Active Directory
| Скрипт | Функционал | Проверялось на | Требуемые модули PowerShell | 
|:---:|:---:|:---:|:---:|
| [Check-AD.ps1](Functions/ActiveDirectory/Check-AD.ps1) | Проверяет наличие модуля Active Directory | Windows 2012R2 | - |
| [List-Inactive.ps1](Functions/ActiveDirectory/List-Inactive.ps1) | Возвращает список неактивных пользователей за Х дней. | Windows 2012R2 | Active Directory |
| [List-NoExpires.ps1](Functions/ActiveDirectory/List-NoExpires.ps1) | Возвращает список пользователей с включённым флагом вечных паролей. | Windows 2012R2 | Active Directory |
| []() | | Windows 2012R2 | Active Directory |
