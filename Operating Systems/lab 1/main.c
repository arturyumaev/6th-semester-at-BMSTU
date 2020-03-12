<<<<<<< HEAD
#include <unistd.h>
#include <stdlib.h>
#include <fcntl.h>
#include <syslog.h>
#include <string.h>
#include <errno.h>
#include <stdio.h>
#include <sys/stat.h>
#include "apue.h"
#include <pthread.h>
#include <sys/resource.h>

#define LOCKFILE "/var/run/daemon.pid"
#define LOCKMODE (S_IRUSR|S_IWUSR|S_IRGRP|S_IROTH)

int lockfile(int fd)
{
    struct flock fl;
    fl.l_type = F_WRLCK;
    fl.l_start = 0;
    fl.l_whence = SEEK_SET;
    fl.l_len = 0;
    return(fcntl(fd, F_SETLK, &fl));
}

int already_running(void)
{
    int fd;
    char buf[16];

    fd = open(LOCKFILE, O_RDWR|O_CREAT, LOCKMODE);

    if (fd < 0)
    {
        syslog(LOG_ERR, "невозможно открыть %s: %s",LOCKFILE, strerror(errno));
        exit(1);
    }
    if (lockfile(fd) < 0)
    {
        if (errno == EACCES || errno == EAGAIN)
        {
            close(fd);
            return(1);
        }
    syslog(LOG_ERR, "невозможно установить блокировку на Xs");
    exit(1);
    }
    ftruncate(fd, 0);
    sprintf(buf, "%ld", (long)getpid());
    write(fd, buf, strlen(buf)+1);
    return(0);
}

void daemonize(const char *cmd)
{
	// Файловые дескрипторы, открываемые на устройстве 
	// /dev/null 
    int i, fd0, fd1, fd2;
	
	// process id
    pid_t pid;
	
	// Максимально возможный номер дескриптора
    struct rlimit rl;
	
    struct sigaction sa;
    
    // Сбросить маску режима создания файла.
    umask(0);

    
    // Получить максимально возможный номер дескриптора файла
	// и закрыть все дескрипторы вплоть до этого номера
    if (getrlimit(RLIMIT_NOFILE, &rl) < 0)
        perror("Невозможно получить максимальный номер дескриптора ");
    
	
    // Стать лидером нового сеанса, чтобы утратить управляющий терминал.
    if ((pid = fork()) < 0)
        perror("Ошибка вызова функции fork");
    else if (pid != 0) /* родительский процесс */
        exit(0);

	// Создать новую сессию
    setsid();
    
    // Обеспечить невозможность обретения управляющего терминала в будущем
    sa.sa_handler = SIG_IGN;
    sigemptyset(&sa.sa_mask);
    sa.sa_flags = 0;
    if (sigaction(SIGHUP, &sa, NULL) < 0)
        perror("невозможно игнорировать сигнал SIGHUP");
    if ((pid = fork()) < 0)
        perror("ошибка вызова функции fork");
    else if (pid != 0) /* родительский процесс */
        exit(0);
    
    // Назначить корневой каталог текущим рабочим каталогом,
    // чтобы впоследствии можно было отмонтировать файловую систему.
    if (chdir("/") < 0)
        perror("Невозможно сделать текущим рабочим каталогом ");
    
	
    // Закрыть все открытые файловые дескрипторы,
	// максимальный номер получили ранее
    if (rl.rlim_max == RLIM_INFINITY)
        rl.rlim_max = 1024;
    for (i = 0; i < rl.rlim_max; i++)
        close(i);
    
    // Присоединить файловые дескрипторы 0, 1 и 2 к /dev/null
    fd0 = open("/dev/null", O_RDWR);
    fd1 = dup(0);
    fd2 = dup(0);
    
	
    // Открыть лог
	// 1 арг - строка идентификации (имя программы)
	// 2 арг - битовая маска, определ. различные способы вывода сообщений
	// LOG_CONS - если сообщение не может быть передано через сокет, вывести на консоль
	// 3а арг - системные демоны inetd, routed
    openlog(cmd, LOG_CONS, LOG_DAEMON);
	
	
    if (fd0 != 0 || fd1 != 1 || fd2 != 2)
    {
        syslog(LOG_ERR, "Ошибочные файловые дескрипторы %d %d %d",fd0, fd1, fd2);
        exit(1);
    }
}

int main()
{
    daemonize("my first daemon");
    
	// Убедиться, что ранее не была запущена другая копия демона
    if (already_running())
    {
        syslog(LOG_ERR, "Демон уже запущен");
        exit(1);
    }

    syslog(LOG_WARNING, "Проверка пройдена!");
    while(1) 
    {
        syslog(LOG_INFO, "Демон");
        sleep(5);
    }


}
=======
#include <unistd.h>
#include <stdlib.h>
#include <fcntl.h>
#include <syslog.h>
#include <string.h>
#include <errno.h>
#include <stdio.h>
#include <sys/stat.h>
#include "apue.h"
#include <pthread.h>
#include <sys/resource.h>

#define LOCKFILE "/var/run/daemon.pid"
#define LOCKMODE (S_IRUSR|S_IWUSR|S_IRGRP|S_IROTH)

int lockfile(int fd)
{
    struct flock fl;
    fl.l_type = F_WRLCK;
    fl.l_start = 0;
    fl.l_whence = SEEK_SET;
    fl.l_len = 0;
    return(fcntl(fd, F_SETLK, &fl));
}

int already_running(void)
{
    int fd;
    char buf[16];

    fd = open(LOCKFILE, O_RDWR|O_CREAT, LOCKMODE);

    if (fd < 0)
    {
        syslog(LOG_ERR, "невозможно открыть %s: %s",LOCKFILE, strerror(errno));
        exit(1);
    }
    if (lockfile(fd) < 0)
    {
        if (errno == EACCES || errno == EAGAIN)
        {
            close(fd);
            return(1);
        }
    syslog(LOG_ERR, "невозможно установить блокировку на Xs");
    exit(1);
    }
    ftruncate(fd, 0);
    sprintf(buf, "%ld", (long)getpid());
    write(fd, buf, strlen(buf)+1);
    return(0);
}

void daemonize(const char *cmd)
{
	// Файловые дескрипторы, открываемые на устройстве 
	// /dev/null 
    int i, fd0, fd1, fd2;
	
	// process id
    pid_t pid;
	
	// Максимально возможный номер дескриптора
    struct rlimit rl;
	
    struct sigaction sa;
    
    // Сбросить маску режима создания файла.
    umask(0);

    
    // Получить максимально возможный номер дескриптора файла
	// и закрыть все дескрипторы вплоть до этого номера
    if (getrlimit(RLIMIT_NOFILE, &rl) < 0)
        perror("Невозможно получить максимальный номер дескриптора ");
    
	
    // Стать лидером нового сеанса, чтобы утратить управляющий терминал.
    if ((pid = fork()) < 0)
        perror("Ошибка вызова функции fork");
    else if (pid != 0) /* родительский процесс */
        exit(0);

	// Создать новую сессию
    setsid();
    
    // Обеспечить невозможность обретения управляющего терминала в будущем
    sa.sa_handler = SIG_IGN;
    sigemptyset(&sa.sa_mask);
    sa.sa_flags = 0;
    if (sigaction(SIGHUP, &sa, NULL) < 0)
        perror("невозможно игнорировать сигнал SIGHUP");
    
    // Назначить корневой каталог текущим рабочим каталогом,
    // чтобы впоследствии можно было отмонтировать файловую систему.
    if (chdir("/") < 0)
        perror("Невозможно сделать текущим рабочим каталогом ");
    
	
    // Закрыть все открытые файловые дескрипторы,
	// максимальный номер получили ранее
    if (rl.rlim_max == RLIM_INFINITY)
        rl.rlim_max = 1024;
    for (i = 0; i < rl.rlim_max; i++)
        close(i);
    
    // Присоединить файловые дескрипторы 0, 1 и 2 к /dev/null
    fd0 = open("/dev/null", O_RDWR);
    fd1 = dup(0);
    fd2 = dup(0);
    
	
    // Открыть лог
	// 1 арг - строка идентификации (имя программы)
	// 2 арг - битовая маска, определ. различные способы вывода сообщений
	// LOG_CONS - если сообщение не может быть передано через сокет, вывести на консоль
	// 3а арг - системные демоны inetd, routed
    openlog(cmd, LOG_CONS, LOG_DAEMON);
	
	
    if (fd0 != 0 || fd1 != 1 || fd2 != 2)
    {
        syslog(LOG_ERR, "Ошибочные файловые дескрипторы %d %d %d",fd0, fd1, fd2);
        exit(1);
    }
}

int main()
{
    daemonize("my first daemon");
    
	// Убедиться, что ранее не была запущена другая копия демона
    if (already_running())
    {
        syslog(LOG_ERR, "Демон уже запущен");
        exit(1);
    }

    syslog(LOG_WARNING, "Проверка пройдена!");
    while(1) 
    {
        syslog(LOG_INFO, "Демон");
        sleep(5);
    }


}
>>>>>>> 596ad575cc8da1efa099d82d3230d4f303a4f1a0
