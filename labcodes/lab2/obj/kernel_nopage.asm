
bin/kernel_nopage:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_entry>:

.text
.globl kern_entry
kern_entry:
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
  100000:	b8 00 a0 11 40       	mov    $0x4011a000,%eax
    movl %eax, %cr3
  100005:	0f 22 d8             	mov    %eax,%cr3

    # enable paging
    movl %cr0, %eax
  100008:	0f 20 c0             	mov    %cr0,%eax
    orl $(CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP), %eax
  10000b:	0d 2f 00 05 80       	or     $0x8005002f,%eax
    andl $~(CR0_TS | CR0_EM), %eax
  100010:	83 e0 f3             	and    $0xfffffff3,%eax
    movl %eax, %cr0
  100013:	0f 22 c0             	mov    %eax,%cr0

    # update eip
    # now, eip = 0x1.....
    leal next, %eax
  100016:	8d 05 1e 00 10 00    	lea    0x10001e,%eax
    # set eip = KERNBASE + 0x1.....
    jmp *%eax
  10001c:	ff e0                	jmp    *%eax

0010001e <next>:
next:

    # unmap va 0 ~ 4M, it's temporary mapping
    xorl %eax, %eax
  10001e:	31 c0                	xor    %eax,%eax
    movl %eax, __boot_pgdir
  100020:	a3 00 a0 11 00       	mov    %eax,0x11a000

    # set ebp, esp
    movl $0x0, %ebp
  100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
  10002a:	bc 00 90 11 00       	mov    $0x119000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
  10002f:	e8 02 00 00 00       	call   100036 <kern_init>

00100034 <spin>:

# should never get here
spin:
    jmp spin
  100034:	eb fe                	jmp    100034 <spin>

00100036 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  100036:	55                   	push   %ebp
  100037:	89 e5                	mov    %esp,%ebp
  100039:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  10003c:	b8 2c cf 11 00       	mov    $0x11cf2c,%eax
  100041:	2d 36 9a 11 00       	sub    $0x119a36,%eax
  100046:	89 44 24 08          	mov    %eax,0x8(%esp)
  10004a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100051:	00 
  100052:	c7 04 24 36 9a 11 00 	movl   $0x119a36,(%esp)
  100059:	e8 13 5f 00 00       	call   105f71 <memset>

    cons_init();                // init the console
  10005e:	e8 11 16 00 00       	call   101674 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100063:	c7 45 f4 00 61 10 00 	movl   $0x106100,-0xc(%ebp)
    cprintf("%s\n\n", message);
  10006a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10006d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100071:	c7 04 24 1c 61 10 00 	movl   $0x10611c,(%esp)
  100078:	e8 e4 02 00 00       	call   100361 <cprintf>

    print_kerninfo();
  10007d:	e8 02 08 00 00       	call   100884 <print_kerninfo>

    grade_backtrace();
  100082:	e8 90 00 00 00       	call   100117 <grade_backtrace>

    pmm_init();                 // init physical memory management
  100087:	e8 2e 44 00 00       	call   1044ba <pmm_init>

    pic_init();                 // init interrupt controller
  10008c:	e8 64 17 00 00       	call   1017f5 <pic_init>
    idt_init();                 // init interrupt descriptor table
  100091:	e8 eb 18 00 00       	call   101981 <idt_init>

    clock_init();               // init clock interrupt
  100096:	e8 38 0d 00 00       	call   100dd3 <clock_init>
    intr_enable();              // enable irq interrupt
  10009b:	e8 b3 16 00 00       	call   101753 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  1000a0:	eb fe                	jmp    1000a0 <kern_init+0x6a>

001000a2 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  1000a2:	55                   	push   %ebp
  1000a3:	89 e5                	mov    %esp,%ebp
  1000a5:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  1000a8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1000af:	00 
  1000b0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1000b7:	00 
  1000b8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000bf:	e8 2a 0c 00 00       	call   100cee <mon_backtrace>
}
  1000c4:	90                   	nop
  1000c5:	89 ec                	mov    %ebp,%esp
  1000c7:	5d                   	pop    %ebp
  1000c8:	c3                   	ret    

001000c9 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  1000c9:	55                   	push   %ebp
  1000ca:	89 e5                	mov    %esp,%ebp
  1000cc:	83 ec 18             	sub    $0x18,%esp
  1000cf:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000d2:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  1000d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  1000d8:	8d 5d 08             	lea    0x8(%ebp),%ebx
  1000db:	8b 45 08             	mov    0x8(%ebp),%eax
  1000de:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  1000e2:	89 54 24 08          	mov    %edx,0x8(%esp)
  1000e6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1000ea:	89 04 24             	mov    %eax,(%esp)
  1000ed:	e8 b0 ff ff ff       	call   1000a2 <grade_backtrace2>
}
  1000f2:	90                   	nop
  1000f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1000f6:	89 ec                	mov    %ebp,%esp
  1000f8:	5d                   	pop    %ebp
  1000f9:	c3                   	ret    

001000fa <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000fa:	55                   	push   %ebp
  1000fb:	89 e5                	mov    %esp,%ebp
  1000fd:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  100100:	8b 45 10             	mov    0x10(%ebp),%eax
  100103:	89 44 24 04          	mov    %eax,0x4(%esp)
  100107:	8b 45 08             	mov    0x8(%ebp),%eax
  10010a:	89 04 24             	mov    %eax,(%esp)
  10010d:	e8 b7 ff ff ff       	call   1000c9 <grade_backtrace1>
}
  100112:	90                   	nop
  100113:	89 ec                	mov    %ebp,%esp
  100115:	5d                   	pop    %ebp
  100116:	c3                   	ret    

00100117 <grade_backtrace>:

void
grade_backtrace(void) {
  100117:	55                   	push   %ebp
  100118:	89 e5                	mov    %esp,%ebp
  10011a:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  10011d:	b8 36 00 10 00       	mov    $0x100036,%eax
  100122:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  100129:	ff 
  10012a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10012e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100135:	e8 c0 ff ff ff       	call   1000fa <grade_backtrace0>
}
  10013a:	90                   	nop
  10013b:	89 ec                	mov    %ebp,%esp
  10013d:	5d                   	pop    %ebp
  10013e:	c3                   	ret    

0010013f <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  10013f:	55                   	push   %ebp
  100140:	89 e5                	mov    %esp,%ebp
  100142:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100145:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100148:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  10014b:	8c 45 f2             	mov    %es,-0xe(%ebp)
  10014e:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  100151:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100155:	83 e0 03             	and    $0x3,%eax
  100158:	89 c2                	mov    %eax,%edx
  10015a:	a1 00 c0 11 00       	mov    0x11c000,%eax
  10015f:	89 54 24 08          	mov    %edx,0x8(%esp)
  100163:	89 44 24 04          	mov    %eax,0x4(%esp)
  100167:	c7 04 24 21 61 10 00 	movl   $0x106121,(%esp)
  10016e:	e8 ee 01 00 00       	call   100361 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100173:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100177:	89 c2                	mov    %eax,%edx
  100179:	a1 00 c0 11 00       	mov    0x11c000,%eax
  10017e:	89 54 24 08          	mov    %edx,0x8(%esp)
  100182:	89 44 24 04          	mov    %eax,0x4(%esp)
  100186:	c7 04 24 2f 61 10 00 	movl   $0x10612f,(%esp)
  10018d:	e8 cf 01 00 00       	call   100361 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100192:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100196:	89 c2                	mov    %eax,%edx
  100198:	a1 00 c0 11 00       	mov    0x11c000,%eax
  10019d:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001a1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001a5:	c7 04 24 3d 61 10 00 	movl   $0x10613d,(%esp)
  1001ac:	e8 b0 01 00 00       	call   100361 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  1001b1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1001b5:	89 c2                	mov    %eax,%edx
  1001b7:	a1 00 c0 11 00       	mov    0x11c000,%eax
  1001bc:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001c4:	c7 04 24 4b 61 10 00 	movl   $0x10614b,(%esp)
  1001cb:	e8 91 01 00 00       	call   100361 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001d0:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001d4:	89 c2                	mov    %eax,%edx
  1001d6:	a1 00 c0 11 00       	mov    0x11c000,%eax
  1001db:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001df:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001e3:	c7 04 24 59 61 10 00 	movl   $0x106159,(%esp)
  1001ea:	e8 72 01 00 00       	call   100361 <cprintf>
    round ++;
  1001ef:	a1 00 c0 11 00       	mov    0x11c000,%eax
  1001f4:	40                   	inc    %eax
  1001f5:	a3 00 c0 11 00       	mov    %eax,0x11c000
}
  1001fa:	90                   	nop
  1001fb:	89 ec                	mov    %ebp,%esp
  1001fd:	5d                   	pop    %ebp
  1001fe:	c3                   	ret    

001001ff <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001ff:	55                   	push   %ebp
  100200:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
	asm volatile (
  100202:	83 ec 08             	sub    $0x8,%esp
  100205:	cd 78                	int    $0x78
  100207:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp"
	    : 
	    : "i"(T_SWITCH_TOU)
	);
}
  100209:	90                   	nop
  10020a:	5d                   	pop    %ebp
  10020b:	c3                   	ret    

0010020c <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  10020c:	55                   	push   %ebp
  10020d:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
	asm volatile (
  10020f:	cd 79                	int    $0x79
  100211:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp \n"
	    : 
	    : "i"(T_SWITCH_TOK)
	);
}
  100213:	90                   	nop
  100214:	5d                   	pop    %ebp
  100215:	c3                   	ret    

00100216 <lab1_switch_test>:

static void
lab1_switch_test(void) {
  100216:	55                   	push   %ebp
  100217:	89 e5                	mov    %esp,%ebp
  100219:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  10021c:	e8 1e ff ff ff       	call   10013f <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  100221:	c7 04 24 68 61 10 00 	movl   $0x106168,(%esp)
  100228:	e8 34 01 00 00       	call   100361 <cprintf>
    lab1_switch_to_user();
  10022d:	e8 cd ff ff ff       	call   1001ff <lab1_switch_to_user>
    lab1_print_cur_status();
  100232:	e8 08 ff ff ff       	call   10013f <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  100237:	c7 04 24 88 61 10 00 	movl   $0x106188,(%esp)
  10023e:	e8 1e 01 00 00       	call   100361 <cprintf>
    lab1_switch_to_kernel();
  100243:	e8 c4 ff ff ff       	call   10020c <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100248:	e8 f2 fe ff ff       	call   10013f <lab1_print_cur_status>
}
  10024d:	90                   	nop
  10024e:	89 ec                	mov    %ebp,%esp
  100250:	5d                   	pop    %ebp
  100251:	c3                   	ret    

00100252 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100252:	55                   	push   %ebp
  100253:	89 e5                	mov    %esp,%ebp
  100255:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100258:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10025c:	74 13                	je     100271 <readline+0x1f>
        cprintf("%s", prompt);
  10025e:	8b 45 08             	mov    0x8(%ebp),%eax
  100261:	89 44 24 04          	mov    %eax,0x4(%esp)
  100265:	c7 04 24 a7 61 10 00 	movl   $0x1061a7,(%esp)
  10026c:	e8 f0 00 00 00       	call   100361 <cprintf>
    }
    int i = 0, c;
  100271:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100278:	e8 73 01 00 00       	call   1003f0 <getchar>
  10027d:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100280:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100284:	79 07                	jns    10028d <readline+0x3b>
            return NULL;
  100286:	b8 00 00 00 00       	mov    $0x0,%eax
  10028b:	eb 78                	jmp    100305 <readline+0xb3>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  10028d:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100291:	7e 28                	jle    1002bb <readline+0x69>
  100293:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  10029a:	7f 1f                	jg     1002bb <readline+0x69>
            cputchar(c);
  10029c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10029f:	89 04 24             	mov    %eax,(%esp)
  1002a2:	e8 e2 00 00 00       	call   100389 <cputchar>
            buf[i ++] = c;
  1002a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1002aa:	8d 50 01             	lea    0x1(%eax),%edx
  1002ad:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1002b0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1002b3:	88 90 20 c0 11 00    	mov    %dl,0x11c020(%eax)
  1002b9:	eb 45                	jmp    100300 <readline+0xae>
        }
        else if (c == '\b' && i > 0) {
  1002bb:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  1002bf:	75 16                	jne    1002d7 <readline+0x85>
  1002c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1002c5:	7e 10                	jle    1002d7 <readline+0x85>
            cputchar(c);
  1002c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002ca:	89 04 24             	mov    %eax,(%esp)
  1002cd:	e8 b7 00 00 00       	call   100389 <cputchar>
            i --;
  1002d2:	ff 4d f4             	decl   -0xc(%ebp)
  1002d5:	eb 29                	jmp    100300 <readline+0xae>
        }
        else if (c == '\n' || c == '\r') {
  1002d7:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1002db:	74 06                	je     1002e3 <readline+0x91>
  1002dd:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1002e1:	75 95                	jne    100278 <readline+0x26>
            cputchar(c);
  1002e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002e6:	89 04 24             	mov    %eax,(%esp)
  1002e9:	e8 9b 00 00 00       	call   100389 <cputchar>
            buf[i] = '\0';
  1002ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1002f1:	05 20 c0 11 00       	add    $0x11c020,%eax
  1002f6:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1002f9:	b8 20 c0 11 00       	mov    $0x11c020,%eax
  1002fe:	eb 05                	jmp    100305 <readline+0xb3>
        c = getchar();
  100300:	e9 73 ff ff ff       	jmp    100278 <readline+0x26>
        }
    }
}
  100305:	89 ec                	mov    %ebp,%esp
  100307:	5d                   	pop    %ebp
  100308:	c3                   	ret    

00100309 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  100309:	55                   	push   %ebp
  10030a:	89 e5                	mov    %esp,%ebp
  10030c:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  10030f:	8b 45 08             	mov    0x8(%ebp),%eax
  100312:	89 04 24             	mov    %eax,(%esp)
  100315:	e8 89 13 00 00       	call   1016a3 <cons_putc>
    (*cnt) ++;
  10031a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10031d:	8b 00                	mov    (%eax),%eax
  10031f:	8d 50 01             	lea    0x1(%eax),%edx
  100322:	8b 45 0c             	mov    0xc(%ebp),%eax
  100325:	89 10                	mov    %edx,(%eax)
}
  100327:	90                   	nop
  100328:	89 ec                	mov    %ebp,%esp
  10032a:	5d                   	pop    %ebp
  10032b:	c3                   	ret    

0010032c <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  10032c:	55                   	push   %ebp
  10032d:	89 e5                	mov    %esp,%ebp
  10032f:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100332:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  100339:	8b 45 0c             	mov    0xc(%ebp),%eax
  10033c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  100340:	8b 45 08             	mov    0x8(%ebp),%eax
  100343:	89 44 24 08          	mov    %eax,0x8(%esp)
  100347:	8d 45 f4             	lea    -0xc(%ebp),%eax
  10034a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10034e:	c7 04 24 09 03 10 00 	movl   $0x100309,(%esp)
  100355:	e8 42 54 00 00       	call   10579c <vprintfmt>
    return cnt;
  10035a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10035d:	89 ec                	mov    %ebp,%esp
  10035f:	5d                   	pop    %ebp
  100360:	c3                   	ret    

00100361 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  100361:	55                   	push   %ebp
  100362:	89 e5                	mov    %esp,%ebp
  100364:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100367:	8d 45 0c             	lea    0xc(%ebp),%eax
  10036a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  10036d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100370:	89 44 24 04          	mov    %eax,0x4(%esp)
  100374:	8b 45 08             	mov    0x8(%ebp),%eax
  100377:	89 04 24             	mov    %eax,(%esp)
  10037a:	e8 ad ff ff ff       	call   10032c <vcprintf>
  10037f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  100382:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100385:	89 ec                	mov    %ebp,%esp
  100387:	5d                   	pop    %ebp
  100388:	c3                   	ret    

00100389 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100389:	55                   	push   %ebp
  10038a:	89 e5                	mov    %esp,%ebp
  10038c:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  10038f:	8b 45 08             	mov    0x8(%ebp),%eax
  100392:	89 04 24             	mov    %eax,(%esp)
  100395:	e8 09 13 00 00       	call   1016a3 <cons_putc>
}
  10039a:	90                   	nop
  10039b:	89 ec                	mov    %ebp,%esp
  10039d:	5d                   	pop    %ebp
  10039e:	c3                   	ret    

0010039f <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  10039f:	55                   	push   %ebp
  1003a0:	89 e5                	mov    %esp,%ebp
  1003a2:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  1003a5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  1003ac:	eb 13                	jmp    1003c1 <cputs+0x22>
        cputch(c, &cnt);
  1003ae:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  1003b2:	8d 55 f0             	lea    -0x10(%ebp),%edx
  1003b5:	89 54 24 04          	mov    %edx,0x4(%esp)
  1003b9:	89 04 24             	mov    %eax,(%esp)
  1003bc:	e8 48 ff ff ff       	call   100309 <cputch>
    while ((c = *str ++) != '\0') {
  1003c1:	8b 45 08             	mov    0x8(%ebp),%eax
  1003c4:	8d 50 01             	lea    0x1(%eax),%edx
  1003c7:	89 55 08             	mov    %edx,0x8(%ebp)
  1003ca:	0f b6 00             	movzbl (%eax),%eax
  1003cd:	88 45 f7             	mov    %al,-0x9(%ebp)
  1003d0:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1003d4:	75 d8                	jne    1003ae <cputs+0xf>
    }
    cputch('\n', &cnt);
  1003d6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1003d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1003dd:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  1003e4:	e8 20 ff ff ff       	call   100309 <cputch>
    return cnt;
  1003e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1003ec:	89 ec                	mov    %ebp,%esp
  1003ee:	5d                   	pop    %ebp
  1003ef:	c3                   	ret    

001003f0 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1003f0:	55                   	push   %ebp
  1003f1:	89 e5                	mov    %esp,%ebp
  1003f3:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1003f6:	90                   	nop
  1003f7:	e8 e6 12 00 00       	call   1016e2 <cons_getc>
  1003fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1003ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100403:	74 f2                	je     1003f7 <getchar+0x7>
        /* do nothing */;
    return c;
  100405:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100408:	89 ec                	mov    %ebp,%esp
  10040a:	5d                   	pop    %ebp
  10040b:	c3                   	ret    

0010040c <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  10040c:	55                   	push   %ebp
  10040d:	89 e5                	mov    %esp,%ebp
  10040f:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  100412:	8b 45 0c             	mov    0xc(%ebp),%eax
  100415:	8b 00                	mov    (%eax),%eax
  100417:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10041a:	8b 45 10             	mov    0x10(%ebp),%eax
  10041d:	8b 00                	mov    (%eax),%eax
  10041f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  100422:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  100429:	e9 ca 00 00 00       	jmp    1004f8 <stab_binsearch+0xec>
        int true_m = (l + r) / 2, m = true_m;
  10042e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100431:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100434:	01 d0                	add    %edx,%eax
  100436:	89 c2                	mov    %eax,%edx
  100438:	c1 ea 1f             	shr    $0x1f,%edx
  10043b:	01 d0                	add    %edx,%eax
  10043d:	d1 f8                	sar    %eax
  10043f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  100442:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100445:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  100448:	eb 03                	jmp    10044d <stab_binsearch+0x41>
            m --;
  10044a:	ff 4d f0             	decl   -0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
  10044d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100450:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100453:	7c 1f                	jl     100474 <stab_binsearch+0x68>
  100455:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100458:	89 d0                	mov    %edx,%eax
  10045a:	01 c0                	add    %eax,%eax
  10045c:	01 d0                	add    %edx,%eax
  10045e:	c1 e0 02             	shl    $0x2,%eax
  100461:	89 c2                	mov    %eax,%edx
  100463:	8b 45 08             	mov    0x8(%ebp),%eax
  100466:	01 d0                	add    %edx,%eax
  100468:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10046c:	0f b6 c0             	movzbl %al,%eax
  10046f:	39 45 14             	cmp    %eax,0x14(%ebp)
  100472:	75 d6                	jne    10044a <stab_binsearch+0x3e>
        }
        if (m < l) {    // no match in [l, m]
  100474:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100477:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10047a:	7d 09                	jge    100485 <stab_binsearch+0x79>
            l = true_m + 1;
  10047c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10047f:	40                   	inc    %eax
  100480:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100483:	eb 73                	jmp    1004f8 <stab_binsearch+0xec>
        }

        // actual binary search
        any_matches = 1;
  100485:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  10048c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10048f:	89 d0                	mov    %edx,%eax
  100491:	01 c0                	add    %eax,%eax
  100493:	01 d0                	add    %edx,%eax
  100495:	c1 e0 02             	shl    $0x2,%eax
  100498:	89 c2                	mov    %eax,%edx
  10049a:	8b 45 08             	mov    0x8(%ebp),%eax
  10049d:	01 d0                	add    %edx,%eax
  10049f:	8b 40 08             	mov    0x8(%eax),%eax
  1004a2:	39 45 18             	cmp    %eax,0x18(%ebp)
  1004a5:	76 11                	jbe    1004b8 <stab_binsearch+0xac>
            *region_left = m;
  1004a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004ad:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  1004af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1004b2:	40                   	inc    %eax
  1004b3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1004b6:	eb 40                	jmp    1004f8 <stab_binsearch+0xec>
        } else if (stabs[m].n_value > addr) {
  1004b8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004bb:	89 d0                	mov    %edx,%eax
  1004bd:	01 c0                	add    %eax,%eax
  1004bf:	01 d0                	add    %edx,%eax
  1004c1:	c1 e0 02             	shl    $0x2,%eax
  1004c4:	89 c2                	mov    %eax,%edx
  1004c6:	8b 45 08             	mov    0x8(%ebp),%eax
  1004c9:	01 d0                	add    %edx,%eax
  1004cb:	8b 40 08             	mov    0x8(%eax),%eax
  1004ce:	39 45 18             	cmp    %eax,0x18(%ebp)
  1004d1:	73 14                	jae    1004e7 <stab_binsearch+0xdb>
            *region_right = m - 1;
  1004d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004d6:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004d9:	8b 45 10             	mov    0x10(%ebp),%eax
  1004dc:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  1004de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004e1:	48                   	dec    %eax
  1004e2:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004e5:	eb 11                	jmp    1004f8 <stab_binsearch+0xec>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1004e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004ea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004ed:	89 10                	mov    %edx,(%eax)
            l = m;
  1004ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004f2:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1004f5:	ff 45 18             	incl   0x18(%ebp)
    while (l <= r) {
  1004f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1004fb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1004fe:	0f 8e 2a ff ff ff    	jle    10042e <stab_binsearch+0x22>
        }
    }

    if (!any_matches) {
  100504:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100508:	75 0f                	jne    100519 <stab_binsearch+0x10d>
        *region_right = *region_left - 1;
  10050a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10050d:	8b 00                	mov    (%eax),%eax
  10050f:	8d 50 ff             	lea    -0x1(%eax),%edx
  100512:	8b 45 10             	mov    0x10(%ebp),%eax
  100515:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
  100517:	eb 3e                	jmp    100557 <stab_binsearch+0x14b>
        l = *region_right;
  100519:	8b 45 10             	mov    0x10(%ebp),%eax
  10051c:	8b 00                	mov    (%eax),%eax
  10051e:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  100521:	eb 03                	jmp    100526 <stab_binsearch+0x11a>
  100523:	ff 4d fc             	decl   -0x4(%ebp)
  100526:	8b 45 0c             	mov    0xc(%ebp),%eax
  100529:	8b 00                	mov    (%eax),%eax
  10052b:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  10052e:	7e 1f                	jle    10054f <stab_binsearch+0x143>
  100530:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100533:	89 d0                	mov    %edx,%eax
  100535:	01 c0                	add    %eax,%eax
  100537:	01 d0                	add    %edx,%eax
  100539:	c1 e0 02             	shl    $0x2,%eax
  10053c:	89 c2                	mov    %eax,%edx
  10053e:	8b 45 08             	mov    0x8(%ebp),%eax
  100541:	01 d0                	add    %edx,%eax
  100543:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100547:	0f b6 c0             	movzbl %al,%eax
  10054a:	39 45 14             	cmp    %eax,0x14(%ebp)
  10054d:	75 d4                	jne    100523 <stab_binsearch+0x117>
        *region_left = l;
  10054f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100552:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100555:	89 10                	mov    %edx,(%eax)
}
  100557:	90                   	nop
  100558:	89 ec                	mov    %ebp,%esp
  10055a:	5d                   	pop    %ebp
  10055b:	c3                   	ret    

0010055c <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  10055c:	55                   	push   %ebp
  10055d:	89 e5                	mov    %esp,%ebp
  10055f:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  100562:	8b 45 0c             	mov    0xc(%ebp),%eax
  100565:	c7 00 ac 61 10 00    	movl   $0x1061ac,(%eax)
    info->eip_line = 0;
  10056b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10056e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  100575:	8b 45 0c             	mov    0xc(%ebp),%eax
  100578:	c7 40 08 ac 61 10 00 	movl   $0x1061ac,0x8(%eax)
    info->eip_fn_namelen = 9;
  10057f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100582:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100589:	8b 45 0c             	mov    0xc(%ebp),%eax
  10058c:	8b 55 08             	mov    0x8(%ebp),%edx
  10058f:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100592:	8b 45 0c             	mov    0xc(%ebp),%eax
  100595:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  10059c:	c7 45 f4 6c 74 10 00 	movl   $0x10746c,-0xc(%ebp)
    stab_end = __STAB_END__;
  1005a3:	c7 45 f0 ec 2c 11 00 	movl   $0x112cec,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  1005aa:	c7 45 ec ed 2c 11 00 	movl   $0x112ced,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  1005b1:	c7 45 e8 c3 62 11 00 	movl   $0x1162c3,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  1005b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1005bb:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1005be:	76 0b                	jbe    1005cb <debuginfo_eip+0x6f>
  1005c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1005c3:	48                   	dec    %eax
  1005c4:	0f b6 00             	movzbl (%eax),%eax
  1005c7:	84 c0                	test   %al,%al
  1005c9:	74 0a                	je     1005d5 <debuginfo_eip+0x79>
        return -1;
  1005cb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1005d0:	e9 ab 02 00 00       	jmp    100880 <debuginfo_eip+0x324>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  1005d5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  1005dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1005df:	2b 45 f4             	sub    -0xc(%ebp),%eax
  1005e2:	c1 f8 02             	sar    $0x2,%eax
  1005e5:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1005eb:	48                   	dec    %eax
  1005ec:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1005ef:	8b 45 08             	mov    0x8(%ebp),%eax
  1005f2:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005f6:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1005fd:	00 
  1005fe:	8d 45 e0             	lea    -0x20(%ebp),%eax
  100601:	89 44 24 08          	mov    %eax,0x8(%esp)
  100605:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  100608:	89 44 24 04          	mov    %eax,0x4(%esp)
  10060c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10060f:	89 04 24             	mov    %eax,(%esp)
  100612:	e8 f5 fd ff ff       	call   10040c <stab_binsearch>
    if (lfile == 0)
  100617:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10061a:	85 c0                	test   %eax,%eax
  10061c:	75 0a                	jne    100628 <debuginfo_eip+0xcc>
        return -1;
  10061e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100623:	e9 58 02 00 00       	jmp    100880 <debuginfo_eip+0x324>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  100628:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10062b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  10062e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100631:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  100634:	8b 45 08             	mov    0x8(%ebp),%eax
  100637:	89 44 24 10          	mov    %eax,0x10(%esp)
  10063b:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  100642:	00 
  100643:	8d 45 d8             	lea    -0x28(%ebp),%eax
  100646:	89 44 24 08          	mov    %eax,0x8(%esp)
  10064a:	8d 45 dc             	lea    -0x24(%ebp),%eax
  10064d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100651:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100654:	89 04 24             	mov    %eax,(%esp)
  100657:	e8 b0 fd ff ff       	call   10040c <stab_binsearch>

    if (lfun <= rfun) {
  10065c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10065f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100662:	39 c2                	cmp    %eax,%edx
  100664:	7f 78                	jg     1006de <debuginfo_eip+0x182>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  100666:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100669:	89 c2                	mov    %eax,%edx
  10066b:	89 d0                	mov    %edx,%eax
  10066d:	01 c0                	add    %eax,%eax
  10066f:	01 d0                	add    %edx,%eax
  100671:	c1 e0 02             	shl    $0x2,%eax
  100674:	89 c2                	mov    %eax,%edx
  100676:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100679:	01 d0                	add    %edx,%eax
  10067b:	8b 10                	mov    (%eax),%edx
  10067d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100680:	2b 45 ec             	sub    -0x14(%ebp),%eax
  100683:	39 c2                	cmp    %eax,%edx
  100685:	73 22                	jae    1006a9 <debuginfo_eip+0x14d>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  100687:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10068a:	89 c2                	mov    %eax,%edx
  10068c:	89 d0                	mov    %edx,%eax
  10068e:	01 c0                	add    %eax,%eax
  100690:	01 d0                	add    %edx,%eax
  100692:	c1 e0 02             	shl    $0x2,%eax
  100695:	89 c2                	mov    %eax,%edx
  100697:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10069a:	01 d0                	add    %edx,%eax
  10069c:	8b 10                	mov    (%eax),%edx
  10069e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1006a1:	01 c2                	add    %eax,%edx
  1006a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006a6:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  1006a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006ac:	89 c2                	mov    %eax,%edx
  1006ae:	89 d0                	mov    %edx,%eax
  1006b0:	01 c0                	add    %eax,%eax
  1006b2:	01 d0                	add    %edx,%eax
  1006b4:	c1 e0 02             	shl    $0x2,%eax
  1006b7:	89 c2                	mov    %eax,%edx
  1006b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006bc:	01 d0                	add    %edx,%eax
  1006be:	8b 50 08             	mov    0x8(%eax),%edx
  1006c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006c4:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  1006c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006ca:	8b 40 10             	mov    0x10(%eax),%eax
  1006cd:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  1006d0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006d3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  1006d6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006d9:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1006dc:	eb 15                	jmp    1006f3 <debuginfo_eip+0x197>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  1006de:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006e1:	8b 55 08             	mov    0x8(%ebp),%edx
  1006e4:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1006e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006ea:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1006ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006f0:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1006f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006f6:	8b 40 08             	mov    0x8(%eax),%eax
  1006f9:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  100700:	00 
  100701:	89 04 24             	mov    %eax,(%esp)
  100704:	e8 e0 56 00 00       	call   105de9 <strfind>
  100709:	8b 55 0c             	mov    0xc(%ebp),%edx
  10070c:	8b 4a 08             	mov    0x8(%edx),%ecx
  10070f:	29 c8                	sub    %ecx,%eax
  100711:	89 c2                	mov    %eax,%edx
  100713:	8b 45 0c             	mov    0xc(%ebp),%eax
  100716:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  100719:	8b 45 08             	mov    0x8(%ebp),%eax
  10071c:	89 44 24 10          	mov    %eax,0x10(%esp)
  100720:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  100727:	00 
  100728:	8d 45 d0             	lea    -0x30(%ebp),%eax
  10072b:	89 44 24 08          	mov    %eax,0x8(%esp)
  10072f:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  100732:	89 44 24 04          	mov    %eax,0x4(%esp)
  100736:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100739:	89 04 24             	mov    %eax,(%esp)
  10073c:	e8 cb fc ff ff       	call   10040c <stab_binsearch>
    if (lline <= rline) {
  100741:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100744:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100747:	39 c2                	cmp    %eax,%edx
  100749:	7f 23                	jg     10076e <debuginfo_eip+0x212>
        info->eip_line = stabs[rline].n_desc;
  10074b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10074e:	89 c2                	mov    %eax,%edx
  100750:	89 d0                	mov    %edx,%eax
  100752:	01 c0                	add    %eax,%eax
  100754:	01 d0                	add    %edx,%eax
  100756:	c1 e0 02             	shl    $0x2,%eax
  100759:	89 c2                	mov    %eax,%edx
  10075b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10075e:	01 d0                	add    %edx,%eax
  100760:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  100764:	89 c2                	mov    %eax,%edx
  100766:	8b 45 0c             	mov    0xc(%ebp),%eax
  100769:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  10076c:	eb 11                	jmp    10077f <debuginfo_eip+0x223>
        return -1;
  10076e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100773:	e9 08 01 00 00       	jmp    100880 <debuginfo_eip+0x324>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  100778:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10077b:	48                   	dec    %eax
  10077c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
  10077f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100782:	8b 45 e4             	mov    -0x1c(%ebp),%eax
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100785:	39 c2                	cmp    %eax,%edx
  100787:	7c 56                	jl     1007df <debuginfo_eip+0x283>
           && stabs[lline].n_type != N_SOL
  100789:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10078c:	89 c2                	mov    %eax,%edx
  10078e:	89 d0                	mov    %edx,%eax
  100790:	01 c0                	add    %eax,%eax
  100792:	01 d0                	add    %edx,%eax
  100794:	c1 e0 02             	shl    $0x2,%eax
  100797:	89 c2                	mov    %eax,%edx
  100799:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10079c:	01 d0                	add    %edx,%eax
  10079e:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1007a2:	3c 84                	cmp    $0x84,%al
  1007a4:	74 39                	je     1007df <debuginfo_eip+0x283>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  1007a6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007a9:	89 c2                	mov    %eax,%edx
  1007ab:	89 d0                	mov    %edx,%eax
  1007ad:	01 c0                	add    %eax,%eax
  1007af:	01 d0                	add    %edx,%eax
  1007b1:	c1 e0 02             	shl    $0x2,%eax
  1007b4:	89 c2                	mov    %eax,%edx
  1007b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007b9:	01 d0                	add    %edx,%eax
  1007bb:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1007bf:	3c 64                	cmp    $0x64,%al
  1007c1:	75 b5                	jne    100778 <debuginfo_eip+0x21c>
  1007c3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007c6:	89 c2                	mov    %eax,%edx
  1007c8:	89 d0                	mov    %edx,%eax
  1007ca:	01 c0                	add    %eax,%eax
  1007cc:	01 d0                	add    %edx,%eax
  1007ce:	c1 e0 02             	shl    $0x2,%eax
  1007d1:	89 c2                	mov    %eax,%edx
  1007d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007d6:	01 d0                	add    %edx,%eax
  1007d8:	8b 40 08             	mov    0x8(%eax),%eax
  1007db:	85 c0                	test   %eax,%eax
  1007dd:	74 99                	je     100778 <debuginfo_eip+0x21c>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  1007df:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007e5:	39 c2                	cmp    %eax,%edx
  1007e7:	7c 42                	jl     10082b <debuginfo_eip+0x2cf>
  1007e9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007ec:	89 c2                	mov    %eax,%edx
  1007ee:	89 d0                	mov    %edx,%eax
  1007f0:	01 c0                	add    %eax,%eax
  1007f2:	01 d0                	add    %edx,%eax
  1007f4:	c1 e0 02             	shl    $0x2,%eax
  1007f7:	89 c2                	mov    %eax,%edx
  1007f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007fc:	01 d0                	add    %edx,%eax
  1007fe:	8b 10                	mov    (%eax),%edx
  100800:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100803:	2b 45 ec             	sub    -0x14(%ebp),%eax
  100806:	39 c2                	cmp    %eax,%edx
  100808:	73 21                	jae    10082b <debuginfo_eip+0x2cf>
        info->eip_file = stabstr + stabs[lline].n_strx;
  10080a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10080d:	89 c2                	mov    %eax,%edx
  10080f:	89 d0                	mov    %edx,%eax
  100811:	01 c0                	add    %eax,%eax
  100813:	01 d0                	add    %edx,%eax
  100815:	c1 e0 02             	shl    $0x2,%eax
  100818:	89 c2                	mov    %eax,%edx
  10081a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10081d:	01 d0                	add    %edx,%eax
  10081f:	8b 10                	mov    (%eax),%edx
  100821:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100824:	01 c2                	add    %eax,%edx
  100826:	8b 45 0c             	mov    0xc(%ebp),%eax
  100829:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  10082b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10082e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100831:	39 c2                	cmp    %eax,%edx
  100833:	7d 46                	jge    10087b <debuginfo_eip+0x31f>
        for (lline = lfun + 1;
  100835:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100838:	40                   	inc    %eax
  100839:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  10083c:	eb 16                	jmp    100854 <debuginfo_eip+0x2f8>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  10083e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100841:	8b 40 14             	mov    0x14(%eax),%eax
  100844:	8d 50 01             	lea    0x1(%eax),%edx
  100847:	8b 45 0c             	mov    0xc(%ebp),%eax
  10084a:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
  10084d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100850:	40                   	inc    %eax
  100851:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100854:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100857:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10085a:	39 c2                	cmp    %eax,%edx
  10085c:	7d 1d                	jge    10087b <debuginfo_eip+0x31f>
  10085e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100861:	89 c2                	mov    %eax,%edx
  100863:	89 d0                	mov    %edx,%eax
  100865:	01 c0                	add    %eax,%eax
  100867:	01 d0                	add    %edx,%eax
  100869:	c1 e0 02             	shl    $0x2,%eax
  10086c:	89 c2                	mov    %eax,%edx
  10086e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100871:	01 d0                	add    %edx,%eax
  100873:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100877:	3c a0                	cmp    $0xa0,%al
  100879:	74 c3                	je     10083e <debuginfo_eip+0x2e2>
        }
    }
    return 0;
  10087b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100880:	89 ec                	mov    %ebp,%esp
  100882:	5d                   	pop    %ebp
  100883:	c3                   	ret    

00100884 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100884:	55                   	push   %ebp
  100885:	89 e5                	mov    %esp,%ebp
  100887:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  10088a:	c7 04 24 b6 61 10 00 	movl   $0x1061b6,(%esp)
  100891:	e8 cb fa ff ff       	call   100361 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100896:	c7 44 24 04 36 00 10 	movl   $0x100036,0x4(%esp)
  10089d:	00 
  10089e:	c7 04 24 cf 61 10 00 	movl   $0x1061cf,(%esp)
  1008a5:	e8 b7 fa ff ff       	call   100361 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  1008aa:	c7 44 24 04 fd 60 10 	movl   $0x1060fd,0x4(%esp)
  1008b1:	00 
  1008b2:	c7 04 24 e7 61 10 00 	movl   $0x1061e7,(%esp)
  1008b9:	e8 a3 fa ff ff       	call   100361 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  1008be:	c7 44 24 04 36 9a 11 	movl   $0x119a36,0x4(%esp)
  1008c5:	00 
  1008c6:	c7 04 24 ff 61 10 00 	movl   $0x1061ff,(%esp)
  1008cd:	e8 8f fa ff ff       	call   100361 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  1008d2:	c7 44 24 04 2c cf 11 	movl   $0x11cf2c,0x4(%esp)
  1008d9:	00 
  1008da:	c7 04 24 17 62 10 00 	movl   $0x106217,(%esp)
  1008e1:	e8 7b fa ff ff       	call   100361 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1008e6:	b8 2c cf 11 00       	mov    $0x11cf2c,%eax
  1008eb:	2d 36 00 10 00       	sub    $0x100036,%eax
  1008f0:	05 ff 03 00 00       	add    $0x3ff,%eax
  1008f5:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008fb:	85 c0                	test   %eax,%eax
  1008fd:	0f 48 c2             	cmovs  %edx,%eax
  100900:	c1 f8 0a             	sar    $0xa,%eax
  100903:	89 44 24 04          	mov    %eax,0x4(%esp)
  100907:	c7 04 24 30 62 10 00 	movl   $0x106230,(%esp)
  10090e:	e8 4e fa ff ff       	call   100361 <cprintf>
}
  100913:	90                   	nop
  100914:	89 ec                	mov    %ebp,%esp
  100916:	5d                   	pop    %ebp
  100917:	c3                   	ret    

00100918 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  100918:	55                   	push   %ebp
  100919:	89 e5                	mov    %esp,%ebp
  10091b:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  100921:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100924:	89 44 24 04          	mov    %eax,0x4(%esp)
  100928:	8b 45 08             	mov    0x8(%ebp),%eax
  10092b:	89 04 24             	mov    %eax,(%esp)
  10092e:	e8 29 fc ff ff       	call   10055c <debuginfo_eip>
  100933:	85 c0                	test   %eax,%eax
  100935:	74 15                	je     10094c <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  100937:	8b 45 08             	mov    0x8(%ebp),%eax
  10093a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10093e:	c7 04 24 5a 62 10 00 	movl   $0x10625a,(%esp)
  100945:	e8 17 fa ff ff       	call   100361 <cprintf>
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
  10094a:	eb 6c                	jmp    1009b8 <print_debuginfo+0xa0>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  10094c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100953:	eb 1b                	jmp    100970 <print_debuginfo+0x58>
            fnname[j] = info.eip_fn_name[j];
  100955:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100958:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10095b:	01 d0                	add    %edx,%eax
  10095d:	0f b6 10             	movzbl (%eax),%edx
  100960:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100966:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100969:	01 c8                	add    %ecx,%eax
  10096b:	88 10                	mov    %dl,(%eax)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  10096d:	ff 45 f4             	incl   -0xc(%ebp)
  100970:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100973:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  100976:	7c dd                	jl     100955 <print_debuginfo+0x3d>
        fnname[j] = '\0';
  100978:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  10097e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100981:	01 d0                	add    %edx,%eax
  100983:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
  100986:	8b 55 ec             	mov    -0x14(%ebp),%edx
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100989:	8b 45 08             	mov    0x8(%ebp),%eax
  10098c:	29 d0                	sub    %edx,%eax
  10098e:	89 c1                	mov    %eax,%ecx
  100990:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100993:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100996:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  10099a:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  1009a0:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  1009a4:	89 54 24 08          	mov    %edx,0x8(%esp)
  1009a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009ac:	c7 04 24 76 62 10 00 	movl   $0x106276,(%esp)
  1009b3:	e8 a9 f9 ff ff       	call   100361 <cprintf>
}
  1009b8:	90                   	nop
  1009b9:	89 ec                	mov    %ebp,%esp
  1009bb:	5d                   	pop    %ebp
  1009bc:	c3                   	ret    

001009bd <read_eip>:

static __noinline uint32_t
read_eip(void) {
  1009bd:	55                   	push   %ebp
  1009be:	89 e5                	mov    %esp,%ebp
  1009c0:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  1009c3:	8b 45 04             	mov    0x4(%ebp),%eax
  1009c6:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  1009c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1009cc:	89 ec                	mov    %ebp,%esp
  1009ce:	5d                   	pop    %ebp
  1009cf:	c3                   	ret    

001009d0 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  1009d0:	55                   	push   %ebp
  1009d1:	89 e5                	mov    %esp,%ebp
  1009d3:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  1009d6:	89 e8                	mov    %ebp,%eax
  1009d8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return ebp;
  1009db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp=read_ebp();
  1009de:	89 45 f4             	mov    %eax,-0xc(%ebp)
    uint32_t eip=read_eip();
  1009e1:	e8 d7 ff ff ff       	call   1009bd <read_eip>
  1009e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    for(int i=0;i<STACKFRAME_DEPTH && ebp!=0;i++){
  1009e9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1009f0:	e9 a0 00 00 00       	jmp    100a95 <print_stackframe+0xc5>
    cprintf("ebp:0x%08x",ebp);
  1009f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009fc:	c7 04 24 88 62 10 00 	movl   $0x106288,(%esp)
  100a03:	e8 59 f9 ff ff       	call   100361 <cprintf>
    cprintf(" eip:0x%08x",eip);
  100a08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a0b:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a0f:	c7 04 24 93 62 10 00 	movl   $0x106293,(%esp)
  100a16:	e8 46 f9 ff ff       	call   100361 <cprintf>
    cprintf(" args:");
  100a1b:	c7 04 24 9f 62 10 00 	movl   $0x10629f,(%esp)
  100a22:	e8 3a f9 ff ff       	call   100361 <cprintf>
    for(int j=1;j<5;j++){
  100a27:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
  100a2e:	eb 31                	jmp    100a61 <print_stackframe+0x91>
        cprintf("0x%08x",*(uint32_t*)(ebp + 4*j + 4));
  100a30:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a33:	c1 e0 02             	shl    $0x2,%eax
  100a36:	89 c2                	mov    %eax,%edx
  100a38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a3b:	01 d0                	add    %edx,%eax
  100a3d:	83 c0 04             	add    $0x4,%eax
  100a40:	8b 00                	mov    (%eax),%eax
  100a42:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a46:	c7 04 24 a6 62 10 00 	movl   $0x1062a6,(%esp)
  100a4d:	e8 0f f9 ff ff       	call   100361 <cprintf>
        cprintf(" ");
  100a52:	c7 04 24 ad 62 10 00 	movl   $0x1062ad,(%esp)
  100a59:	e8 03 f9 ff ff       	call   100361 <cprintf>
    for(int j=1;j<5;j++){
  100a5e:	ff 45 e8             	incl   -0x18(%ebp)
  100a61:	83 7d e8 04          	cmpl   $0x4,-0x18(%ebp)
  100a65:	7e c9                	jle    100a30 <print_stackframe+0x60>
    }
    cprintf("\n");
  100a67:	c7 04 24 af 62 10 00 	movl   $0x1062af,(%esp)
  100a6e:	e8 ee f8 ff ff       	call   100361 <cprintf>
    print_debuginfo(eip-1);
  100a73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a76:	48                   	dec    %eax
  100a77:	89 04 24             	mov    %eax,(%esp)
  100a7a:	e8 99 fe ff ff       	call   100918 <print_debuginfo>
    eip=*(uint32_t*)(ebp+4);
  100a7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a82:	83 c0 04             	add    $0x4,%eax
  100a85:	8b 00                	mov    (%eax),%eax
  100a87:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ebp=*(uint32_t*)(ebp);
  100a8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a8d:	8b 00                	mov    (%eax),%eax
  100a8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for(int i=0;i<STACKFRAME_DEPTH && ebp!=0;i++){
  100a92:	ff 45 ec             	incl   -0x14(%ebp)
  100a95:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100a99:	7f 0a                	jg     100aa5 <print_stackframe+0xd5>
  100a9b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100a9f:	0f 85 50 ff ff ff    	jne    1009f5 <print_stackframe+0x25>
    }
}
  100aa5:	90                   	nop
  100aa6:	89 ec                	mov    %ebp,%esp
  100aa8:	5d                   	pop    %ebp
  100aa9:	c3                   	ret    

00100aaa <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100aaa:	55                   	push   %ebp
  100aab:	89 e5                	mov    %esp,%ebp
  100aad:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100ab0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100ab7:	eb 0c                	jmp    100ac5 <parse+0x1b>
            *buf ++ = '\0';
  100ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  100abc:	8d 50 01             	lea    0x1(%eax),%edx
  100abf:	89 55 08             	mov    %edx,0x8(%ebp)
  100ac2:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100ac5:	8b 45 08             	mov    0x8(%ebp),%eax
  100ac8:	0f b6 00             	movzbl (%eax),%eax
  100acb:	84 c0                	test   %al,%al
  100acd:	74 1d                	je     100aec <parse+0x42>
  100acf:	8b 45 08             	mov    0x8(%ebp),%eax
  100ad2:	0f b6 00             	movzbl (%eax),%eax
  100ad5:	0f be c0             	movsbl %al,%eax
  100ad8:	89 44 24 04          	mov    %eax,0x4(%esp)
  100adc:	c7 04 24 34 63 10 00 	movl   $0x106334,(%esp)
  100ae3:	e8 cd 52 00 00       	call   105db5 <strchr>
  100ae8:	85 c0                	test   %eax,%eax
  100aea:	75 cd                	jne    100ab9 <parse+0xf>
        }
        if (*buf == '\0') {
  100aec:	8b 45 08             	mov    0x8(%ebp),%eax
  100aef:	0f b6 00             	movzbl (%eax),%eax
  100af2:	84 c0                	test   %al,%al
  100af4:	74 65                	je     100b5b <parse+0xb1>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100af6:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100afa:	75 14                	jne    100b10 <parse+0x66>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100afc:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100b03:	00 
  100b04:	c7 04 24 39 63 10 00 	movl   $0x106339,(%esp)
  100b0b:	e8 51 f8 ff ff       	call   100361 <cprintf>
        }
        argv[argc ++] = buf;
  100b10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b13:	8d 50 01             	lea    0x1(%eax),%edx
  100b16:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100b19:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100b20:	8b 45 0c             	mov    0xc(%ebp),%eax
  100b23:	01 c2                	add    %eax,%edx
  100b25:	8b 45 08             	mov    0x8(%ebp),%eax
  100b28:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b2a:	eb 03                	jmp    100b2f <parse+0x85>
            buf ++;
  100b2c:	ff 45 08             	incl   0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  100b32:	0f b6 00             	movzbl (%eax),%eax
  100b35:	84 c0                	test   %al,%al
  100b37:	74 8c                	je     100ac5 <parse+0x1b>
  100b39:	8b 45 08             	mov    0x8(%ebp),%eax
  100b3c:	0f b6 00             	movzbl (%eax),%eax
  100b3f:	0f be c0             	movsbl %al,%eax
  100b42:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b46:	c7 04 24 34 63 10 00 	movl   $0x106334,(%esp)
  100b4d:	e8 63 52 00 00       	call   105db5 <strchr>
  100b52:	85 c0                	test   %eax,%eax
  100b54:	74 d6                	je     100b2c <parse+0x82>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b56:	e9 6a ff ff ff       	jmp    100ac5 <parse+0x1b>
            break;
  100b5b:	90                   	nop
        }
    }
    return argc;
  100b5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100b5f:	89 ec                	mov    %ebp,%esp
  100b61:	5d                   	pop    %ebp
  100b62:	c3                   	ret    

00100b63 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100b63:	55                   	push   %ebp
  100b64:	89 e5                	mov    %esp,%ebp
  100b66:	83 ec 68             	sub    $0x68,%esp
  100b69:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100b6c:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b6f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b73:	8b 45 08             	mov    0x8(%ebp),%eax
  100b76:	89 04 24             	mov    %eax,(%esp)
  100b79:	e8 2c ff ff ff       	call   100aaa <parse>
  100b7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100b81:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100b85:	75 0a                	jne    100b91 <runcmd+0x2e>
        return 0;
  100b87:	b8 00 00 00 00       	mov    $0x0,%eax
  100b8c:	e9 83 00 00 00       	jmp    100c14 <runcmd+0xb1>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b91:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b98:	eb 5a                	jmp    100bf4 <runcmd+0x91>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100b9a:	8b 55 b0             	mov    -0x50(%ebp),%edx
  100b9d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  100ba0:	89 c8                	mov    %ecx,%eax
  100ba2:	01 c0                	add    %eax,%eax
  100ba4:	01 c8                	add    %ecx,%eax
  100ba6:	c1 e0 02             	shl    $0x2,%eax
  100ba9:	05 00 90 11 00       	add    $0x119000,%eax
  100bae:	8b 00                	mov    (%eax),%eax
  100bb0:	89 54 24 04          	mov    %edx,0x4(%esp)
  100bb4:	89 04 24             	mov    %eax,(%esp)
  100bb7:	e8 5d 51 00 00       	call   105d19 <strcmp>
  100bbc:	85 c0                	test   %eax,%eax
  100bbe:	75 31                	jne    100bf1 <runcmd+0x8e>
            return commands[i].func(argc - 1, argv + 1, tf);
  100bc0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100bc3:	89 d0                	mov    %edx,%eax
  100bc5:	01 c0                	add    %eax,%eax
  100bc7:	01 d0                	add    %edx,%eax
  100bc9:	c1 e0 02             	shl    $0x2,%eax
  100bcc:	05 08 90 11 00       	add    $0x119008,%eax
  100bd1:	8b 10                	mov    (%eax),%edx
  100bd3:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100bd6:	83 c0 04             	add    $0x4,%eax
  100bd9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100bdc:	8d 59 ff             	lea    -0x1(%ecx),%ebx
  100bdf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  100be2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100be6:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bea:	89 1c 24             	mov    %ebx,(%esp)
  100bed:	ff d2                	call   *%edx
  100bef:	eb 23                	jmp    100c14 <runcmd+0xb1>
    for (i = 0; i < NCOMMANDS; i ++) {
  100bf1:	ff 45 f4             	incl   -0xc(%ebp)
  100bf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bf7:	83 f8 02             	cmp    $0x2,%eax
  100bfa:	76 9e                	jbe    100b9a <runcmd+0x37>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100bfc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100bff:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c03:	c7 04 24 57 63 10 00 	movl   $0x106357,(%esp)
  100c0a:	e8 52 f7 ff ff       	call   100361 <cprintf>
    return 0;
  100c0f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c14:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  100c17:	89 ec                	mov    %ebp,%esp
  100c19:	5d                   	pop    %ebp
  100c1a:	c3                   	ret    

00100c1b <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100c1b:	55                   	push   %ebp
  100c1c:	89 e5                	mov    %esp,%ebp
  100c1e:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100c21:	c7 04 24 70 63 10 00 	movl   $0x106370,(%esp)
  100c28:	e8 34 f7 ff ff       	call   100361 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100c2d:	c7 04 24 98 63 10 00 	movl   $0x106398,(%esp)
  100c34:	e8 28 f7 ff ff       	call   100361 <cprintf>

    if (tf != NULL) {
  100c39:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100c3d:	74 0b                	je     100c4a <kmonitor+0x2f>
        print_trapframe(tf);
  100c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  100c42:	89 04 24             	mov    %eax,(%esp)
  100c45:	e8 ee 0e 00 00       	call   101b38 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100c4a:	c7 04 24 bd 63 10 00 	movl   $0x1063bd,(%esp)
  100c51:	e8 fc f5 ff ff       	call   100252 <readline>
  100c56:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100c59:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100c5d:	74 eb                	je     100c4a <kmonitor+0x2f>
            if (runcmd(buf, tf) < 0) {
  100c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  100c62:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c69:	89 04 24             	mov    %eax,(%esp)
  100c6c:	e8 f2 fe ff ff       	call   100b63 <runcmd>
  100c71:	85 c0                	test   %eax,%eax
  100c73:	78 02                	js     100c77 <kmonitor+0x5c>
        if ((buf = readline("K> ")) != NULL) {
  100c75:	eb d3                	jmp    100c4a <kmonitor+0x2f>
                break;
  100c77:	90                   	nop
            }
        }
    }
}
  100c78:	90                   	nop
  100c79:	89 ec                	mov    %ebp,%esp
  100c7b:	5d                   	pop    %ebp
  100c7c:	c3                   	ret    

00100c7d <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100c7d:	55                   	push   %ebp
  100c7e:	89 e5                	mov    %esp,%ebp
  100c80:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c83:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c8a:	eb 3d                	jmp    100cc9 <mon_help+0x4c>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100c8c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c8f:	89 d0                	mov    %edx,%eax
  100c91:	01 c0                	add    %eax,%eax
  100c93:	01 d0                	add    %edx,%eax
  100c95:	c1 e0 02             	shl    $0x2,%eax
  100c98:	05 04 90 11 00       	add    $0x119004,%eax
  100c9d:	8b 10                	mov    (%eax),%edx
  100c9f:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  100ca2:	89 c8                	mov    %ecx,%eax
  100ca4:	01 c0                	add    %eax,%eax
  100ca6:	01 c8                	add    %ecx,%eax
  100ca8:	c1 e0 02             	shl    $0x2,%eax
  100cab:	05 00 90 11 00       	add    $0x119000,%eax
  100cb0:	8b 00                	mov    (%eax),%eax
  100cb2:	89 54 24 08          	mov    %edx,0x8(%esp)
  100cb6:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cba:	c7 04 24 c1 63 10 00 	movl   $0x1063c1,(%esp)
  100cc1:	e8 9b f6 ff ff       	call   100361 <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
  100cc6:	ff 45 f4             	incl   -0xc(%ebp)
  100cc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ccc:	83 f8 02             	cmp    $0x2,%eax
  100ccf:	76 bb                	jbe    100c8c <mon_help+0xf>
    }
    return 0;
  100cd1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cd6:	89 ec                	mov    %ebp,%esp
  100cd8:	5d                   	pop    %ebp
  100cd9:	c3                   	ret    

00100cda <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100cda:	55                   	push   %ebp
  100cdb:	89 e5                	mov    %esp,%ebp
  100cdd:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100ce0:	e8 9f fb ff ff       	call   100884 <print_kerninfo>
    return 0;
  100ce5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cea:	89 ec                	mov    %ebp,%esp
  100cec:	5d                   	pop    %ebp
  100ced:	c3                   	ret    

00100cee <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100cee:	55                   	push   %ebp
  100cef:	89 e5                	mov    %esp,%ebp
  100cf1:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100cf4:	e8 d7 fc ff ff       	call   1009d0 <print_stackframe>
    return 0;
  100cf9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cfe:	89 ec                	mov    %ebp,%esp
  100d00:	5d                   	pop    %ebp
  100d01:	c3                   	ret    

00100d02 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100d02:	55                   	push   %ebp
  100d03:	89 e5                	mov    %esp,%ebp
  100d05:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100d08:	a1 20 c4 11 00       	mov    0x11c420,%eax
  100d0d:	85 c0                	test   %eax,%eax
  100d0f:	75 5b                	jne    100d6c <__panic+0x6a>
        goto panic_dead;
    }
    is_panic = 1;
  100d11:	c7 05 20 c4 11 00 01 	movl   $0x1,0x11c420
  100d18:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100d1b:	8d 45 14             	lea    0x14(%ebp),%eax
  100d1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100d21:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d24:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d28:	8b 45 08             	mov    0x8(%ebp),%eax
  100d2b:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d2f:	c7 04 24 ca 63 10 00 	movl   $0x1063ca,(%esp)
  100d36:	e8 26 f6 ff ff       	call   100361 <cprintf>
    vcprintf(fmt, ap);
  100d3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d3e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d42:	8b 45 10             	mov    0x10(%ebp),%eax
  100d45:	89 04 24             	mov    %eax,(%esp)
  100d48:	e8 df f5 ff ff       	call   10032c <vcprintf>
    cprintf("\n");
  100d4d:	c7 04 24 e6 63 10 00 	movl   $0x1063e6,(%esp)
  100d54:	e8 08 f6 ff ff       	call   100361 <cprintf>
    
    cprintf("stack trackback:\n");
  100d59:	c7 04 24 e8 63 10 00 	movl   $0x1063e8,(%esp)
  100d60:	e8 fc f5 ff ff       	call   100361 <cprintf>
    print_stackframe();
  100d65:	e8 66 fc ff ff       	call   1009d0 <print_stackframe>
  100d6a:	eb 01                	jmp    100d6d <__panic+0x6b>
        goto panic_dead;
  100d6c:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
  100d6d:	e8 e9 09 00 00       	call   10175b <intr_disable>
    while (1) {
        kmonitor(NULL);
  100d72:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100d79:	e8 9d fe ff ff       	call   100c1b <kmonitor>
  100d7e:	eb f2                	jmp    100d72 <__panic+0x70>

00100d80 <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100d80:	55                   	push   %ebp
  100d81:	89 e5                	mov    %esp,%ebp
  100d83:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100d86:	8d 45 14             	lea    0x14(%ebp),%eax
  100d89:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100d8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d8f:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d93:	8b 45 08             	mov    0x8(%ebp),%eax
  100d96:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d9a:	c7 04 24 fa 63 10 00 	movl   $0x1063fa,(%esp)
  100da1:	e8 bb f5 ff ff       	call   100361 <cprintf>
    vcprintf(fmt, ap);
  100da6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100da9:	89 44 24 04          	mov    %eax,0x4(%esp)
  100dad:	8b 45 10             	mov    0x10(%ebp),%eax
  100db0:	89 04 24             	mov    %eax,(%esp)
  100db3:	e8 74 f5 ff ff       	call   10032c <vcprintf>
    cprintf("\n");
  100db8:	c7 04 24 e6 63 10 00 	movl   $0x1063e6,(%esp)
  100dbf:	e8 9d f5 ff ff       	call   100361 <cprintf>
    va_end(ap);
}
  100dc4:	90                   	nop
  100dc5:	89 ec                	mov    %ebp,%esp
  100dc7:	5d                   	pop    %ebp
  100dc8:	c3                   	ret    

00100dc9 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100dc9:	55                   	push   %ebp
  100dca:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100dcc:	a1 20 c4 11 00       	mov    0x11c420,%eax
}
  100dd1:	5d                   	pop    %ebp
  100dd2:	c3                   	ret    

00100dd3 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100dd3:	55                   	push   %ebp
  100dd4:	89 e5                	mov    %esp,%ebp
  100dd6:	83 ec 28             	sub    $0x28,%esp
  100dd9:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
  100ddf:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100de3:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100de7:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100deb:	ee                   	out    %al,(%dx)
}
  100dec:	90                   	nop
  100ded:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100df3:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100df7:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100dfb:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100dff:	ee                   	out    %al,(%dx)
}
  100e00:	90                   	nop
  100e01:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
  100e07:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100e0b:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100e0f:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100e13:	ee                   	out    %al,(%dx)
}
  100e14:	90                   	nop
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100e15:	c7 05 24 c4 11 00 00 	movl   $0x0,0x11c424
  100e1c:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100e1f:	c7 04 24 18 64 10 00 	movl   $0x106418,(%esp)
  100e26:	e8 36 f5 ff ff       	call   100361 <cprintf>
    pic_enable(IRQ_TIMER);
  100e2b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100e32:	e8 89 09 00 00       	call   1017c0 <pic_enable>
}
  100e37:	90                   	nop
  100e38:	89 ec                	mov    %ebp,%esp
  100e3a:	5d                   	pop    %ebp
  100e3b:	c3                   	ret    

00100e3c <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  100e3c:	55                   	push   %ebp
  100e3d:	89 e5                	mov    %esp,%ebp
  100e3f:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  100e42:	9c                   	pushf  
  100e43:	58                   	pop    %eax
  100e44:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  100e47:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  100e4a:	25 00 02 00 00       	and    $0x200,%eax
  100e4f:	85 c0                	test   %eax,%eax
  100e51:	74 0c                	je     100e5f <__intr_save+0x23>
        intr_disable();
  100e53:	e8 03 09 00 00       	call   10175b <intr_disable>
        return 1;
  100e58:	b8 01 00 00 00       	mov    $0x1,%eax
  100e5d:	eb 05                	jmp    100e64 <__intr_save+0x28>
    }
    return 0;
  100e5f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100e64:	89 ec                	mov    %ebp,%esp
  100e66:	5d                   	pop    %ebp
  100e67:	c3                   	ret    

00100e68 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  100e68:	55                   	push   %ebp
  100e69:	89 e5                	mov    %esp,%ebp
  100e6b:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  100e6e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100e72:	74 05                	je     100e79 <__intr_restore+0x11>
        intr_enable();
  100e74:	e8 da 08 00 00       	call   101753 <intr_enable>
    }
}
  100e79:	90                   	nop
  100e7a:	89 ec                	mov    %ebp,%esp
  100e7c:	5d                   	pop    %ebp
  100e7d:	c3                   	ret    

00100e7e <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100e7e:	55                   	push   %ebp
  100e7f:	89 e5                	mov    %esp,%ebp
  100e81:	83 ec 10             	sub    $0x10,%esp
  100e84:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100e8a:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e8e:	89 c2                	mov    %eax,%edx
  100e90:	ec                   	in     (%dx),%al
  100e91:	88 45 f1             	mov    %al,-0xf(%ebp)
  100e94:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100e9a:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100e9e:	89 c2                	mov    %eax,%edx
  100ea0:	ec                   	in     (%dx),%al
  100ea1:	88 45 f5             	mov    %al,-0xb(%ebp)
  100ea4:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100eaa:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100eae:	89 c2                	mov    %eax,%edx
  100eb0:	ec                   	in     (%dx),%al
  100eb1:	88 45 f9             	mov    %al,-0x7(%ebp)
  100eb4:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
  100eba:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100ebe:	89 c2                	mov    %eax,%edx
  100ec0:	ec                   	in     (%dx),%al
  100ec1:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100ec4:	90                   	nop
  100ec5:	89 ec                	mov    %ebp,%esp
  100ec7:	5d                   	pop    %ebp
  100ec8:	c3                   	ret    

00100ec9 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100ec9:	55                   	push   %ebp
  100eca:	89 e5                	mov    %esp,%ebp
  100ecc:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
  100ecf:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
  100ed6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ed9:	0f b7 00             	movzwl (%eax),%eax
  100edc:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100ee0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ee3:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100ee8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100eeb:	0f b7 00             	movzwl (%eax),%eax
  100eee:	0f b7 c0             	movzwl %ax,%eax
  100ef1:	3d 5a a5 00 00       	cmp    $0xa55a,%eax
  100ef6:	74 12                	je     100f0a <cga_init+0x41>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
  100ef8:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100eff:	66 c7 05 46 c4 11 00 	movw   $0x3b4,0x11c446
  100f06:	b4 03 
  100f08:	eb 13                	jmp    100f1d <cga_init+0x54>
    } else {
        *cp = was;
  100f0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f0d:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100f11:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100f14:	66 c7 05 46 c4 11 00 	movw   $0x3d4,0x11c446
  100f1b:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100f1d:	0f b7 05 46 c4 11 00 	movzwl 0x11c446,%eax
  100f24:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  100f28:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f2c:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f30:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100f34:	ee                   	out    %al,(%dx)
}
  100f35:	90                   	nop
    pos = inb(addr_6845 + 1) << 8;
  100f36:	0f b7 05 46 c4 11 00 	movzwl 0x11c446,%eax
  100f3d:	40                   	inc    %eax
  100f3e:	0f b7 c0             	movzwl %ax,%eax
  100f41:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f45:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
  100f49:	89 c2                	mov    %eax,%edx
  100f4b:	ec                   	in     (%dx),%al
  100f4c:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
  100f4f:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f53:	0f b6 c0             	movzbl %al,%eax
  100f56:	c1 e0 08             	shl    $0x8,%eax
  100f59:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100f5c:	0f b7 05 46 c4 11 00 	movzwl 0x11c446,%eax
  100f63:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  100f67:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f6b:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f6f:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f73:	ee                   	out    %al,(%dx)
}
  100f74:	90                   	nop
    pos |= inb(addr_6845 + 1);
  100f75:	0f b7 05 46 c4 11 00 	movzwl 0x11c446,%eax
  100f7c:	40                   	inc    %eax
  100f7d:	0f b7 c0             	movzwl %ax,%eax
  100f80:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f84:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100f88:	89 c2                	mov    %eax,%edx
  100f8a:	ec                   	in     (%dx),%al
  100f8b:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
  100f8e:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f92:	0f b6 c0             	movzbl %al,%eax
  100f95:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100f98:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f9b:	a3 40 c4 11 00       	mov    %eax,0x11c440
    crt_pos = pos;
  100fa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100fa3:	0f b7 c0             	movzwl %ax,%eax
  100fa6:	66 a3 44 c4 11 00    	mov    %ax,0x11c444
}
  100fac:	90                   	nop
  100fad:	89 ec                	mov    %ebp,%esp
  100faf:	5d                   	pop    %ebp
  100fb0:	c3                   	ret    

00100fb1 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100fb1:	55                   	push   %ebp
  100fb2:	89 e5                	mov    %esp,%ebp
  100fb4:	83 ec 48             	sub    $0x48,%esp
  100fb7:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
  100fbd:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100fc1:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  100fc5:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  100fc9:	ee                   	out    %al,(%dx)
}
  100fca:	90                   	nop
  100fcb:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
  100fd1:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100fd5:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  100fd9:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  100fdd:	ee                   	out    %al,(%dx)
}
  100fde:	90                   	nop
  100fdf:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
  100fe5:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100fe9:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  100fed:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  100ff1:	ee                   	out    %al,(%dx)
}
  100ff2:	90                   	nop
  100ff3:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100ff9:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100ffd:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  101001:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  101005:	ee                   	out    %al,(%dx)
}
  101006:	90                   	nop
  101007:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
  10100d:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101011:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  101015:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  101019:	ee                   	out    %al,(%dx)
}
  10101a:	90                   	nop
  10101b:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
  101021:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101025:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101029:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  10102d:	ee                   	out    %al,(%dx)
}
  10102e:	90                   	nop
  10102f:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  101035:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101039:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10103d:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101041:	ee                   	out    %al,(%dx)
}
  101042:	90                   	nop
  101043:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101049:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  10104d:	89 c2                	mov    %eax,%edx
  10104f:	ec                   	in     (%dx),%al
  101050:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  101053:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  101057:	3c ff                	cmp    $0xff,%al
  101059:	0f 95 c0             	setne  %al
  10105c:	0f b6 c0             	movzbl %al,%eax
  10105f:	a3 48 c4 11 00       	mov    %eax,0x11c448
  101064:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10106a:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  10106e:	89 c2                	mov    %eax,%edx
  101070:	ec                   	in     (%dx),%al
  101071:	88 45 f1             	mov    %al,-0xf(%ebp)
  101074:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  10107a:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10107e:	89 c2                	mov    %eax,%edx
  101080:	ec                   	in     (%dx),%al
  101081:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  101084:	a1 48 c4 11 00       	mov    0x11c448,%eax
  101089:	85 c0                	test   %eax,%eax
  10108b:	74 0c                	je     101099 <serial_init+0xe8>
        pic_enable(IRQ_COM1);
  10108d:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  101094:	e8 27 07 00 00       	call   1017c0 <pic_enable>
    }
}
  101099:	90                   	nop
  10109a:	89 ec                	mov    %ebp,%esp
  10109c:	5d                   	pop    %ebp
  10109d:	c3                   	ret    

0010109e <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  10109e:	55                   	push   %ebp
  10109f:	89 e5                	mov    %esp,%ebp
  1010a1:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  1010a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1010ab:	eb 08                	jmp    1010b5 <lpt_putc_sub+0x17>
        delay();
  1010ad:	e8 cc fd ff ff       	call   100e7e <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  1010b2:	ff 45 fc             	incl   -0x4(%ebp)
  1010b5:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  1010bb:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1010bf:	89 c2                	mov    %eax,%edx
  1010c1:	ec                   	in     (%dx),%al
  1010c2:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1010c5:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1010c9:	84 c0                	test   %al,%al
  1010cb:	78 09                	js     1010d6 <lpt_putc_sub+0x38>
  1010cd:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1010d4:	7e d7                	jle    1010ad <lpt_putc_sub+0xf>
    }
    outb(LPTPORT + 0, c);
  1010d6:	8b 45 08             	mov    0x8(%ebp),%eax
  1010d9:	0f b6 c0             	movzbl %al,%eax
  1010dc:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
  1010e2:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1010e5:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1010e9:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1010ed:	ee                   	out    %al,(%dx)
}
  1010ee:	90                   	nop
  1010ef:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  1010f5:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1010f9:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1010fd:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101101:	ee                   	out    %al,(%dx)
}
  101102:	90                   	nop
  101103:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  101109:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10110d:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101111:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101115:	ee                   	out    %al,(%dx)
}
  101116:	90                   	nop
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  101117:	90                   	nop
  101118:	89 ec                	mov    %ebp,%esp
  10111a:	5d                   	pop    %ebp
  10111b:	c3                   	ret    

0010111c <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  10111c:	55                   	push   %ebp
  10111d:	89 e5                	mov    %esp,%ebp
  10111f:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  101122:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101126:	74 0d                	je     101135 <lpt_putc+0x19>
        lpt_putc_sub(c);
  101128:	8b 45 08             	mov    0x8(%ebp),%eax
  10112b:	89 04 24             	mov    %eax,(%esp)
  10112e:	e8 6b ff ff ff       	call   10109e <lpt_putc_sub>
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  101133:	eb 24                	jmp    101159 <lpt_putc+0x3d>
        lpt_putc_sub('\b');
  101135:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10113c:	e8 5d ff ff ff       	call   10109e <lpt_putc_sub>
        lpt_putc_sub(' ');
  101141:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101148:	e8 51 ff ff ff       	call   10109e <lpt_putc_sub>
        lpt_putc_sub('\b');
  10114d:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101154:	e8 45 ff ff ff       	call   10109e <lpt_putc_sub>
}
  101159:	90                   	nop
  10115a:	89 ec                	mov    %ebp,%esp
  10115c:	5d                   	pop    %ebp
  10115d:	c3                   	ret    

0010115e <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  10115e:	55                   	push   %ebp
  10115f:	89 e5                	mov    %esp,%ebp
  101161:	83 ec 38             	sub    $0x38,%esp
  101164:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    // set black on white
    if (!(c & ~0xFF)) {
  101167:	8b 45 08             	mov    0x8(%ebp),%eax
  10116a:	25 00 ff ff ff       	and    $0xffffff00,%eax
  10116f:	85 c0                	test   %eax,%eax
  101171:	75 07                	jne    10117a <cga_putc+0x1c>
        c |= 0x0700;
  101173:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  10117a:	8b 45 08             	mov    0x8(%ebp),%eax
  10117d:	0f b6 c0             	movzbl %al,%eax
  101180:	83 f8 0d             	cmp    $0xd,%eax
  101183:	74 72                	je     1011f7 <cga_putc+0x99>
  101185:	83 f8 0d             	cmp    $0xd,%eax
  101188:	0f 8f a3 00 00 00    	jg     101231 <cga_putc+0xd3>
  10118e:	83 f8 08             	cmp    $0x8,%eax
  101191:	74 0a                	je     10119d <cga_putc+0x3f>
  101193:	83 f8 0a             	cmp    $0xa,%eax
  101196:	74 4c                	je     1011e4 <cga_putc+0x86>
  101198:	e9 94 00 00 00       	jmp    101231 <cga_putc+0xd3>
    case '\b':
        if (crt_pos > 0) {
  10119d:	0f b7 05 44 c4 11 00 	movzwl 0x11c444,%eax
  1011a4:	85 c0                	test   %eax,%eax
  1011a6:	0f 84 af 00 00 00    	je     10125b <cga_putc+0xfd>
            crt_pos --;
  1011ac:	0f b7 05 44 c4 11 00 	movzwl 0x11c444,%eax
  1011b3:	48                   	dec    %eax
  1011b4:	0f b7 c0             	movzwl %ax,%eax
  1011b7:	66 a3 44 c4 11 00    	mov    %ax,0x11c444
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  1011bd:	8b 45 08             	mov    0x8(%ebp),%eax
  1011c0:	98                   	cwtl   
  1011c1:	25 00 ff ff ff       	and    $0xffffff00,%eax
  1011c6:	98                   	cwtl   
  1011c7:	83 c8 20             	or     $0x20,%eax
  1011ca:	98                   	cwtl   
  1011cb:	8b 0d 40 c4 11 00    	mov    0x11c440,%ecx
  1011d1:	0f b7 15 44 c4 11 00 	movzwl 0x11c444,%edx
  1011d8:	01 d2                	add    %edx,%edx
  1011da:	01 ca                	add    %ecx,%edx
  1011dc:	0f b7 c0             	movzwl %ax,%eax
  1011df:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  1011e2:	eb 77                	jmp    10125b <cga_putc+0xfd>
    case '\n':
        crt_pos += CRT_COLS;
  1011e4:	0f b7 05 44 c4 11 00 	movzwl 0x11c444,%eax
  1011eb:	83 c0 50             	add    $0x50,%eax
  1011ee:	0f b7 c0             	movzwl %ax,%eax
  1011f1:	66 a3 44 c4 11 00    	mov    %ax,0x11c444
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  1011f7:	0f b7 1d 44 c4 11 00 	movzwl 0x11c444,%ebx
  1011fe:	0f b7 0d 44 c4 11 00 	movzwl 0x11c444,%ecx
  101205:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
  10120a:	89 c8                	mov    %ecx,%eax
  10120c:	f7 e2                	mul    %edx
  10120e:	c1 ea 06             	shr    $0x6,%edx
  101211:	89 d0                	mov    %edx,%eax
  101213:	c1 e0 02             	shl    $0x2,%eax
  101216:	01 d0                	add    %edx,%eax
  101218:	c1 e0 04             	shl    $0x4,%eax
  10121b:	29 c1                	sub    %eax,%ecx
  10121d:	89 ca                	mov    %ecx,%edx
  10121f:	0f b7 d2             	movzwl %dx,%edx
  101222:	89 d8                	mov    %ebx,%eax
  101224:	29 d0                	sub    %edx,%eax
  101226:	0f b7 c0             	movzwl %ax,%eax
  101229:	66 a3 44 c4 11 00    	mov    %ax,0x11c444
        break;
  10122f:	eb 2b                	jmp    10125c <cga_putc+0xfe>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  101231:	8b 0d 40 c4 11 00    	mov    0x11c440,%ecx
  101237:	0f b7 05 44 c4 11 00 	movzwl 0x11c444,%eax
  10123e:	8d 50 01             	lea    0x1(%eax),%edx
  101241:	0f b7 d2             	movzwl %dx,%edx
  101244:	66 89 15 44 c4 11 00 	mov    %dx,0x11c444
  10124b:	01 c0                	add    %eax,%eax
  10124d:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  101250:	8b 45 08             	mov    0x8(%ebp),%eax
  101253:	0f b7 c0             	movzwl %ax,%eax
  101256:	66 89 02             	mov    %ax,(%edx)
        break;
  101259:	eb 01                	jmp    10125c <cga_putc+0xfe>
        break;
  10125b:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  10125c:	0f b7 05 44 c4 11 00 	movzwl 0x11c444,%eax
  101263:	3d cf 07 00 00       	cmp    $0x7cf,%eax
  101268:	76 5e                	jbe    1012c8 <cga_putc+0x16a>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  10126a:	a1 40 c4 11 00       	mov    0x11c440,%eax
  10126f:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  101275:	a1 40 c4 11 00       	mov    0x11c440,%eax
  10127a:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  101281:	00 
  101282:	89 54 24 04          	mov    %edx,0x4(%esp)
  101286:	89 04 24             	mov    %eax,(%esp)
  101289:	e8 25 4d 00 00       	call   105fb3 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  10128e:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  101295:	eb 15                	jmp    1012ac <cga_putc+0x14e>
            crt_buf[i] = 0x0700 | ' ';
  101297:	8b 15 40 c4 11 00    	mov    0x11c440,%edx
  10129d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1012a0:	01 c0                	add    %eax,%eax
  1012a2:	01 d0                	add    %edx,%eax
  1012a4:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1012a9:	ff 45 f4             	incl   -0xc(%ebp)
  1012ac:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  1012b3:	7e e2                	jle    101297 <cga_putc+0x139>
        }
        crt_pos -= CRT_COLS;
  1012b5:	0f b7 05 44 c4 11 00 	movzwl 0x11c444,%eax
  1012bc:	83 e8 50             	sub    $0x50,%eax
  1012bf:	0f b7 c0             	movzwl %ax,%eax
  1012c2:	66 a3 44 c4 11 00    	mov    %ax,0x11c444
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  1012c8:	0f b7 05 46 c4 11 00 	movzwl 0x11c446,%eax
  1012cf:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  1012d3:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1012d7:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1012db:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1012df:	ee                   	out    %al,(%dx)
}
  1012e0:	90                   	nop
    outb(addr_6845 + 1, crt_pos >> 8);
  1012e1:	0f b7 05 44 c4 11 00 	movzwl 0x11c444,%eax
  1012e8:	c1 e8 08             	shr    $0x8,%eax
  1012eb:	0f b7 c0             	movzwl %ax,%eax
  1012ee:	0f b6 c0             	movzbl %al,%eax
  1012f1:	0f b7 15 46 c4 11 00 	movzwl 0x11c446,%edx
  1012f8:	42                   	inc    %edx
  1012f9:	0f b7 d2             	movzwl %dx,%edx
  1012fc:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  101300:	88 45 e9             	mov    %al,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101303:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101307:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10130b:	ee                   	out    %al,(%dx)
}
  10130c:	90                   	nop
    outb(addr_6845, 15);
  10130d:	0f b7 05 46 c4 11 00 	movzwl 0x11c446,%eax
  101314:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  101318:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10131c:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101320:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101324:	ee                   	out    %al,(%dx)
}
  101325:	90                   	nop
    outb(addr_6845 + 1, crt_pos);
  101326:	0f b7 05 44 c4 11 00 	movzwl 0x11c444,%eax
  10132d:	0f b6 c0             	movzbl %al,%eax
  101330:	0f b7 15 46 c4 11 00 	movzwl 0x11c446,%edx
  101337:	42                   	inc    %edx
  101338:	0f b7 d2             	movzwl %dx,%edx
  10133b:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  10133f:	88 45 f1             	mov    %al,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101342:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101346:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10134a:	ee                   	out    %al,(%dx)
}
  10134b:	90                   	nop
}
  10134c:	90                   	nop
  10134d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  101350:	89 ec                	mov    %ebp,%esp
  101352:	5d                   	pop    %ebp
  101353:	c3                   	ret    

00101354 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  101354:	55                   	push   %ebp
  101355:	89 e5                	mov    %esp,%ebp
  101357:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10135a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101361:	eb 08                	jmp    10136b <serial_putc_sub+0x17>
        delay();
  101363:	e8 16 fb ff ff       	call   100e7e <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101368:	ff 45 fc             	incl   -0x4(%ebp)
  10136b:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101371:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101375:	89 c2                	mov    %eax,%edx
  101377:	ec                   	in     (%dx),%al
  101378:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  10137b:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10137f:	0f b6 c0             	movzbl %al,%eax
  101382:	83 e0 20             	and    $0x20,%eax
  101385:	85 c0                	test   %eax,%eax
  101387:	75 09                	jne    101392 <serial_putc_sub+0x3e>
  101389:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101390:	7e d1                	jle    101363 <serial_putc_sub+0xf>
    }
    outb(COM1 + COM_TX, c);
  101392:	8b 45 08             	mov    0x8(%ebp),%eax
  101395:	0f b6 c0             	movzbl %al,%eax
  101398:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  10139e:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1013a1:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1013a5:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1013a9:	ee                   	out    %al,(%dx)
}
  1013aa:	90                   	nop
}
  1013ab:	90                   	nop
  1013ac:	89 ec                	mov    %ebp,%esp
  1013ae:	5d                   	pop    %ebp
  1013af:	c3                   	ret    

001013b0 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  1013b0:	55                   	push   %ebp
  1013b1:	89 e5                	mov    %esp,%ebp
  1013b3:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1013b6:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1013ba:	74 0d                	je     1013c9 <serial_putc+0x19>
        serial_putc_sub(c);
  1013bc:	8b 45 08             	mov    0x8(%ebp),%eax
  1013bf:	89 04 24             	mov    %eax,(%esp)
  1013c2:	e8 8d ff ff ff       	call   101354 <serial_putc_sub>
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  1013c7:	eb 24                	jmp    1013ed <serial_putc+0x3d>
        serial_putc_sub('\b');
  1013c9:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1013d0:	e8 7f ff ff ff       	call   101354 <serial_putc_sub>
        serial_putc_sub(' ');
  1013d5:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1013dc:	e8 73 ff ff ff       	call   101354 <serial_putc_sub>
        serial_putc_sub('\b');
  1013e1:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1013e8:	e8 67 ff ff ff       	call   101354 <serial_putc_sub>
}
  1013ed:	90                   	nop
  1013ee:	89 ec                	mov    %ebp,%esp
  1013f0:	5d                   	pop    %ebp
  1013f1:	c3                   	ret    

001013f2 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  1013f2:	55                   	push   %ebp
  1013f3:	89 e5                	mov    %esp,%ebp
  1013f5:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  1013f8:	eb 33                	jmp    10142d <cons_intr+0x3b>
        if (c != 0) {
  1013fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1013fe:	74 2d                	je     10142d <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  101400:	a1 64 c6 11 00       	mov    0x11c664,%eax
  101405:	8d 50 01             	lea    0x1(%eax),%edx
  101408:	89 15 64 c6 11 00    	mov    %edx,0x11c664
  10140e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101411:	88 90 60 c4 11 00    	mov    %dl,0x11c460(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  101417:	a1 64 c6 11 00       	mov    0x11c664,%eax
  10141c:	3d 00 02 00 00       	cmp    $0x200,%eax
  101421:	75 0a                	jne    10142d <cons_intr+0x3b>
                cons.wpos = 0;
  101423:	c7 05 64 c6 11 00 00 	movl   $0x0,0x11c664
  10142a:	00 00 00 
    while ((c = (*proc)()) != -1) {
  10142d:	8b 45 08             	mov    0x8(%ebp),%eax
  101430:	ff d0                	call   *%eax
  101432:	89 45 f4             	mov    %eax,-0xc(%ebp)
  101435:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  101439:	75 bf                	jne    1013fa <cons_intr+0x8>
            }
        }
    }
}
  10143b:	90                   	nop
  10143c:	90                   	nop
  10143d:	89 ec                	mov    %ebp,%esp
  10143f:	5d                   	pop    %ebp
  101440:	c3                   	ret    

00101441 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  101441:	55                   	push   %ebp
  101442:	89 e5                	mov    %esp,%ebp
  101444:	83 ec 10             	sub    $0x10,%esp
  101447:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10144d:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101451:	89 c2                	mov    %eax,%edx
  101453:	ec                   	in     (%dx),%al
  101454:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101457:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  10145b:	0f b6 c0             	movzbl %al,%eax
  10145e:	83 e0 01             	and    $0x1,%eax
  101461:	85 c0                	test   %eax,%eax
  101463:	75 07                	jne    10146c <serial_proc_data+0x2b>
        return -1;
  101465:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10146a:	eb 2a                	jmp    101496 <serial_proc_data+0x55>
  10146c:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101472:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  101476:	89 c2                	mov    %eax,%edx
  101478:	ec                   	in     (%dx),%al
  101479:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  10147c:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  101480:	0f b6 c0             	movzbl %al,%eax
  101483:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  101486:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  10148a:	75 07                	jne    101493 <serial_proc_data+0x52>
        c = '\b';
  10148c:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  101493:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  101496:	89 ec                	mov    %ebp,%esp
  101498:	5d                   	pop    %ebp
  101499:	c3                   	ret    

0010149a <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  10149a:	55                   	push   %ebp
  10149b:	89 e5                	mov    %esp,%ebp
  10149d:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  1014a0:	a1 48 c4 11 00       	mov    0x11c448,%eax
  1014a5:	85 c0                	test   %eax,%eax
  1014a7:	74 0c                	je     1014b5 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  1014a9:	c7 04 24 41 14 10 00 	movl   $0x101441,(%esp)
  1014b0:	e8 3d ff ff ff       	call   1013f2 <cons_intr>
    }
}
  1014b5:	90                   	nop
  1014b6:	89 ec                	mov    %ebp,%esp
  1014b8:	5d                   	pop    %ebp
  1014b9:	c3                   	ret    

001014ba <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  1014ba:	55                   	push   %ebp
  1014bb:	89 e5                	mov    %esp,%ebp
  1014bd:	83 ec 38             	sub    $0x38,%esp
  1014c0:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1014c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1014c9:	89 c2                	mov    %eax,%edx
  1014cb:	ec                   	in     (%dx),%al
  1014cc:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  1014cf:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  1014d3:	0f b6 c0             	movzbl %al,%eax
  1014d6:	83 e0 01             	and    $0x1,%eax
  1014d9:	85 c0                	test   %eax,%eax
  1014db:	75 0a                	jne    1014e7 <kbd_proc_data+0x2d>
        return -1;
  1014dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1014e2:	e9 56 01 00 00       	jmp    10163d <kbd_proc_data+0x183>
  1014e7:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1014ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1014f0:	89 c2                	mov    %eax,%edx
  1014f2:	ec                   	in     (%dx),%al
  1014f3:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  1014f6:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  1014fa:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  1014fd:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  101501:	75 17                	jne    10151a <kbd_proc_data+0x60>
        // E0 escape character
        shift |= E0ESC;
  101503:	a1 68 c6 11 00       	mov    0x11c668,%eax
  101508:	83 c8 40             	or     $0x40,%eax
  10150b:	a3 68 c6 11 00       	mov    %eax,0x11c668
        return 0;
  101510:	b8 00 00 00 00       	mov    $0x0,%eax
  101515:	e9 23 01 00 00       	jmp    10163d <kbd_proc_data+0x183>
    } else if (data & 0x80) {
  10151a:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10151e:	84 c0                	test   %al,%al
  101520:	79 45                	jns    101567 <kbd_proc_data+0xad>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101522:	a1 68 c6 11 00       	mov    0x11c668,%eax
  101527:	83 e0 40             	and    $0x40,%eax
  10152a:	85 c0                	test   %eax,%eax
  10152c:	75 08                	jne    101536 <kbd_proc_data+0x7c>
  10152e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101532:	24 7f                	and    $0x7f,%al
  101534:	eb 04                	jmp    10153a <kbd_proc_data+0x80>
  101536:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10153a:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  10153d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101541:	0f b6 80 40 90 11 00 	movzbl 0x119040(%eax),%eax
  101548:	0c 40                	or     $0x40,%al
  10154a:	0f b6 c0             	movzbl %al,%eax
  10154d:	f7 d0                	not    %eax
  10154f:	89 c2                	mov    %eax,%edx
  101551:	a1 68 c6 11 00       	mov    0x11c668,%eax
  101556:	21 d0                	and    %edx,%eax
  101558:	a3 68 c6 11 00       	mov    %eax,0x11c668
        return 0;
  10155d:	b8 00 00 00 00       	mov    $0x0,%eax
  101562:	e9 d6 00 00 00       	jmp    10163d <kbd_proc_data+0x183>
    } else if (shift & E0ESC) {
  101567:	a1 68 c6 11 00       	mov    0x11c668,%eax
  10156c:	83 e0 40             	and    $0x40,%eax
  10156f:	85 c0                	test   %eax,%eax
  101571:	74 11                	je     101584 <kbd_proc_data+0xca>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  101573:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  101577:	a1 68 c6 11 00       	mov    0x11c668,%eax
  10157c:	83 e0 bf             	and    $0xffffffbf,%eax
  10157f:	a3 68 c6 11 00       	mov    %eax,0x11c668
    }

    shift |= shiftcode[data];
  101584:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101588:	0f b6 80 40 90 11 00 	movzbl 0x119040(%eax),%eax
  10158f:	0f b6 d0             	movzbl %al,%edx
  101592:	a1 68 c6 11 00       	mov    0x11c668,%eax
  101597:	09 d0                	or     %edx,%eax
  101599:	a3 68 c6 11 00       	mov    %eax,0x11c668
    shift ^= togglecode[data];
  10159e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1015a2:	0f b6 80 40 91 11 00 	movzbl 0x119140(%eax),%eax
  1015a9:	0f b6 d0             	movzbl %al,%edx
  1015ac:	a1 68 c6 11 00       	mov    0x11c668,%eax
  1015b1:	31 d0                	xor    %edx,%eax
  1015b3:	a3 68 c6 11 00       	mov    %eax,0x11c668

    c = charcode[shift & (CTL | SHIFT)][data];
  1015b8:	a1 68 c6 11 00       	mov    0x11c668,%eax
  1015bd:	83 e0 03             	and    $0x3,%eax
  1015c0:	8b 14 85 40 95 11 00 	mov    0x119540(,%eax,4),%edx
  1015c7:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1015cb:	01 d0                	add    %edx,%eax
  1015cd:	0f b6 00             	movzbl (%eax),%eax
  1015d0:	0f b6 c0             	movzbl %al,%eax
  1015d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  1015d6:	a1 68 c6 11 00       	mov    0x11c668,%eax
  1015db:	83 e0 08             	and    $0x8,%eax
  1015de:	85 c0                	test   %eax,%eax
  1015e0:	74 22                	je     101604 <kbd_proc_data+0x14a>
        if ('a' <= c && c <= 'z')
  1015e2:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  1015e6:	7e 0c                	jle    1015f4 <kbd_proc_data+0x13a>
  1015e8:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  1015ec:	7f 06                	jg     1015f4 <kbd_proc_data+0x13a>
            c += 'A' - 'a';
  1015ee:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  1015f2:	eb 10                	jmp    101604 <kbd_proc_data+0x14a>
        else if ('A' <= c && c <= 'Z')
  1015f4:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  1015f8:	7e 0a                	jle    101604 <kbd_proc_data+0x14a>
  1015fa:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  1015fe:	7f 04                	jg     101604 <kbd_proc_data+0x14a>
            c += 'a' - 'A';
  101600:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  101604:	a1 68 c6 11 00       	mov    0x11c668,%eax
  101609:	f7 d0                	not    %eax
  10160b:	83 e0 06             	and    $0x6,%eax
  10160e:	85 c0                	test   %eax,%eax
  101610:	75 28                	jne    10163a <kbd_proc_data+0x180>
  101612:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  101619:	75 1f                	jne    10163a <kbd_proc_data+0x180>
        cprintf("Rebooting!\n");
  10161b:	c7 04 24 33 64 10 00 	movl   $0x106433,(%esp)
  101622:	e8 3a ed ff ff       	call   100361 <cprintf>
  101627:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  10162d:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101631:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  101635:	8b 55 e8             	mov    -0x18(%ebp),%edx
  101638:	ee                   	out    %al,(%dx)
}
  101639:	90                   	nop
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  10163a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10163d:	89 ec                	mov    %ebp,%esp
  10163f:	5d                   	pop    %ebp
  101640:	c3                   	ret    

00101641 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  101641:	55                   	push   %ebp
  101642:	89 e5                	mov    %esp,%ebp
  101644:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  101647:	c7 04 24 ba 14 10 00 	movl   $0x1014ba,(%esp)
  10164e:	e8 9f fd ff ff       	call   1013f2 <cons_intr>
}
  101653:	90                   	nop
  101654:	89 ec                	mov    %ebp,%esp
  101656:	5d                   	pop    %ebp
  101657:	c3                   	ret    

00101658 <kbd_init>:

static void
kbd_init(void) {
  101658:	55                   	push   %ebp
  101659:	89 e5                	mov    %esp,%ebp
  10165b:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  10165e:	e8 de ff ff ff       	call   101641 <kbd_intr>
    pic_enable(IRQ_KBD);
  101663:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10166a:	e8 51 01 00 00       	call   1017c0 <pic_enable>
}
  10166f:	90                   	nop
  101670:	89 ec                	mov    %ebp,%esp
  101672:	5d                   	pop    %ebp
  101673:	c3                   	ret    

00101674 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  101674:	55                   	push   %ebp
  101675:	89 e5                	mov    %esp,%ebp
  101677:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  10167a:	e8 4a f8 ff ff       	call   100ec9 <cga_init>
    serial_init();
  10167f:	e8 2d f9 ff ff       	call   100fb1 <serial_init>
    kbd_init();
  101684:	e8 cf ff ff ff       	call   101658 <kbd_init>
    if (!serial_exists) {
  101689:	a1 48 c4 11 00       	mov    0x11c448,%eax
  10168e:	85 c0                	test   %eax,%eax
  101690:	75 0c                	jne    10169e <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  101692:	c7 04 24 3f 64 10 00 	movl   $0x10643f,(%esp)
  101699:	e8 c3 ec ff ff       	call   100361 <cprintf>
    }
}
  10169e:	90                   	nop
  10169f:	89 ec                	mov    %ebp,%esp
  1016a1:	5d                   	pop    %ebp
  1016a2:	c3                   	ret    

001016a3 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  1016a3:	55                   	push   %ebp
  1016a4:	89 e5                	mov    %esp,%ebp
  1016a6:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  1016a9:	e8 8e f7 ff ff       	call   100e3c <__intr_save>
  1016ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
  1016b1:	8b 45 08             	mov    0x8(%ebp),%eax
  1016b4:	89 04 24             	mov    %eax,(%esp)
  1016b7:	e8 60 fa ff ff       	call   10111c <lpt_putc>
        cga_putc(c);
  1016bc:	8b 45 08             	mov    0x8(%ebp),%eax
  1016bf:	89 04 24             	mov    %eax,(%esp)
  1016c2:	e8 97 fa ff ff       	call   10115e <cga_putc>
        serial_putc(c);
  1016c7:	8b 45 08             	mov    0x8(%ebp),%eax
  1016ca:	89 04 24             	mov    %eax,(%esp)
  1016cd:	e8 de fc ff ff       	call   1013b0 <serial_putc>
    }
    local_intr_restore(intr_flag);
  1016d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1016d5:	89 04 24             	mov    %eax,(%esp)
  1016d8:	e8 8b f7 ff ff       	call   100e68 <__intr_restore>
}
  1016dd:	90                   	nop
  1016de:	89 ec                	mov    %ebp,%esp
  1016e0:	5d                   	pop    %ebp
  1016e1:	c3                   	ret    

001016e2 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  1016e2:	55                   	push   %ebp
  1016e3:	89 e5                	mov    %esp,%ebp
  1016e5:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
  1016e8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  1016ef:	e8 48 f7 ff ff       	call   100e3c <__intr_save>
  1016f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
  1016f7:	e8 9e fd ff ff       	call   10149a <serial_intr>
        kbd_intr();
  1016fc:	e8 40 ff ff ff       	call   101641 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
  101701:	8b 15 60 c6 11 00    	mov    0x11c660,%edx
  101707:	a1 64 c6 11 00       	mov    0x11c664,%eax
  10170c:	39 c2                	cmp    %eax,%edx
  10170e:	74 31                	je     101741 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
  101710:	a1 60 c6 11 00       	mov    0x11c660,%eax
  101715:	8d 50 01             	lea    0x1(%eax),%edx
  101718:	89 15 60 c6 11 00    	mov    %edx,0x11c660
  10171e:	0f b6 80 60 c4 11 00 	movzbl 0x11c460(%eax),%eax
  101725:	0f b6 c0             	movzbl %al,%eax
  101728:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
  10172b:	a1 60 c6 11 00       	mov    0x11c660,%eax
  101730:	3d 00 02 00 00       	cmp    $0x200,%eax
  101735:	75 0a                	jne    101741 <cons_getc+0x5f>
                cons.rpos = 0;
  101737:	c7 05 60 c6 11 00 00 	movl   $0x0,0x11c660
  10173e:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
  101741:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101744:	89 04 24             	mov    %eax,(%esp)
  101747:	e8 1c f7 ff ff       	call   100e68 <__intr_restore>
    return c;
  10174c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10174f:	89 ec                	mov    %ebp,%esp
  101751:	5d                   	pop    %ebp
  101752:	c3                   	ret    

00101753 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  101753:	55                   	push   %ebp
  101754:	89 e5                	mov    %esp,%ebp
    asm volatile ("sti");
  101756:	fb                   	sti    
}
  101757:	90                   	nop
    sti();
}
  101758:	90                   	nop
  101759:	5d                   	pop    %ebp
  10175a:	c3                   	ret    

0010175b <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  10175b:	55                   	push   %ebp
  10175c:	89 e5                	mov    %esp,%ebp
    asm volatile ("cli" ::: "memory");
  10175e:	fa                   	cli    
}
  10175f:	90                   	nop
    cli();
}
  101760:	90                   	nop
  101761:	5d                   	pop    %ebp
  101762:	c3                   	ret    

00101763 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  101763:	55                   	push   %ebp
  101764:	89 e5                	mov    %esp,%ebp
  101766:	83 ec 14             	sub    $0x14,%esp
  101769:	8b 45 08             	mov    0x8(%ebp),%eax
  10176c:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  101770:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101773:	66 a3 50 95 11 00    	mov    %ax,0x119550
    if (did_init) {
  101779:	a1 6c c6 11 00       	mov    0x11c66c,%eax
  10177e:	85 c0                	test   %eax,%eax
  101780:	74 39                	je     1017bb <pic_setmask+0x58>
        outb(IO_PIC1 + 1, mask);
  101782:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101785:	0f b6 c0             	movzbl %al,%eax
  101788:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
  10178e:	88 45 f9             	mov    %al,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101791:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101795:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101799:	ee                   	out    %al,(%dx)
}
  10179a:	90                   	nop
        outb(IO_PIC2 + 1, mask >> 8);
  10179b:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10179f:	c1 e8 08             	shr    $0x8,%eax
  1017a2:	0f b7 c0             	movzwl %ax,%eax
  1017a5:	0f b6 c0             	movzbl %al,%eax
  1017a8:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
  1017ae:	88 45 fd             	mov    %al,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1017b1:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1017b5:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1017b9:	ee                   	out    %al,(%dx)
}
  1017ba:	90                   	nop
    }
}
  1017bb:	90                   	nop
  1017bc:	89 ec                	mov    %ebp,%esp
  1017be:	5d                   	pop    %ebp
  1017bf:	c3                   	ret    

001017c0 <pic_enable>:

void
pic_enable(unsigned int irq) {
  1017c0:	55                   	push   %ebp
  1017c1:	89 e5                	mov    %esp,%ebp
  1017c3:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  1017c6:	8b 45 08             	mov    0x8(%ebp),%eax
  1017c9:	ba 01 00 00 00       	mov    $0x1,%edx
  1017ce:	88 c1                	mov    %al,%cl
  1017d0:	d3 e2                	shl    %cl,%edx
  1017d2:	89 d0                	mov    %edx,%eax
  1017d4:	98                   	cwtl   
  1017d5:	f7 d0                	not    %eax
  1017d7:	0f bf d0             	movswl %ax,%edx
  1017da:	0f b7 05 50 95 11 00 	movzwl 0x119550,%eax
  1017e1:	98                   	cwtl   
  1017e2:	21 d0                	and    %edx,%eax
  1017e4:	98                   	cwtl   
  1017e5:	0f b7 c0             	movzwl %ax,%eax
  1017e8:	89 04 24             	mov    %eax,(%esp)
  1017eb:	e8 73 ff ff ff       	call   101763 <pic_setmask>
}
  1017f0:	90                   	nop
  1017f1:	89 ec                	mov    %ebp,%esp
  1017f3:	5d                   	pop    %ebp
  1017f4:	c3                   	ret    

001017f5 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  1017f5:	55                   	push   %ebp
  1017f6:	89 e5                	mov    %esp,%ebp
  1017f8:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  1017fb:	c7 05 6c c6 11 00 01 	movl   $0x1,0x11c66c
  101802:	00 00 00 
  101805:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
  10180b:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10180f:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  101813:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  101817:	ee                   	out    %al,(%dx)
}
  101818:	90                   	nop
  101819:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
  10181f:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101823:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  101827:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  10182b:	ee                   	out    %al,(%dx)
}
  10182c:	90                   	nop
  10182d:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  101833:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101837:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  10183b:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  10183f:	ee                   	out    %al,(%dx)
}
  101840:	90                   	nop
  101841:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
  101847:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10184b:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  10184f:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  101853:	ee                   	out    %al,(%dx)
}
  101854:	90                   	nop
  101855:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
  10185b:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10185f:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101863:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101867:	ee                   	out    %al,(%dx)
}
  101868:	90                   	nop
  101869:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
  10186f:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101873:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  101877:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  10187b:	ee                   	out    %al,(%dx)
}
  10187c:	90                   	nop
  10187d:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
  101883:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101887:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  10188b:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  10188f:	ee                   	out    %al,(%dx)
}
  101890:	90                   	nop
  101891:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
  101897:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10189b:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10189f:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1018a3:	ee                   	out    %al,(%dx)
}
  1018a4:	90                   	nop
  1018a5:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
  1018ab:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1018af:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1018b3:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1018b7:	ee                   	out    %al,(%dx)
}
  1018b8:	90                   	nop
  1018b9:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  1018bf:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1018c3:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1018c7:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1018cb:	ee                   	out    %al,(%dx)
}
  1018cc:	90                   	nop
  1018cd:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
  1018d3:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1018d7:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1018db:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1018df:	ee                   	out    %al,(%dx)
}
  1018e0:	90                   	nop
  1018e1:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  1018e7:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1018eb:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1018ef:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1018f3:	ee                   	out    %al,(%dx)
}
  1018f4:	90                   	nop
  1018f5:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
  1018fb:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1018ff:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101903:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101907:	ee                   	out    %al,(%dx)
}
  101908:	90                   	nop
  101909:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
  10190f:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101913:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101917:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  10191b:	ee                   	out    %al,(%dx)
}
  10191c:	90                   	nop
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  10191d:	0f b7 05 50 95 11 00 	movzwl 0x119550,%eax
  101924:	3d ff ff 00 00       	cmp    $0xffff,%eax
  101929:	74 0f                	je     10193a <pic_init+0x145>
        pic_setmask(irq_mask);
  10192b:	0f b7 05 50 95 11 00 	movzwl 0x119550,%eax
  101932:	89 04 24             	mov    %eax,(%esp)
  101935:	e8 29 fe ff ff       	call   101763 <pic_setmask>
    }
}
  10193a:	90                   	nop
  10193b:	89 ec                	mov    %ebp,%esp
  10193d:	5d                   	pop    %ebp
  10193e:	c3                   	ret    

0010193f <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  10193f:	55                   	push   %ebp
  101940:	89 e5                	mov    %esp,%ebp
  101942:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  101945:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  10194c:	00 
  10194d:	c7 04 24 60 64 10 00 	movl   $0x106460,(%esp)
  101954:	e8 08 ea ff ff       	call   100361 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
  101959:	c7 04 24 6a 64 10 00 	movl   $0x10646a,(%esp)
  101960:	e8 fc e9 ff ff       	call   100361 <cprintf>
    panic("EOT: kernel seems ok.");
  101965:	c7 44 24 08 78 64 10 	movl   $0x106478,0x8(%esp)
  10196c:	00 
  10196d:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
  101974:	00 
  101975:	c7 04 24 8e 64 10 00 	movl   $0x10648e,(%esp)
  10197c:	e8 81 f3 ff ff       	call   100d02 <__panic>

00101981 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  101981:	55                   	push   %ebp
  101982:	89 e5                	mov    %esp,%ebp
  101984:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
     extern uintptr_t __vectors[];
     int i;
     for(i = 0; i < 256; i++){
  101987:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10198e:	e9 c1 00 00 00       	jmp    101a54 <idt_init+0xd3>
        SETGATE(idt[i], 1, GD_KTEXT, __vectors[i], DPL_KERNEL);
  101993:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101996:	8b 04 85 e0 95 11 00 	mov    0x1195e0(,%eax,4),%eax
  10199d:	0f b7 d0             	movzwl %ax,%edx
  1019a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019a3:	66 89 14 c5 80 c6 11 	mov    %dx,0x11c680(,%eax,8)
  1019aa:	00 
  1019ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019ae:	66 c7 04 c5 82 c6 11 	movw   $0x8,0x11c682(,%eax,8)
  1019b5:	00 08 00 
  1019b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019bb:	0f b6 14 c5 84 c6 11 	movzbl 0x11c684(,%eax,8),%edx
  1019c2:	00 
  1019c3:	80 e2 e0             	and    $0xe0,%dl
  1019c6:	88 14 c5 84 c6 11 00 	mov    %dl,0x11c684(,%eax,8)
  1019cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019d0:	0f b6 14 c5 84 c6 11 	movzbl 0x11c684(,%eax,8),%edx
  1019d7:	00 
  1019d8:	80 e2 1f             	and    $0x1f,%dl
  1019db:	88 14 c5 84 c6 11 00 	mov    %dl,0x11c684(,%eax,8)
  1019e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019e5:	0f b6 14 c5 85 c6 11 	movzbl 0x11c685(,%eax,8),%edx
  1019ec:	00 
  1019ed:	80 ca 0f             	or     $0xf,%dl
  1019f0:	88 14 c5 85 c6 11 00 	mov    %dl,0x11c685(,%eax,8)
  1019f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019fa:	0f b6 14 c5 85 c6 11 	movzbl 0x11c685(,%eax,8),%edx
  101a01:	00 
  101a02:	80 e2 ef             	and    $0xef,%dl
  101a05:	88 14 c5 85 c6 11 00 	mov    %dl,0x11c685(,%eax,8)
  101a0c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a0f:	0f b6 14 c5 85 c6 11 	movzbl 0x11c685(,%eax,8),%edx
  101a16:	00 
  101a17:	80 e2 9f             	and    $0x9f,%dl
  101a1a:	88 14 c5 85 c6 11 00 	mov    %dl,0x11c685(,%eax,8)
  101a21:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a24:	0f b6 14 c5 85 c6 11 	movzbl 0x11c685(,%eax,8),%edx
  101a2b:	00 
  101a2c:	80 ca 80             	or     $0x80,%dl
  101a2f:	88 14 c5 85 c6 11 00 	mov    %dl,0x11c685(,%eax,8)
  101a36:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a39:	8b 04 85 e0 95 11 00 	mov    0x1195e0(,%eax,4),%eax
  101a40:	c1 e8 10             	shr    $0x10,%eax
  101a43:	0f b7 d0             	movzwl %ax,%edx
  101a46:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a49:	66 89 14 c5 86 c6 11 	mov    %dx,0x11c686(,%eax,8)
  101a50:	00 
     for(i = 0; i < 256; i++){
  101a51:	ff 45 fc             	incl   -0x4(%ebp)
  101a54:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
  101a5b:	0f 8e 32 ff ff ff    	jle    101993 <idt_init+0x12>
     }
     SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
  101a61:	a1 c4 97 11 00       	mov    0x1197c4,%eax
  101a66:	0f b7 c0             	movzwl %ax,%eax
  101a69:	66 a3 48 ca 11 00    	mov    %ax,0x11ca48
  101a6f:	66 c7 05 4a ca 11 00 	movw   $0x8,0x11ca4a
  101a76:	08 00 
  101a78:	0f b6 05 4c ca 11 00 	movzbl 0x11ca4c,%eax
  101a7f:	24 e0                	and    $0xe0,%al
  101a81:	a2 4c ca 11 00       	mov    %al,0x11ca4c
  101a86:	0f b6 05 4c ca 11 00 	movzbl 0x11ca4c,%eax
  101a8d:	24 1f                	and    $0x1f,%al
  101a8f:	a2 4c ca 11 00       	mov    %al,0x11ca4c
  101a94:	0f b6 05 4d ca 11 00 	movzbl 0x11ca4d,%eax
  101a9b:	24 f0                	and    $0xf0,%al
  101a9d:	0c 0e                	or     $0xe,%al
  101a9f:	a2 4d ca 11 00       	mov    %al,0x11ca4d
  101aa4:	0f b6 05 4d ca 11 00 	movzbl 0x11ca4d,%eax
  101aab:	24 ef                	and    $0xef,%al
  101aad:	a2 4d ca 11 00       	mov    %al,0x11ca4d
  101ab2:	0f b6 05 4d ca 11 00 	movzbl 0x11ca4d,%eax
  101ab9:	0c 60                	or     $0x60,%al
  101abb:	a2 4d ca 11 00       	mov    %al,0x11ca4d
  101ac0:	0f b6 05 4d ca 11 00 	movzbl 0x11ca4d,%eax
  101ac7:	0c 80                	or     $0x80,%al
  101ac9:	a2 4d ca 11 00       	mov    %al,0x11ca4d
  101ace:	a1 c4 97 11 00       	mov    0x1197c4,%eax
  101ad3:	c1 e8 10             	shr    $0x10,%eax
  101ad6:	0f b7 c0             	movzwl %ax,%eax
  101ad9:	66 a3 4e ca 11 00    	mov    %ax,0x11ca4e
  101adf:	c7 45 f8 60 95 11 00 	movl   $0x119560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
  101ae6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101ae9:	0f 01 18             	lidtl  (%eax)
}
  101aec:	90                   	nop
     //SETGATE(idt[T_SWITCH_TOU], 0, GD_KTEXT, __vectors[T_SWITCH_TOU], DPL_KERNEL);
     lidt(&idt_pd);
}
  101aed:	90                   	nop
  101aee:	89 ec                	mov    %ebp,%esp
  101af0:	5d                   	pop    %ebp
  101af1:	c3                   	ret    

00101af2 <trapname>:

static const char *
trapname(int trapno) {
  101af2:	55                   	push   %ebp
  101af3:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101af5:	8b 45 08             	mov    0x8(%ebp),%eax
  101af8:	83 f8 13             	cmp    $0x13,%eax
  101afb:	77 0c                	ja     101b09 <trapname+0x17>
        return excnames[trapno];
  101afd:	8b 45 08             	mov    0x8(%ebp),%eax
  101b00:	8b 04 85 e0 67 10 00 	mov    0x1067e0(,%eax,4),%eax
  101b07:	eb 18                	jmp    101b21 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101b09:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101b0d:	7e 0d                	jle    101b1c <trapname+0x2a>
  101b0f:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101b13:	7f 07                	jg     101b1c <trapname+0x2a>
        return "Hardware Interrupt";
  101b15:	b8 9f 64 10 00       	mov    $0x10649f,%eax
  101b1a:	eb 05                	jmp    101b21 <trapname+0x2f>
    }
    return "(unknown trap)";
  101b1c:	b8 b2 64 10 00       	mov    $0x1064b2,%eax
}
  101b21:	5d                   	pop    %ebp
  101b22:	c3                   	ret    

00101b23 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101b23:	55                   	push   %ebp
  101b24:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101b26:	8b 45 08             	mov    0x8(%ebp),%eax
  101b29:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b2d:	83 f8 08             	cmp    $0x8,%eax
  101b30:	0f 94 c0             	sete   %al
  101b33:	0f b6 c0             	movzbl %al,%eax
}
  101b36:	5d                   	pop    %ebp
  101b37:	c3                   	ret    

00101b38 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101b38:	55                   	push   %ebp
  101b39:	89 e5                	mov    %esp,%ebp
  101b3b:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  101b41:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b45:	c7 04 24 f3 64 10 00 	movl   $0x1064f3,(%esp)
  101b4c:	e8 10 e8 ff ff       	call   100361 <cprintf>
    print_regs(&tf->tf_regs);
  101b51:	8b 45 08             	mov    0x8(%ebp),%eax
  101b54:	89 04 24             	mov    %eax,(%esp)
  101b57:	e8 8f 01 00 00       	call   101ceb <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  101b5f:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101b63:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b67:	c7 04 24 04 65 10 00 	movl   $0x106504,(%esp)
  101b6e:	e8 ee e7 ff ff       	call   100361 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101b73:	8b 45 08             	mov    0x8(%ebp),%eax
  101b76:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101b7a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b7e:	c7 04 24 17 65 10 00 	movl   $0x106517,(%esp)
  101b85:	e8 d7 e7 ff ff       	call   100361 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  101b8d:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101b91:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b95:	c7 04 24 2a 65 10 00 	movl   $0x10652a,(%esp)
  101b9c:	e8 c0 e7 ff ff       	call   100361 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  101ba4:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101ba8:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bac:	c7 04 24 3d 65 10 00 	movl   $0x10653d,(%esp)
  101bb3:	e8 a9 e7 ff ff       	call   100361 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  101bbb:	8b 40 30             	mov    0x30(%eax),%eax
  101bbe:	89 04 24             	mov    %eax,(%esp)
  101bc1:	e8 2c ff ff ff       	call   101af2 <trapname>
  101bc6:	8b 55 08             	mov    0x8(%ebp),%edx
  101bc9:	8b 52 30             	mov    0x30(%edx),%edx
  101bcc:	89 44 24 08          	mov    %eax,0x8(%esp)
  101bd0:	89 54 24 04          	mov    %edx,0x4(%esp)
  101bd4:	c7 04 24 50 65 10 00 	movl   $0x106550,(%esp)
  101bdb:	e8 81 e7 ff ff       	call   100361 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101be0:	8b 45 08             	mov    0x8(%ebp),%eax
  101be3:	8b 40 34             	mov    0x34(%eax),%eax
  101be6:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bea:	c7 04 24 62 65 10 00 	movl   $0x106562,(%esp)
  101bf1:	e8 6b e7 ff ff       	call   100361 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  101bf9:	8b 40 38             	mov    0x38(%eax),%eax
  101bfc:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c00:	c7 04 24 71 65 10 00 	movl   $0x106571,(%esp)
  101c07:	e8 55 e7 ff ff       	call   100361 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101c0c:	8b 45 08             	mov    0x8(%ebp),%eax
  101c0f:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101c13:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c17:	c7 04 24 80 65 10 00 	movl   $0x106580,(%esp)
  101c1e:	e8 3e e7 ff ff       	call   100361 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101c23:	8b 45 08             	mov    0x8(%ebp),%eax
  101c26:	8b 40 40             	mov    0x40(%eax),%eax
  101c29:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c2d:	c7 04 24 93 65 10 00 	movl   $0x106593,(%esp)
  101c34:	e8 28 e7 ff ff       	call   100361 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101c39:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101c40:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101c47:	eb 3d                	jmp    101c86 <print_trapframe+0x14e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101c49:	8b 45 08             	mov    0x8(%ebp),%eax
  101c4c:	8b 50 40             	mov    0x40(%eax),%edx
  101c4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101c52:	21 d0                	and    %edx,%eax
  101c54:	85 c0                	test   %eax,%eax
  101c56:	74 28                	je     101c80 <print_trapframe+0x148>
  101c58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c5b:	8b 04 85 80 95 11 00 	mov    0x119580(,%eax,4),%eax
  101c62:	85 c0                	test   %eax,%eax
  101c64:	74 1a                	je     101c80 <print_trapframe+0x148>
            cprintf("%s,", IA32flags[i]);
  101c66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c69:	8b 04 85 80 95 11 00 	mov    0x119580(,%eax,4),%eax
  101c70:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c74:	c7 04 24 a2 65 10 00 	movl   $0x1065a2,(%esp)
  101c7b:	e8 e1 e6 ff ff       	call   100361 <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101c80:	ff 45 f4             	incl   -0xc(%ebp)
  101c83:	d1 65 f0             	shll   -0x10(%ebp)
  101c86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c89:	83 f8 17             	cmp    $0x17,%eax
  101c8c:	76 bb                	jbe    101c49 <print_trapframe+0x111>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  101c91:	8b 40 40             	mov    0x40(%eax),%eax
  101c94:	c1 e8 0c             	shr    $0xc,%eax
  101c97:	83 e0 03             	and    $0x3,%eax
  101c9a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c9e:	c7 04 24 a6 65 10 00 	movl   $0x1065a6,(%esp)
  101ca5:	e8 b7 e6 ff ff       	call   100361 <cprintf>

    if (!trap_in_kernel(tf)) {
  101caa:	8b 45 08             	mov    0x8(%ebp),%eax
  101cad:	89 04 24             	mov    %eax,(%esp)
  101cb0:	e8 6e fe ff ff       	call   101b23 <trap_in_kernel>
  101cb5:	85 c0                	test   %eax,%eax
  101cb7:	75 2d                	jne    101ce6 <print_trapframe+0x1ae>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  101cbc:	8b 40 44             	mov    0x44(%eax),%eax
  101cbf:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cc3:	c7 04 24 af 65 10 00 	movl   $0x1065af,(%esp)
  101cca:	e8 92 e6 ff ff       	call   100361 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  101cd2:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101cd6:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cda:	c7 04 24 be 65 10 00 	movl   $0x1065be,(%esp)
  101ce1:	e8 7b e6 ff ff       	call   100361 <cprintf>
    }
}
  101ce6:	90                   	nop
  101ce7:	89 ec                	mov    %ebp,%esp
  101ce9:	5d                   	pop    %ebp
  101cea:	c3                   	ret    

00101ceb <print_regs>:

void
print_regs(struct pushregs *regs) {
  101ceb:	55                   	push   %ebp
  101cec:	89 e5                	mov    %esp,%ebp
  101cee:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101cf1:	8b 45 08             	mov    0x8(%ebp),%eax
  101cf4:	8b 00                	mov    (%eax),%eax
  101cf6:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cfa:	c7 04 24 d1 65 10 00 	movl   $0x1065d1,(%esp)
  101d01:	e8 5b e6 ff ff       	call   100361 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101d06:	8b 45 08             	mov    0x8(%ebp),%eax
  101d09:	8b 40 04             	mov    0x4(%eax),%eax
  101d0c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d10:	c7 04 24 e0 65 10 00 	movl   $0x1065e0,(%esp)
  101d17:	e8 45 e6 ff ff       	call   100361 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101d1c:	8b 45 08             	mov    0x8(%ebp),%eax
  101d1f:	8b 40 08             	mov    0x8(%eax),%eax
  101d22:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d26:	c7 04 24 ef 65 10 00 	movl   $0x1065ef,(%esp)
  101d2d:	e8 2f e6 ff ff       	call   100361 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101d32:	8b 45 08             	mov    0x8(%ebp),%eax
  101d35:	8b 40 0c             	mov    0xc(%eax),%eax
  101d38:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d3c:	c7 04 24 fe 65 10 00 	movl   $0x1065fe,(%esp)
  101d43:	e8 19 e6 ff ff       	call   100361 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101d48:	8b 45 08             	mov    0x8(%ebp),%eax
  101d4b:	8b 40 10             	mov    0x10(%eax),%eax
  101d4e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d52:	c7 04 24 0d 66 10 00 	movl   $0x10660d,(%esp)
  101d59:	e8 03 e6 ff ff       	call   100361 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101d5e:	8b 45 08             	mov    0x8(%ebp),%eax
  101d61:	8b 40 14             	mov    0x14(%eax),%eax
  101d64:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d68:	c7 04 24 1c 66 10 00 	movl   $0x10661c,(%esp)
  101d6f:	e8 ed e5 ff ff       	call   100361 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101d74:	8b 45 08             	mov    0x8(%ebp),%eax
  101d77:	8b 40 18             	mov    0x18(%eax),%eax
  101d7a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d7e:	c7 04 24 2b 66 10 00 	movl   $0x10662b,(%esp)
  101d85:	e8 d7 e5 ff ff       	call   100361 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  101d8d:	8b 40 1c             	mov    0x1c(%eax),%eax
  101d90:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d94:	c7 04 24 3a 66 10 00 	movl   $0x10663a,(%esp)
  101d9b:	e8 c1 e5 ff ff       	call   100361 <cprintf>
}
  101da0:	90                   	nop
  101da1:	89 ec                	mov    %ebp,%esp
  101da3:	5d                   	pop    %ebp
  101da4:	c3                   	ret    

00101da5 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101da5:	55                   	push   %ebp
  101da6:	89 e5                	mov    %esp,%ebp
  101da8:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
  101dab:	8b 45 08             	mov    0x8(%ebp),%eax
  101dae:	8b 40 30             	mov    0x30(%eax),%eax
  101db1:	83 f8 79             	cmp    $0x79,%eax
  101db4:	0f 87 e6 00 00 00    	ja     101ea0 <trap_dispatch+0xfb>
  101dba:	83 f8 78             	cmp    $0x78,%eax
  101dbd:	0f 83 c1 00 00 00    	jae    101e84 <trap_dispatch+0xdf>
  101dc3:	83 f8 2f             	cmp    $0x2f,%eax
  101dc6:	0f 87 d4 00 00 00    	ja     101ea0 <trap_dispatch+0xfb>
  101dcc:	83 f8 2e             	cmp    $0x2e,%eax
  101dcf:	0f 83 00 01 00 00    	jae    101ed5 <trap_dispatch+0x130>
  101dd5:	83 f8 24             	cmp    $0x24,%eax
  101dd8:	74 5e                	je     101e38 <trap_dispatch+0x93>
  101dda:	83 f8 24             	cmp    $0x24,%eax
  101ddd:	0f 87 bd 00 00 00    	ja     101ea0 <trap_dispatch+0xfb>
  101de3:	83 f8 20             	cmp    $0x20,%eax
  101de6:	74 0a                	je     101df2 <trap_dispatch+0x4d>
  101de8:	83 f8 21             	cmp    $0x21,%eax
  101deb:	74 71                	je     101e5e <trap_dispatch+0xb9>
  101ded:	e9 ae 00 00 00       	jmp    101ea0 <trap_dispatch+0xfb>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks++;
  101df2:	a1 24 c4 11 00       	mov    0x11c424,%eax
  101df7:	40                   	inc    %eax
  101df8:	a3 24 c4 11 00       	mov    %eax,0x11c424
        if (ticks % TICK_NUM == 0){
  101dfd:	8b 0d 24 c4 11 00    	mov    0x11c424,%ecx
  101e03:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101e08:	89 c8                	mov    %ecx,%eax
  101e0a:	f7 e2                	mul    %edx
  101e0c:	c1 ea 05             	shr    $0x5,%edx
  101e0f:	89 d0                	mov    %edx,%eax
  101e11:	c1 e0 02             	shl    $0x2,%eax
  101e14:	01 d0                	add    %edx,%eax
  101e16:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  101e1d:	01 d0                	add    %edx,%eax
  101e1f:	c1 e0 02             	shl    $0x2,%eax
  101e22:	29 c1                	sub    %eax,%ecx
  101e24:	89 ca                	mov    %ecx,%edx
  101e26:	85 d2                	test   %edx,%edx
  101e28:	0f 85 aa 00 00 00    	jne    101ed8 <trap_dispatch+0x133>
            print_ticks();
  101e2e:	e8 0c fb ff ff       	call   10193f <print_ticks>
        }
        break;
  101e33:	e9 a0 00 00 00       	jmp    101ed8 <trap_dispatch+0x133>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101e38:	e8 a5 f8 ff ff       	call   1016e2 <cons_getc>
  101e3d:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101e40:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101e44:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101e48:	89 54 24 08          	mov    %edx,0x8(%esp)
  101e4c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e50:	c7 04 24 49 66 10 00 	movl   $0x106649,(%esp)
  101e57:	e8 05 e5 ff ff       	call   100361 <cprintf>
        break;
  101e5c:	eb 7b                	jmp    101ed9 <trap_dispatch+0x134>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101e5e:	e8 7f f8 ff ff       	call   1016e2 <cons_getc>
  101e63:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101e66:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101e6a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101e6e:	89 54 24 08          	mov    %edx,0x8(%esp)
  101e72:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e76:	c7 04 24 5b 66 10 00 	movl   $0x10665b,(%esp)
  101e7d:	e8 df e4 ff ff       	call   100361 <cprintf>
        break;
  101e82:	eb 55                	jmp    101ed9 <trap_dispatch+0x134>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101e84:	c7 44 24 08 6a 66 10 	movl   $0x10666a,0x8(%esp)
  101e8b:	00 
  101e8c:	c7 44 24 04 ae 00 00 	movl   $0xae,0x4(%esp)
  101e93:	00 
  101e94:	c7 04 24 8e 64 10 00 	movl   $0x10648e,(%esp)
  101e9b:	e8 62 ee ff ff       	call   100d02 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101ea0:	8b 45 08             	mov    0x8(%ebp),%eax
  101ea3:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101ea7:	83 e0 03             	and    $0x3,%eax
  101eaa:	85 c0                	test   %eax,%eax
  101eac:	75 2b                	jne    101ed9 <trap_dispatch+0x134>
            print_trapframe(tf);
  101eae:	8b 45 08             	mov    0x8(%ebp),%eax
  101eb1:	89 04 24             	mov    %eax,(%esp)
  101eb4:	e8 7f fc ff ff       	call   101b38 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101eb9:	c7 44 24 08 7a 66 10 	movl   $0x10667a,0x8(%esp)
  101ec0:	00 
  101ec1:	c7 44 24 04 b8 00 00 	movl   $0xb8,0x4(%esp)
  101ec8:	00 
  101ec9:	c7 04 24 8e 64 10 00 	movl   $0x10648e,(%esp)
  101ed0:	e8 2d ee ff ff       	call   100d02 <__panic>
        break;
  101ed5:	90                   	nop
  101ed6:	eb 01                	jmp    101ed9 <trap_dispatch+0x134>
        break;
  101ed8:	90                   	nop
        }
    }
}
  101ed9:	90                   	nop
  101eda:	89 ec                	mov    %ebp,%esp
  101edc:	5d                   	pop    %ebp
  101edd:	c3                   	ret    

00101ede <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101ede:	55                   	push   %ebp
  101edf:	89 e5                	mov    %esp,%ebp
  101ee1:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101ee4:	8b 45 08             	mov    0x8(%ebp),%eax
  101ee7:	89 04 24             	mov    %eax,(%esp)
  101eea:	e8 b6 fe ff ff       	call   101da5 <trap_dispatch>
}
  101eef:	90                   	nop
  101ef0:	89 ec                	mov    %ebp,%esp
  101ef2:	5d                   	pop    %ebp
  101ef3:	c3                   	ret    

00101ef4 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101ef4:	1e                   	push   %ds
    pushl %es
  101ef5:	06                   	push   %es
    pushl %fs
  101ef6:	0f a0                	push   %fs
    pushl %gs
  101ef8:	0f a8                	push   %gs
    pushal
  101efa:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101efb:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101f00:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101f02:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101f04:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101f05:	e8 d4 ff ff ff       	call   101ede <trap>

    # pop the pushed stack pointer
    popl %esp
  101f0a:	5c                   	pop    %esp

00101f0b <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101f0b:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  101f0c:	0f a9                	pop    %gs
    popl %fs
  101f0e:	0f a1                	pop    %fs
    popl %es
  101f10:	07                   	pop    %es
    popl %ds
  101f11:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101f12:	83 c4 08             	add    $0x8,%esp
    iret
  101f15:	cf                   	iret   

00101f16 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101f16:	6a 00                	push   $0x0
  pushl $0
  101f18:	6a 00                	push   $0x0
  jmp __alltraps
  101f1a:	e9 d5 ff ff ff       	jmp    101ef4 <__alltraps>

00101f1f <vector1>:
.globl vector1
vector1:
  pushl $0
  101f1f:	6a 00                	push   $0x0
  pushl $1
  101f21:	6a 01                	push   $0x1
  jmp __alltraps
  101f23:	e9 cc ff ff ff       	jmp    101ef4 <__alltraps>

00101f28 <vector2>:
.globl vector2
vector2:
  pushl $0
  101f28:	6a 00                	push   $0x0
  pushl $2
  101f2a:	6a 02                	push   $0x2
  jmp __alltraps
  101f2c:	e9 c3 ff ff ff       	jmp    101ef4 <__alltraps>

00101f31 <vector3>:
.globl vector3
vector3:
  pushl $0
  101f31:	6a 00                	push   $0x0
  pushl $3
  101f33:	6a 03                	push   $0x3
  jmp __alltraps
  101f35:	e9 ba ff ff ff       	jmp    101ef4 <__alltraps>

00101f3a <vector4>:
.globl vector4
vector4:
  pushl $0
  101f3a:	6a 00                	push   $0x0
  pushl $4
  101f3c:	6a 04                	push   $0x4
  jmp __alltraps
  101f3e:	e9 b1 ff ff ff       	jmp    101ef4 <__alltraps>

00101f43 <vector5>:
.globl vector5
vector5:
  pushl $0
  101f43:	6a 00                	push   $0x0
  pushl $5
  101f45:	6a 05                	push   $0x5
  jmp __alltraps
  101f47:	e9 a8 ff ff ff       	jmp    101ef4 <__alltraps>

00101f4c <vector6>:
.globl vector6
vector6:
  pushl $0
  101f4c:	6a 00                	push   $0x0
  pushl $6
  101f4e:	6a 06                	push   $0x6
  jmp __alltraps
  101f50:	e9 9f ff ff ff       	jmp    101ef4 <__alltraps>

00101f55 <vector7>:
.globl vector7
vector7:
  pushl $0
  101f55:	6a 00                	push   $0x0
  pushl $7
  101f57:	6a 07                	push   $0x7
  jmp __alltraps
  101f59:	e9 96 ff ff ff       	jmp    101ef4 <__alltraps>

00101f5e <vector8>:
.globl vector8
vector8:
  pushl $8
  101f5e:	6a 08                	push   $0x8
  jmp __alltraps
  101f60:	e9 8f ff ff ff       	jmp    101ef4 <__alltraps>

00101f65 <vector9>:
.globl vector9
vector9:
  pushl $0
  101f65:	6a 00                	push   $0x0
  pushl $9
  101f67:	6a 09                	push   $0x9
  jmp __alltraps
  101f69:	e9 86 ff ff ff       	jmp    101ef4 <__alltraps>

00101f6e <vector10>:
.globl vector10
vector10:
  pushl $10
  101f6e:	6a 0a                	push   $0xa
  jmp __alltraps
  101f70:	e9 7f ff ff ff       	jmp    101ef4 <__alltraps>

00101f75 <vector11>:
.globl vector11
vector11:
  pushl $11
  101f75:	6a 0b                	push   $0xb
  jmp __alltraps
  101f77:	e9 78 ff ff ff       	jmp    101ef4 <__alltraps>

00101f7c <vector12>:
.globl vector12
vector12:
  pushl $12
  101f7c:	6a 0c                	push   $0xc
  jmp __alltraps
  101f7e:	e9 71 ff ff ff       	jmp    101ef4 <__alltraps>

00101f83 <vector13>:
.globl vector13
vector13:
  pushl $13
  101f83:	6a 0d                	push   $0xd
  jmp __alltraps
  101f85:	e9 6a ff ff ff       	jmp    101ef4 <__alltraps>

00101f8a <vector14>:
.globl vector14
vector14:
  pushl $14
  101f8a:	6a 0e                	push   $0xe
  jmp __alltraps
  101f8c:	e9 63 ff ff ff       	jmp    101ef4 <__alltraps>

00101f91 <vector15>:
.globl vector15
vector15:
  pushl $0
  101f91:	6a 00                	push   $0x0
  pushl $15
  101f93:	6a 0f                	push   $0xf
  jmp __alltraps
  101f95:	e9 5a ff ff ff       	jmp    101ef4 <__alltraps>

00101f9a <vector16>:
.globl vector16
vector16:
  pushl $0
  101f9a:	6a 00                	push   $0x0
  pushl $16
  101f9c:	6a 10                	push   $0x10
  jmp __alltraps
  101f9e:	e9 51 ff ff ff       	jmp    101ef4 <__alltraps>

00101fa3 <vector17>:
.globl vector17
vector17:
  pushl $17
  101fa3:	6a 11                	push   $0x11
  jmp __alltraps
  101fa5:	e9 4a ff ff ff       	jmp    101ef4 <__alltraps>

00101faa <vector18>:
.globl vector18
vector18:
  pushl $0
  101faa:	6a 00                	push   $0x0
  pushl $18
  101fac:	6a 12                	push   $0x12
  jmp __alltraps
  101fae:	e9 41 ff ff ff       	jmp    101ef4 <__alltraps>

00101fb3 <vector19>:
.globl vector19
vector19:
  pushl $0
  101fb3:	6a 00                	push   $0x0
  pushl $19
  101fb5:	6a 13                	push   $0x13
  jmp __alltraps
  101fb7:	e9 38 ff ff ff       	jmp    101ef4 <__alltraps>

00101fbc <vector20>:
.globl vector20
vector20:
  pushl $0
  101fbc:	6a 00                	push   $0x0
  pushl $20
  101fbe:	6a 14                	push   $0x14
  jmp __alltraps
  101fc0:	e9 2f ff ff ff       	jmp    101ef4 <__alltraps>

00101fc5 <vector21>:
.globl vector21
vector21:
  pushl $0
  101fc5:	6a 00                	push   $0x0
  pushl $21
  101fc7:	6a 15                	push   $0x15
  jmp __alltraps
  101fc9:	e9 26 ff ff ff       	jmp    101ef4 <__alltraps>

00101fce <vector22>:
.globl vector22
vector22:
  pushl $0
  101fce:	6a 00                	push   $0x0
  pushl $22
  101fd0:	6a 16                	push   $0x16
  jmp __alltraps
  101fd2:	e9 1d ff ff ff       	jmp    101ef4 <__alltraps>

00101fd7 <vector23>:
.globl vector23
vector23:
  pushl $0
  101fd7:	6a 00                	push   $0x0
  pushl $23
  101fd9:	6a 17                	push   $0x17
  jmp __alltraps
  101fdb:	e9 14 ff ff ff       	jmp    101ef4 <__alltraps>

00101fe0 <vector24>:
.globl vector24
vector24:
  pushl $0
  101fe0:	6a 00                	push   $0x0
  pushl $24
  101fe2:	6a 18                	push   $0x18
  jmp __alltraps
  101fe4:	e9 0b ff ff ff       	jmp    101ef4 <__alltraps>

00101fe9 <vector25>:
.globl vector25
vector25:
  pushl $0
  101fe9:	6a 00                	push   $0x0
  pushl $25
  101feb:	6a 19                	push   $0x19
  jmp __alltraps
  101fed:	e9 02 ff ff ff       	jmp    101ef4 <__alltraps>

00101ff2 <vector26>:
.globl vector26
vector26:
  pushl $0
  101ff2:	6a 00                	push   $0x0
  pushl $26
  101ff4:	6a 1a                	push   $0x1a
  jmp __alltraps
  101ff6:	e9 f9 fe ff ff       	jmp    101ef4 <__alltraps>

00101ffb <vector27>:
.globl vector27
vector27:
  pushl $0
  101ffb:	6a 00                	push   $0x0
  pushl $27
  101ffd:	6a 1b                	push   $0x1b
  jmp __alltraps
  101fff:	e9 f0 fe ff ff       	jmp    101ef4 <__alltraps>

00102004 <vector28>:
.globl vector28
vector28:
  pushl $0
  102004:	6a 00                	push   $0x0
  pushl $28
  102006:	6a 1c                	push   $0x1c
  jmp __alltraps
  102008:	e9 e7 fe ff ff       	jmp    101ef4 <__alltraps>

0010200d <vector29>:
.globl vector29
vector29:
  pushl $0
  10200d:	6a 00                	push   $0x0
  pushl $29
  10200f:	6a 1d                	push   $0x1d
  jmp __alltraps
  102011:	e9 de fe ff ff       	jmp    101ef4 <__alltraps>

00102016 <vector30>:
.globl vector30
vector30:
  pushl $0
  102016:	6a 00                	push   $0x0
  pushl $30
  102018:	6a 1e                	push   $0x1e
  jmp __alltraps
  10201a:	e9 d5 fe ff ff       	jmp    101ef4 <__alltraps>

0010201f <vector31>:
.globl vector31
vector31:
  pushl $0
  10201f:	6a 00                	push   $0x0
  pushl $31
  102021:	6a 1f                	push   $0x1f
  jmp __alltraps
  102023:	e9 cc fe ff ff       	jmp    101ef4 <__alltraps>

00102028 <vector32>:
.globl vector32
vector32:
  pushl $0
  102028:	6a 00                	push   $0x0
  pushl $32
  10202a:	6a 20                	push   $0x20
  jmp __alltraps
  10202c:	e9 c3 fe ff ff       	jmp    101ef4 <__alltraps>

00102031 <vector33>:
.globl vector33
vector33:
  pushl $0
  102031:	6a 00                	push   $0x0
  pushl $33
  102033:	6a 21                	push   $0x21
  jmp __alltraps
  102035:	e9 ba fe ff ff       	jmp    101ef4 <__alltraps>

0010203a <vector34>:
.globl vector34
vector34:
  pushl $0
  10203a:	6a 00                	push   $0x0
  pushl $34
  10203c:	6a 22                	push   $0x22
  jmp __alltraps
  10203e:	e9 b1 fe ff ff       	jmp    101ef4 <__alltraps>

00102043 <vector35>:
.globl vector35
vector35:
  pushl $0
  102043:	6a 00                	push   $0x0
  pushl $35
  102045:	6a 23                	push   $0x23
  jmp __alltraps
  102047:	e9 a8 fe ff ff       	jmp    101ef4 <__alltraps>

0010204c <vector36>:
.globl vector36
vector36:
  pushl $0
  10204c:	6a 00                	push   $0x0
  pushl $36
  10204e:	6a 24                	push   $0x24
  jmp __alltraps
  102050:	e9 9f fe ff ff       	jmp    101ef4 <__alltraps>

00102055 <vector37>:
.globl vector37
vector37:
  pushl $0
  102055:	6a 00                	push   $0x0
  pushl $37
  102057:	6a 25                	push   $0x25
  jmp __alltraps
  102059:	e9 96 fe ff ff       	jmp    101ef4 <__alltraps>

0010205e <vector38>:
.globl vector38
vector38:
  pushl $0
  10205e:	6a 00                	push   $0x0
  pushl $38
  102060:	6a 26                	push   $0x26
  jmp __alltraps
  102062:	e9 8d fe ff ff       	jmp    101ef4 <__alltraps>

00102067 <vector39>:
.globl vector39
vector39:
  pushl $0
  102067:	6a 00                	push   $0x0
  pushl $39
  102069:	6a 27                	push   $0x27
  jmp __alltraps
  10206b:	e9 84 fe ff ff       	jmp    101ef4 <__alltraps>

00102070 <vector40>:
.globl vector40
vector40:
  pushl $0
  102070:	6a 00                	push   $0x0
  pushl $40
  102072:	6a 28                	push   $0x28
  jmp __alltraps
  102074:	e9 7b fe ff ff       	jmp    101ef4 <__alltraps>

00102079 <vector41>:
.globl vector41
vector41:
  pushl $0
  102079:	6a 00                	push   $0x0
  pushl $41
  10207b:	6a 29                	push   $0x29
  jmp __alltraps
  10207d:	e9 72 fe ff ff       	jmp    101ef4 <__alltraps>

00102082 <vector42>:
.globl vector42
vector42:
  pushl $0
  102082:	6a 00                	push   $0x0
  pushl $42
  102084:	6a 2a                	push   $0x2a
  jmp __alltraps
  102086:	e9 69 fe ff ff       	jmp    101ef4 <__alltraps>

0010208b <vector43>:
.globl vector43
vector43:
  pushl $0
  10208b:	6a 00                	push   $0x0
  pushl $43
  10208d:	6a 2b                	push   $0x2b
  jmp __alltraps
  10208f:	e9 60 fe ff ff       	jmp    101ef4 <__alltraps>

00102094 <vector44>:
.globl vector44
vector44:
  pushl $0
  102094:	6a 00                	push   $0x0
  pushl $44
  102096:	6a 2c                	push   $0x2c
  jmp __alltraps
  102098:	e9 57 fe ff ff       	jmp    101ef4 <__alltraps>

0010209d <vector45>:
.globl vector45
vector45:
  pushl $0
  10209d:	6a 00                	push   $0x0
  pushl $45
  10209f:	6a 2d                	push   $0x2d
  jmp __alltraps
  1020a1:	e9 4e fe ff ff       	jmp    101ef4 <__alltraps>

001020a6 <vector46>:
.globl vector46
vector46:
  pushl $0
  1020a6:	6a 00                	push   $0x0
  pushl $46
  1020a8:	6a 2e                	push   $0x2e
  jmp __alltraps
  1020aa:	e9 45 fe ff ff       	jmp    101ef4 <__alltraps>

001020af <vector47>:
.globl vector47
vector47:
  pushl $0
  1020af:	6a 00                	push   $0x0
  pushl $47
  1020b1:	6a 2f                	push   $0x2f
  jmp __alltraps
  1020b3:	e9 3c fe ff ff       	jmp    101ef4 <__alltraps>

001020b8 <vector48>:
.globl vector48
vector48:
  pushl $0
  1020b8:	6a 00                	push   $0x0
  pushl $48
  1020ba:	6a 30                	push   $0x30
  jmp __alltraps
  1020bc:	e9 33 fe ff ff       	jmp    101ef4 <__alltraps>

001020c1 <vector49>:
.globl vector49
vector49:
  pushl $0
  1020c1:	6a 00                	push   $0x0
  pushl $49
  1020c3:	6a 31                	push   $0x31
  jmp __alltraps
  1020c5:	e9 2a fe ff ff       	jmp    101ef4 <__alltraps>

001020ca <vector50>:
.globl vector50
vector50:
  pushl $0
  1020ca:	6a 00                	push   $0x0
  pushl $50
  1020cc:	6a 32                	push   $0x32
  jmp __alltraps
  1020ce:	e9 21 fe ff ff       	jmp    101ef4 <__alltraps>

001020d3 <vector51>:
.globl vector51
vector51:
  pushl $0
  1020d3:	6a 00                	push   $0x0
  pushl $51
  1020d5:	6a 33                	push   $0x33
  jmp __alltraps
  1020d7:	e9 18 fe ff ff       	jmp    101ef4 <__alltraps>

001020dc <vector52>:
.globl vector52
vector52:
  pushl $0
  1020dc:	6a 00                	push   $0x0
  pushl $52
  1020de:	6a 34                	push   $0x34
  jmp __alltraps
  1020e0:	e9 0f fe ff ff       	jmp    101ef4 <__alltraps>

001020e5 <vector53>:
.globl vector53
vector53:
  pushl $0
  1020e5:	6a 00                	push   $0x0
  pushl $53
  1020e7:	6a 35                	push   $0x35
  jmp __alltraps
  1020e9:	e9 06 fe ff ff       	jmp    101ef4 <__alltraps>

001020ee <vector54>:
.globl vector54
vector54:
  pushl $0
  1020ee:	6a 00                	push   $0x0
  pushl $54
  1020f0:	6a 36                	push   $0x36
  jmp __alltraps
  1020f2:	e9 fd fd ff ff       	jmp    101ef4 <__alltraps>

001020f7 <vector55>:
.globl vector55
vector55:
  pushl $0
  1020f7:	6a 00                	push   $0x0
  pushl $55
  1020f9:	6a 37                	push   $0x37
  jmp __alltraps
  1020fb:	e9 f4 fd ff ff       	jmp    101ef4 <__alltraps>

00102100 <vector56>:
.globl vector56
vector56:
  pushl $0
  102100:	6a 00                	push   $0x0
  pushl $56
  102102:	6a 38                	push   $0x38
  jmp __alltraps
  102104:	e9 eb fd ff ff       	jmp    101ef4 <__alltraps>

00102109 <vector57>:
.globl vector57
vector57:
  pushl $0
  102109:	6a 00                	push   $0x0
  pushl $57
  10210b:	6a 39                	push   $0x39
  jmp __alltraps
  10210d:	e9 e2 fd ff ff       	jmp    101ef4 <__alltraps>

00102112 <vector58>:
.globl vector58
vector58:
  pushl $0
  102112:	6a 00                	push   $0x0
  pushl $58
  102114:	6a 3a                	push   $0x3a
  jmp __alltraps
  102116:	e9 d9 fd ff ff       	jmp    101ef4 <__alltraps>

0010211b <vector59>:
.globl vector59
vector59:
  pushl $0
  10211b:	6a 00                	push   $0x0
  pushl $59
  10211d:	6a 3b                	push   $0x3b
  jmp __alltraps
  10211f:	e9 d0 fd ff ff       	jmp    101ef4 <__alltraps>

00102124 <vector60>:
.globl vector60
vector60:
  pushl $0
  102124:	6a 00                	push   $0x0
  pushl $60
  102126:	6a 3c                	push   $0x3c
  jmp __alltraps
  102128:	e9 c7 fd ff ff       	jmp    101ef4 <__alltraps>

0010212d <vector61>:
.globl vector61
vector61:
  pushl $0
  10212d:	6a 00                	push   $0x0
  pushl $61
  10212f:	6a 3d                	push   $0x3d
  jmp __alltraps
  102131:	e9 be fd ff ff       	jmp    101ef4 <__alltraps>

00102136 <vector62>:
.globl vector62
vector62:
  pushl $0
  102136:	6a 00                	push   $0x0
  pushl $62
  102138:	6a 3e                	push   $0x3e
  jmp __alltraps
  10213a:	e9 b5 fd ff ff       	jmp    101ef4 <__alltraps>

0010213f <vector63>:
.globl vector63
vector63:
  pushl $0
  10213f:	6a 00                	push   $0x0
  pushl $63
  102141:	6a 3f                	push   $0x3f
  jmp __alltraps
  102143:	e9 ac fd ff ff       	jmp    101ef4 <__alltraps>

00102148 <vector64>:
.globl vector64
vector64:
  pushl $0
  102148:	6a 00                	push   $0x0
  pushl $64
  10214a:	6a 40                	push   $0x40
  jmp __alltraps
  10214c:	e9 a3 fd ff ff       	jmp    101ef4 <__alltraps>

00102151 <vector65>:
.globl vector65
vector65:
  pushl $0
  102151:	6a 00                	push   $0x0
  pushl $65
  102153:	6a 41                	push   $0x41
  jmp __alltraps
  102155:	e9 9a fd ff ff       	jmp    101ef4 <__alltraps>

0010215a <vector66>:
.globl vector66
vector66:
  pushl $0
  10215a:	6a 00                	push   $0x0
  pushl $66
  10215c:	6a 42                	push   $0x42
  jmp __alltraps
  10215e:	e9 91 fd ff ff       	jmp    101ef4 <__alltraps>

00102163 <vector67>:
.globl vector67
vector67:
  pushl $0
  102163:	6a 00                	push   $0x0
  pushl $67
  102165:	6a 43                	push   $0x43
  jmp __alltraps
  102167:	e9 88 fd ff ff       	jmp    101ef4 <__alltraps>

0010216c <vector68>:
.globl vector68
vector68:
  pushl $0
  10216c:	6a 00                	push   $0x0
  pushl $68
  10216e:	6a 44                	push   $0x44
  jmp __alltraps
  102170:	e9 7f fd ff ff       	jmp    101ef4 <__alltraps>

00102175 <vector69>:
.globl vector69
vector69:
  pushl $0
  102175:	6a 00                	push   $0x0
  pushl $69
  102177:	6a 45                	push   $0x45
  jmp __alltraps
  102179:	e9 76 fd ff ff       	jmp    101ef4 <__alltraps>

0010217e <vector70>:
.globl vector70
vector70:
  pushl $0
  10217e:	6a 00                	push   $0x0
  pushl $70
  102180:	6a 46                	push   $0x46
  jmp __alltraps
  102182:	e9 6d fd ff ff       	jmp    101ef4 <__alltraps>

00102187 <vector71>:
.globl vector71
vector71:
  pushl $0
  102187:	6a 00                	push   $0x0
  pushl $71
  102189:	6a 47                	push   $0x47
  jmp __alltraps
  10218b:	e9 64 fd ff ff       	jmp    101ef4 <__alltraps>

00102190 <vector72>:
.globl vector72
vector72:
  pushl $0
  102190:	6a 00                	push   $0x0
  pushl $72
  102192:	6a 48                	push   $0x48
  jmp __alltraps
  102194:	e9 5b fd ff ff       	jmp    101ef4 <__alltraps>

00102199 <vector73>:
.globl vector73
vector73:
  pushl $0
  102199:	6a 00                	push   $0x0
  pushl $73
  10219b:	6a 49                	push   $0x49
  jmp __alltraps
  10219d:	e9 52 fd ff ff       	jmp    101ef4 <__alltraps>

001021a2 <vector74>:
.globl vector74
vector74:
  pushl $0
  1021a2:	6a 00                	push   $0x0
  pushl $74
  1021a4:	6a 4a                	push   $0x4a
  jmp __alltraps
  1021a6:	e9 49 fd ff ff       	jmp    101ef4 <__alltraps>

001021ab <vector75>:
.globl vector75
vector75:
  pushl $0
  1021ab:	6a 00                	push   $0x0
  pushl $75
  1021ad:	6a 4b                	push   $0x4b
  jmp __alltraps
  1021af:	e9 40 fd ff ff       	jmp    101ef4 <__alltraps>

001021b4 <vector76>:
.globl vector76
vector76:
  pushl $0
  1021b4:	6a 00                	push   $0x0
  pushl $76
  1021b6:	6a 4c                	push   $0x4c
  jmp __alltraps
  1021b8:	e9 37 fd ff ff       	jmp    101ef4 <__alltraps>

001021bd <vector77>:
.globl vector77
vector77:
  pushl $0
  1021bd:	6a 00                	push   $0x0
  pushl $77
  1021bf:	6a 4d                	push   $0x4d
  jmp __alltraps
  1021c1:	e9 2e fd ff ff       	jmp    101ef4 <__alltraps>

001021c6 <vector78>:
.globl vector78
vector78:
  pushl $0
  1021c6:	6a 00                	push   $0x0
  pushl $78
  1021c8:	6a 4e                	push   $0x4e
  jmp __alltraps
  1021ca:	e9 25 fd ff ff       	jmp    101ef4 <__alltraps>

001021cf <vector79>:
.globl vector79
vector79:
  pushl $0
  1021cf:	6a 00                	push   $0x0
  pushl $79
  1021d1:	6a 4f                	push   $0x4f
  jmp __alltraps
  1021d3:	e9 1c fd ff ff       	jmp    101ef4 <__alltraps>

001021d8 <vector80>:
.globl vector80
vector80:
  pushl $0
  1021d8:	6a 00                	push   $0x0
  pushl $80
  1021da:	6a 50                	push   $0x50
  jmp __alltraps
  1021dc:	e9 13 fd ff ff       	jmp    101ef4 <__alltraps>

001021e1 <vector81>:
.globl vector81
vector81:
  pushl $0
  1021e1:	6a 00                	push   $0x0
  pushl $81
  1021e3:	6a 51                	push   $0x51
  jmp __alltraps
  1021e5:	e9 0a fd ff ff       	jmp    101ef4 <__alltraps>

001021ea <vector82>:
.globl vector82
vector82:
  pushl $0
  1021ea:	6a 00                	push   $0x0
  pushl $82
  1021ec:	6a 52                	push   $0x52
  jmp __alltraps
  1021ee:	e9 01 fd ff ff       	jmp    101ef4 <__alltraps>

001021f3 <vector83>:
.globl vector83
vector83:
  pushl $0
  1021f3:	6a 00                	push   $0x0
  pushl $83
  1021f5:	6a 53                	push   $0x53
  jmp __alltraps
  1021f7:	e9 f8 fc ff ff       	jmp    101ef4 <__alltraps>

001021fc <vector84>:
.globl vector84
vector84:
  pushl $0
  1021fc:	6a 00                	push   $0x0
  pushl $84
  1021fe:	6a 54                	push   $0x54
  jmp __alltraps
  102200:	e9 ef fc ff ff       	jmp    101ef4 <__alltraps>

00102205 <vector85>:
.globl vector85
vector85:
  pushl $0
  102205:	6a 00                	push   $0x0
  pushl $85
  102207:	6a 55                	push   $0x55
  jmp __alltraps
  102209:	e9 e6 fc ff ff       	jmp    101ef4 <__alltraps>

0010220e <vector86>:
.globl vector86
vector86:
  pushl $0
  10220e:	6a 00                	push   $0x0
  pushl $86
  102210:	6a 56                	push   $0x56
  jmp __alltraps
  102212:	e9 dd fc ff ff       	jmp    101ef4 <__alltraps>

00102217 <vector87>:
.globl vector87
vector87:
  pushl $0
  102217:	6a 00                	push   $0x0
  pushl $87
  102219:	6a 57                	push   $0x57
  jmp __alltraps
  10221b:	e9 d4 fc ff ff       	jmp    101ef4 <__alltraps>

00102220 <vector88>:
.globl vector88
vector88:
  pushl $0
  102220:	6a 00                	push   $0x0
  pushl $88
  102222:	6a 58                	push   $0x58
  jmp __alltraps
  102224:	e9 cb fc ff ff       	jmp    101ef4 <__alltraps>

00102229 <vector89>:
.globl vector89
vector89:
  pushl $0
  102229:	6a 00                	push   $0x0
  pushl $89
  10222b:	6a 59                	push   $0x59
  jmp __alltraps
  10222d:	e9 c2 fc ff ff       	jmp    101ef4 <__alltraps>

00102232 <vector90>:
.globl vector90
vector90:
  pushl $0
  102232:	6a 00                	push   $0x0
  pushl $90
  102234:	6a 5a                	push   $0x5a
  jmp __alltraps
  102236:	e9 b9 fc ff ff       	jmp    101ef4 <__alltraps>

0010223b <vector91>:
.globl vector91
vector91:
  pushl $0
  10223b:	6a 00                	push   $0x0
  pushl $91
  10223d:	6a 5b                	push   $0x5b
  jmp __alltraps
  10223f:	e9 b0 fc ff ff       	jmp    101ef4 <__alltraps>

00102244 <vector92>:
.globl vector92
vector92:
  pushl $0
  102244:	6a 00                	push   $0x0
  pushl $92
  102246:	6a 5c                	push   $0x5c
  jmp __alltraps
  102248:	e9 a7 fc ff ff       	jmp    101ef4 <__alltraps>

0010224d <vector93>:
.globl vector93
vector93:
  pushl $0
  10224d:	6a 00                	push   $0x0
  pushl $93
  10224f:	6a 5d                	push   $0x5d
  jmp __alltraps
  102251:	e9 9e fc ff ff       	jmp    101ef4 <__alltraps>

00102256 <vector94>:
.globl vector94
vector94:
  pushl $0
  102256:	6a 00                	push   $0x0
  pushl $94
  102258:	6a 5e                	push   $0x5e
  jmp __alltraps
  10225a:	e9 95 fc ff ff       	jmp    101ef4 <__alltraps>

0010225f <vector95>:
.globl vector95
vector95:
  pushl $0
  10225f:	6a 00                	push   $0x0
  pushl $95
  102261:	6a 5f                	push   $0x5f
  jmp __alltraps
  102263:	e9 8c fc ff ff       	jmp    101ef4 <__alltraps>

00102268 <vector96>:
.globl vector96
vector96:
  pushl $0
  102268:	6a 00                	push   $0x0
  pushl $96
  10226a:	6a 60                	push   $0x60
  jmp __alltraps
  10226c:	e9 83 fc ff ff       	jmp    101ef4 <__alltraps>

00102271 <vector97>:
.globl vector97
vector97:
  pushl $0
  102271:	6a 00                	push   $0x0
  pushl $97
  102273:	6a 61                	push   $0x61
  jmp __alltraps
  102275:	e9 7a fc ff ff       	jmp    101ef4 <__alltraps>

0010227a <vector98>:
.globl vector98
vector98:
  pushl $0
  10227a:	6a 00                	push   $0x0
  pushl $98
  10227c:	6a 62                	push   $0x62
  jmp __alltraps
  10227e:	e9 71 fc ff ff       	jmp    101ef4 <__alltraps>

00102283 <vector99>:
.globl vector99
vector99:
  pushl $0
  102283:	6a 00                	push   $0x0
  pushl $99
  102285:	6a 63                	push   $0x63
  jmp __alltraps
  102287:	e9 68 fc ff ff       	jmp    101ef4 <__alltraps>

0010228c <vector100>:
.globl vector100
vector100:
  pushl $0
  10228c:	6a 00                	push   $0x0
  pushl $100
  10228e:	6a 64                	push   $0x64
  jmp __alltraps
  102290:	e9 5f fc ff ff       	jmp    101ef4 <__alltraps>

00102295 <vector101>:
.globl vector101
vector101:
  pushl $0
  102295:	6a 00                	push   $0x0
  pushl $101
  102297:	6a 65                	push   $0x65
  jmp __alltraps
  102299:	e9 56 fc ff ff       	jmp    101ef4 <__alltraps>

0010229e <vector102>:
.globl vector102
vector102:
  pushl $0
  10229e:	6a 00                	push   $0x0
  pushl $102
  1022a0:	6a 66                	push   $0x66
  jmp __alltraps
  1022a2:	e9 4d fc ff ff       	jmp    101ef4 <__alltraps>

001022a7 <vector103>:
.globl vector103
vector103:
  pushl $0
  1022a7:	6a 00                	push   $0x0
  pushl $103
  1022a9:	6a 67                	push   $0x67
  jmp __alltraps
  1022ab:	e9 44 fc ff ff       	jmp    101ef4 <__alltraps>

001022b0 <vector104>:
.globl vector104
vector104:
  pushl $0
  1022b0:	6a 00                	push   $0x0
  pushl $104
  1022b2:	6a 68                	push   $0x68
  jmp __alltraps
  1022b4:	e9 3b fc ff ff       	jmp    101ef4 <__alltraps>

001022b9 <vector105>:
.globl vector105
vector105:
  pushl $0
  1022b9:	6a 00                	push   $0x0
  pushl $105
  1022bb:	6a 69                	push   $0x69
  jmp __alltraps
  1022bd:	e9 32 fc ff ff       	jmp    101ef4 <__alltraps>

001022c2 <vector106>:
.globl vector106
vector106:
  pushl $0
  1022c2:	6a 00                	push   $0x0
  pushl $106
  1022c4:	6a 6a                	push   $0x6a
  jmp __alltraps
  1022c6:	e9 29 fc ff ff       	jmp    101ef4 <__alltraps>

001022cb <vector107>:
.globl vector107
vector107:
  pushl $0
  1022cb:	6a 00                	push   $0x0
  pushl $107
  1022cd:	6a 6b                	push   $0x6b
  jmp __alltraps
  1022cf:	e9 20 fc ff ff       	jmp    101ef4 <__alltraps>

001022d4 <vector108>:
.globl vector108
vector108:
  pushl $0
  1022d4:	6a 00                	push   $0x0
  pushl $108
  1022d6:	6a 6c                	push   $0x6c
  jmp __alltraps
  1022d8:	e9 17 fc ff ff       	jmp    101ef4 <__alltraps>

001022dd <vector109>:
.globl vector109
vector109:
  pushl $0
  1022dd:	6a 00                	push   $0x0
  pushl $109
  1022df:	6a 6d                	push   $0x6d
  jmp __alltraps
  1022e1:	e9 0e fc ff ff       	jmp    101ef4 <__alltraps>

001022e6 <vector110>:
.globl vector110
vector110:
  pushl $0
  1022e6:	6a 00                	push   $0x0
  pushl $110
  1022e8:	6a 6e                	push   $0x6e
  jmp __alltraps
  1022ea:	e9 05 fc ff ff       	jmp    101ef4 <__alltraps>

001022ef <vector111>:
.globl vector111
vector111:
  pushl $0
  1022ef:	6a 00                	push   $0x0
  pushl $111
  1022f1:	6a 6f                	push   $0x6f
  jmp __alltraps
  1022f3:	e9 fc fb ff ff       	jmp    101ef4 <__alltraps>

001022f8 <vector112>:
.globl vector112
vector112:
  pushl $0
  1022f8:	6a 00                	push   $0x0
  pushl $112
  1022fa:	6a 70                	push   $0x70
  jmp __alltraps
  1022fc:	e9 f3 fb ff ff       	jmp    101ef4 <__alltraps>

00102301 <vector113>:
.globl vector113
vector113:
  pushl $0
  102301:	6a 00                	push   $0x0
  pushl $113
  102303:	6a 71                	push   $0x71
  jmp __alltraps
  102305:	e9 ea fb ff ff       	jmp    101ef4 <__alltraps>

0010230a <vector114>:
.globl vector114
vector114:
  pushl $0
  10230a:	6a 00                	push   $0x0
  pushl $114
  10230c:	6a 72                	push   $0x72
  jmp __alltraps
  10230e:	e9 e1 fb ff ff       	jmp    101ef4 <__alltraps>

00102313 <vector115>:
.globl vector115
vector115:
  pushl $0
  102313:	6a 00                	push   $0x0
  pushl $115
  102315:	6a 73                	push   $0x73
  jmp __alltraps
  102317:	e9 d8 fb ff ff       	jmp    101ef4 <__alltraps>

0010231c <vector116>:
.globl vector116
vector116:
  pushl $0
  10231c:	6a 00                	push   $0x0
  pushl $116
  10231e:	6a 74                	push   $0x74
  jmp __alltraps
  102320:	e9 cf fb ff ff       	jmp    101ef4 <__alltraps>

00102325 <vector117>:
.globl vector117
vector117:
  pushl $0
  102325:	6a 00                	push   $0x0
  pushl $117
  102327:	6a 75                	push   $0x75
  jmp __alltraps
  102329:	e9 c6 fb ff ff       	jmp    101ef4 <__alltraps>

0010232e <vector118>:
.globl vector118
vector118:
  pushl $0
  10232e:	6a 00                	push   $0x0
  pushl $118
  102330:	6a 76                	push   $0x76
  jmp __alltraps
  102332:	e9 bd fb ff ff       	jmp    101ef4 <__alltraps>

00102337 <vector119>:
.globl vector119
vector119:
  pushl $0
  102337:	6a 00                	push   $0x0
  pushl $119
  102339:	6a 77                	push   $0x77
  jmp __alltraps
  10233b:	e9 b4 fb ff ff       	jmp    101ef4 <__alltraps>

00102340 <vector120>:
.globl vector120
vector120:
  pushl $0
  102340:	6a 00                	push   $0x0
  pushl $120
  102342:	6a 78                	push   $0x78
  jmp __alltraps
  102344:	e9 ab fb ff ff       	jmp    101ef4 <__alltraps>

00102349 <vector121>:
.globl vector121
vector121:
  pushl $0
  102349:	6a 00                	push   $0x0
  pushl $121
  10234b:	6a 79                	push   $0x79
  jmp __alltraps
  10234d:	e9 a2 fb ff ff       	jmp    101ef4 <__alltraps>

00102352 <vector122>:
.globl vector122
vector122:
  pushl $0
  102352:	6a 00                	push   $0x0
  pushl $122
  102354:	6a 7a                	push   $0x7a
  jmp __alltraps
  102356:	e9 99 fb ff ff       	jmp    101ef4 <__alltraps>

0010235b <vector123>:
.globl vector123
vector123:
  pushl $0
  10235b:	6a 00                	push   $0x0
  pushl $123
  10235d:	6a 7b                	push   $0x7b
  jmp __alltraps
  10235f:	e9 90 fb ff ff       	jmp    101ef4 <__alltraps>

00102364 <vector124>:
.globl vector124
vector124:
  pushl $0
  102364:	6a 00                	push   $0x0
  pushl $124
  102366:	6a 7c                	push   $0x7c
  jmp __alltraps
  102368:	e9 87 fb ff ff       	jmp    101ef4 <__alltraps>

0010236d <vector125>:
.globl vector125
vector125:
  pushl $0
  10236d:	6a 00                	push   $0x0
  pushl $125
  10236f:	6a 7d                	push   $0x7d
  jmp __alltraps
  102371:	e9 7e fb ff ff       	jmp    101ef4 <__alltraps>

00102376 <vector126>:
.globl vector126
vector126:
  pushl $0
  102376:	6a 00                	push   $0x0
  pushl $126
  102378:	6a 7e                	push   $0x7e
  jmp __alltraps
  10237a:	e9 75 fb ff ff       	jmp    101ef4 <__alltraps>

0010237f <vector127>:
.globl vector127
vector127:
  pushl $0
  10237f:	6a 00                	push   $0x0
  pushl $127
  102381:	6a 7f                	push   $0x7f
  jmp __alltraps
  102383:	e9 6c fb ff ff       	jmp    101ef4 <__alltraps>

00102388 <vector128>:
.globl vector128
vector128:
  pushl $0
  102388:	6a 00                	push   $0x0
  pushl $128
  10238a:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  10238f:	e9 60 fb ff ff       	jmp    101ef4 <__alltraps>

00102394 <vector129>:
.globl vector129
vector129:
  pushl $0
  102394:	6a 00                	push   $0x0
  pushl $129
  102396:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  10239b:	e9 54 fb ff ff       	jmp    101ef4 <__alltraps>

001023a0 <vector130>:
.globl vector130
vector130:
  pushl $0
  1023a0:	6a 00                	push   $0x0
  pushl $130
  1023a2:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  1023a7:	e9 48 fb ff ff       	jmp    101ef4 <__alltraps>

001023ac <vector131>:
.globl vector131
vector131:
  pushl $0
  1023ac:	6a 00                	push   $0x0
  pushl $131
  1023ae:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  1023b3:	e9 3c fb ff ff       	jmp    101ef4 <__alltraps>

001023b8 <vector132>:
.globl vector132
vector132:
  pushl $0
  1023b8:	6a 00                	push   $0x0
  pushl $132
  1023ba:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  1023bf:	e9 30 fb ff ff       	jmp    101ef4 <__alltraps>

001023c4 <vector133>:
.globl vector133
vector133:
  pushl $0
  1023c4:	6a 00                	push   $0x0
  pushl $133
  1023c6:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  1023cb:	e9 24 fb ff ff       	jmp    101ef4 <__alltraps>

001023d0 <vector134>:
.globl vector134
vector134:
  pushl $0
  1023d0:	6a 00                	push   $0x0
  pushl $134
  1023d2:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  1023d7:	e9 18 fb ff ff       	jmp    101ef4 <__alltraps>

001023dc <vector135>:
.globl vector135
vector135:
  pushl $0
  1023dc:	6a 00                	push   $0x0
  pushl $135
  1023de:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  1023e3:	e9 0c fb ff ff       	jmp    101ef4 <__alltraps>

001023e8 <vector136>:
.globl vector136
vector136:
  pushl $0
  1023e8:	6a 00                	push   $0x0
  pushl $136
  1023ea:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  1023ef:	e9 00 fb ff ff       	jmp    101ef4 <__alltraps>

001023f4 <vector137>:
.globl vector137
vector137:
  pushl $0
  1023f4:	6a 00                	push   $0x0
  pushl $137
  1023f6:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  1023fb:	e9 f4 fa ff ff       	jmp    101ef4 <__alltraps>

00102400 <vector138>:
.globl vector138
vector138:
  pushl $0
  102400:	6a 00                	push   $0x0
  pushl $138
  102402:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  102407:	e9 e8 fa ff ff       	jmp    101ef4 <__alltraps>

0010240c <vector139>:
.globl vector139
vector139:
  pushl $0
  10240c:	6a 00                	push   $0x0
  pushl $139
  10240e:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  102413:	e9 dc fa ff ff       	jmp    101ef4 <__alltraps>

00102418 <vector140>:
.globl vector140
vector140:
  pushl $0
  102418:	6a 00                	push   $0x0
  pushl $140
  10241a:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  10241f:	e9 d0 fa ff ff       	jmp    101ef4 <__alltraps>

00102424 <vector141>:
.globl vector141
vector141:
  pushl $0
  102424:	6a 00                	push   $0x0
  pushl $141
  102426:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  10242b:	e9 c4 fa ff ff       	jmp    101ef4 <__alltraps>

00102430 <vector142>:
.globl vector142
vector142:
  pushl $0
  102430:	6a 00                	push   $0x0
  pushl $142
  102432:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  102437:	e9 b8 fa ff ff       	jmp    101ef4 <__alltraps>

0010243c <vector143>:
.globl vector143
vector143:
  pushl $0
  10243c:	6a 00                	push   $0x0
  pushl $143
  10243e:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  102443:	e9 ac fa ff ff       	jmp    101ef4 <__alltraps>

00102448 <vector144>:
.globl vector144
vector144:
  pushl $0
  102448:	6a 00                	push   $0x0
  pushl $144
  10244a:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  10244f:	e9 a0 fa ff ff       	jmp    101ef4 <__alltraps>

00102454 <vector145>:
.globl vector145
vector145:
  pushl $0
  102454:	6a 00                	push   $0x0
  pushl $145
  102456:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  10245b:	e9 94 fa ff ff       	jmp    101ef4 <__alltraps>

00102460 <vector146>:
.globl vector146
vector146:
  pushl $0
  102460:	6a 00                	push   $0x0
  pushl $146
  102462:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  102467:	e9 88 fa ff ff       	jmp    101ef4 <__alltraps>

0010246c <vector147>:
.globl vector147
vector147:
  pushl $0
  10246c:	6a 00                	push   $0x0
  pushl $147
  10246e:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  102473:	e9 7c fa ff ff       	jmp    101ef4 <__alltraps>

00102478 <vector148>:
.globl vector148
vector148:
  pushl $0
  102478:	6a 00                	push   $0x0
  pushl $148
  10247a:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  10247f:	e9 70 fa ff ff       	jmp    101ef4 <__alltraps>

00102484 <vector149>:
.globl vector149
vector149:
  pushl $0
  102484:	6a 00                	push   $0x0
  pushl $149
  102486:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  10248b:	e9 64 fa ff ff       	jmp    101ef4 <__alltraps>

00102490 <vector150>:
.globl vector150
vector150:
  pushl $0
  102490:	6a 00                	push   $0x0
  pushl $150
  102492:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  102497:	e9 58 fa ff ff       	jmp    101ef4 <__alltraps>

0010249c <vector151>:
.globl vector151
vector151:
  pushl $0
  10249c:	6a 00                	push   $0x0
  pushl $151
  10249e:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  1024a3:	e9 4c fa ff ff       	jmp    101ef4 <__alltraps>

001024a8 <vector152>:
.globl vector152
vector152:
  pushl $0
  1024a8:	6a 00                	push   $0x0
  pushl $152
  1024aa:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  1024af:	e9 40 fa ff ff       	jmp    101ef4 <__alltraps>

001024b4 <vector153>:
.globl vector153
vector153:
  pushl $0
  1024b4:	6a 00                	push   $0x0
  pushl $153
  1024b6:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  1024bb:	e9 34 fa ff ff       	jmp    101ef4 <__alltraps>

001024c0 <vector154>:
.globl vector154
vector154:
  pushl $0
  1024c0:	6a 00                	push   $0x0
  pushl $154
  1024c2:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  1024c7:	e9 28 fa ff ff       	jmp    101ef4 <__alltraps>

001024cc <vector155>:
.globl vector155
vector155:
  pushl $0
  1024cc:	6a 00                	push   $0x0
  pushl $155
  1024ce:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  1024d3:	e9 1c fa ff ff       	jmp    101ef4 <__alltraps>

001024d8 <vector156>:
.globl vector156
vector156:
  pushl $0
  1024d8:	6a 00                	push   $0x0
  pushl $156
  1024da:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  1024df:	e9 10 fa ff ff       	jmp    101ef4 <__alltraps>

001024e4 <vector157>:
.globl vector157
vector157:
  pushl $0
  1024e4:	6a 00                	push   $0x0
  pushl $157
  1024e6:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  1024eb:	e9 04 fa ff ff       	jmp    101ef4 <__alltraps>

001024f0 <vector158>:
.globl vector158
vector158:
  pushl $0
  1024f0:	6a 00                	push   $0x0
  pushl $158
  1024f2:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  1024f7:	e9 f8 f9 ff ff       	jmp    101ef4 <__alltraps>

001024fc <vector159>:
.globl vector159
vector159:
  pushl $0
  1024fc:	6a 00                	push   $0x0
  pushl $159
  1024fe:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  102503:	e9 ec f9 ff ff       	jmp    101ef4 <__alltraps>

00102508 <vector160>:
.globl vector160
vector160:
  pushl $0
  102508:	6a 00                	push   $0x0
  pushl $160
  10250a:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  10250f:	e9 e0 f9 ff ff       	jmp    101ef4 <__alltraps>

00102514 <vector161>:
.globl vector161
vector161:
  pushl $0
  102514:	6a 00                	push   $0x0
  pushl $161
  102516:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  10251b:	e9 d4 f9 ff ff       	jmp    101ef4 <__alltraps>

00102520 <vector162>:
.globl vector162
vector162:
  pushl $0
  102520:	6a 00                	push   $0x0
  pushl $162
  102522:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  102527:	e9 c8 f9 ff ff       	jmp    101ef4 <__alltraps>

0010252c <vector163>:
.globl vector163
vector163:
  pushl $0
  10252c:	6a 00                	push   $0x0
  pushl $163
  10252e:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  102533:	e9 bc f9 ff ff       	jmp    101ef4 <__alltraps>

00102538 <vector164>:
.globl vector164
vector164:
  pushl $0
  102538:	6a 00                	push   $0x0
  pushl $164
  10253a:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  10253f:	e9 b0 f9 ff ff       	jmp    101ef4 <__alltraps>

00102544 <vector165>:
.globl vector165
vector165:
  pushl $0
  102544:	6a 00                	push   $0x0
  pushl $165
  102546:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  10254b:	e9 a4 f9 ff ff       	jmp    101ef4 <__alltraps>

00102550 <vector166>:
.globl vector166
vector166:
  pushl $0
  102550:	6a 00                	push   $0x0
  pushl $166
  102552:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  102557:	e9 98 f9 ff ff       	jmp    101ef4 <__alltraps>

0010255c <vector167>:
.globl vector167
vector167:
  pushl $0
  10255c:	6a 00                	push   $0x0
  pushl $167
  10255e:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  102563:	e9 8c f9 ff ff       	jmp    101ef4 <__alltraps>

00102568 <vector168>:
.globl vector168
vector168:
  pushl $0
  102568:	6a 00                	push   $0x0
  pushl $168
  10256a:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  10256f:	e9 80 f9 ff ff       	jmp    101ef4 <__alltraps>

00102574 <vector169>:
.globl vector169
vector169:
  pushl $0
  102574:	6a 00                	push   $0x0
  pushl $169
  102576:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  10257b:	e9 74 f9 ff ff       	jmp    101ef4 <__alltraps>

00102580 <vector170>:
.globl vector170
vector170:
  pushl $0
  102580:	6a 00                	push   $0x0
  pushl $170
  102582:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  102587:	e9 68 f9 ff ff       	jmp    101ef4 <__alltraps>

0010258c <vector171>:
.globl vector171
vector171:
  pushl $0
  10258c:	6a 00                	push   $0x0
  pushl $171
  10258e:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  102593:	e9 5c f9 ff ff       	jmp    101ef4 <__alltraps>

00102598 <vector172>:
.globl vector172
vector172:
  pushl $0
  102598:	6a 00                	push   $0x0
  pushl $172
  10259a:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  10259f:	e9 50 f9 ff ff       	jmp    101ef4 <__alltraps>

001025a4 <vector173>:
.globl vector173
vector173:
  pushl $0
  1025a4:	6a 00                	push   $0x0
  pushl $173
  1025a6:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  1025ab:	e9 44 f9 ff ff       	jmp    101ef4 <__alltraps>

001025b0 <vector174>:
.globl vector174
vector174:
  pushl $0
  1025b0:	6a 00                	push   $0x0
  pushl $174
  1025b2:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  1025b7:	e9 38 f9 ff ff       	jmp    101ef4 <__alltraps>

001025bc <vector175>:
.globl vector175
vector175:
  pushl $0
  1025bc:	6a 00                	push   $0x0
  pushl $175
  1025be:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  1025c3:	e9 2c f9 ff ff       	jmp    101ef4 <__alltraps>

001025c8 <vector176>:
.globl vector176
vector176:
  pushl $0
  1025c8:	6a 00                	push   $0x0
  pushl $176
  1025ca:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  1025cf:	e9 20 f9 ff ff       	jmp    101ef4 <__alltraps>

001025d4 <vector177>:
.globl vector177
vector177:
  pushl $0
  1025d4:	6a 00                	push   $0x0
  pushl $177
  1025d6:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  1025db:	e9 14 f9 ff ff       	jmp    101ef4 <__alltraps>

001025e0 <vector178>:
.globl vector178
vector178:
  pushl $0
  1025e0:	6a 00                	push   $0x0
  pushl $178
  1025e2:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  1025e7:	e9 08 f9 ff ff       	jmp    101ef4 <__alltraps>

001025ec <vector179>:
.globl vector179
vector179:
  pushl $0
  1025ec:	6a 00                	push   $0x0
  pushl $179
  1025ee:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  1025f3:	e9 fc f8 ff ff       	jmp    101ef4 <__alltraps>

001025f8 <vector180>:
.globl vector180
vector180:
  pushl $0
  1025f8:	6a 00                	push   $0x0
  pushl $180
  1025fa:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  1025ff:	e9 f0 f8 ff ff       	jmp    101ef4 <__alltraps>

00102604 <vector181>:
.globl vector181
vector181:
  pushl $0
  102604:	6a 00                	push   $0x0
  pushl $181
  102606:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  10260b:	e9 e4 f8 ff ff       	jmp    101ef4 <__alltraps>

00102610 <vector182>:
.globl vector182
vector182:
  pushl $0
  102610:	6a 00                	push   $0x0
  pushl $182
  102612:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  102617:	e9 d8 f8 ff ff       	jmp    101ef4 <__alltraps>

0010261c <vector183>:
.globl vector183
vector183:
  pushl $0
  10261c:	6a 00                	push   $0x0
  pushl $183
  10261e:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  102623:	e9 cc f8 ff ff       	jmp    101ef4 <__alltraps>

00102628 <vector184>:
.globl vector184
vector184:
  pushl $0
  102628:	6a 00                	push   $0x0
  pushl $184
  10262a:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  10262f:	e9 c0 f8 ff ff       	jmp    101ef4 <__alltraps>

00102634 <vector185>:
.globl vector185
vector185:
  pushl $0
  102634:	6a 00                	push   $0x0
  pushl $185
  102636:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  10263b:	e9 b4 f8 ff ff       	jmp    101ef4 <__alltraps>

00102640 <vector186>:
.globl vector186
vector186:
  pushl $0
  102640:	6a 00                	push   $0x0
  pushl $186
  102642:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  102647:	e9 a8 f8 ff ff       	jmp    101ef4 <__alltraps>

0010264c <vector187>:
.globl vector187
vector187:
  pushl $0
  10264c:	6a 00                	push   $0x0
  pushl $187
  10264e:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  102653:	e9 9c f8 ff ff       	jmp    101ef4 <__alltraps>

00102658 <vector188>:
.globl vector188
vector188:
  pushl $0
  102658:	6a 00                	push   $0x0
  pushl $188
  10265a:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  10265f:	e9 90 f8 ff ff       	jmp    101ef4 <__alltraps>

00102664 <vector189>:
.globl vector189
vector189:
  pushl $0
  102664:	6a 00                	push   $0x0
  pushl $189
  102666:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  10266b:	e9 84 f8 ff ff       	jmp    101ef4 <__alltraps>

00102670 <vector190>:
.globl vector190
vector190:
  pushl $0
  102670:	6a 00                	push   $0x0
  pushl $190
  102672:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  102677:	e9 78 f8 ff ff       	jmp    101ef4 <__alltraps>

0010267c <vector191>:
.globl vector191
vector191:
  pushl $0
  10267c:	6a 00                	push   $0x0
  pushl $191
  10267e:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  102683:	e9 6c f8 ff ff       	jmp    101ef4 <__alltraps>

00102688 <vector192>:
.globl vector192
vector192:
  pushl $0
  102688:	6a 00                	push   $0x0
  pushl $192
  10268a:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  10268f:	e9 60 f8 ff ff       	jmp    101ef4 <__alltraps>

00102694 <vector193>:
.globl vector193
vector193:
  pushl $0
  102694:	6a 00                	push   $0x0
  pushl $193
  102696:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  10269b:	e9 54 f8 ff ff       	jmp    101ef4 <__alltraps>

001026a0 <vector194>:
.globl vector194
vector194:
  pushl $0
  1026a0:	6a 00                	push   $0x0
  pushl $194
  1026a2:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  1026a7:	e9 48 f8 ff ff       	jmp    101ef4 <__alltraps>

001026ac <vector195>:
.globl vector195
vector195:
  pushl $0
  1026ac:	6a 00                	push   $0x0
  pushl $195
  1026ae:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  1026b3:	e9 3c f8 ff ff       	jmp    101ef4 <__alltraps>

001026b8 <vector196>:
.globl vector196
vector196:
  pushl $0
  1026b8:	6a 00                	push   $0x0
  pushl $196
  1026ba:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  1026bf:	e9 30 f8 ff ff       	jmp    101ef4 <__alltraps>

001026c4 <vector197>:
.globl vector197
vector197:
  pushl $0
  1026c4:	6a 00                	push   $0x0
  pushl $197
  1026c6:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  1026cb:	e9 24 f8 ff ff       	jmp    101ef4 <__alltraps>

001026d0 <vector198>:
.globl vector198
vector198:
  pushl $0
  1026d0:	6a 00                	push   $0x0
  pushl $198
  1026d2:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  1026d7:	e9 18 f8 ff ff       	jmp    101ef4 <__alltraps>

001026dc <vector199>:
.globl vector199
vector199:
  pushl $0
  1026dc:	6a 00                	push   $0x0
  pushl $199
  1026de:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  1026e3:	e9 0c f8 ff ff       	jmp    101ef4 <__alltraps>

001026e8 <vector200>:
.globl vector200
vector200:
  pushl $0
  1026e8:	6a 00                	push   $0x0
  pushl $200
  1026ea:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  1026ef:	e9 00 f8 ff ff       	jmp    101ef4 <__alltraps>

001026f4 <vector201>:
.globl vector201
vector201:
  pushl $0
  1026f4:	6a 00                	push   $0x0
  pushl $201
  1026f6:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  1026fb:	e9 f4 f7 ff ff       	jmp    101ef4 <__alltraps>

00102700 <vector202>:
.globl vector202
vector202:
  pushl $0
  102700:	6a 00                	push   $0x0
  pushl $202
  102702:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  102707:	e9 e8 f7 ff ff       	jmp    101ef4 <__alltraps>

0010270c <vector203>:
.globl vector203
vector203:
  pushl $0
  10270c:	6a 00                	push   $0x0
  pushl $203
  10270e:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  102713:	e9 dc f7 ff ff       	jmp    101ef4 <__alltraps>

00102718 <vector204>:
.globl vector204
vector204:
  pushl $0
  102718:	6a 00                	push   $0x0
  pushl $204
  10271a:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  10271f:	e9 d0 f7 ff ff       	jmp    101ef4 <__alltraps>

00102724 <vector205>:
.globl vector205
vector205:
  pushl $0
  102724:	6a 00                	push   $0x0
  pushl $205
  102726:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  10272b:	e9 c4 f7 ff ff       	jmp    101ef4 <__alltraps>

00102730 <vector206>:
.globl vector206
vector206:
  pushl $0
  102730:	6a 00                	push   $0x0
  pushl $206
  102732:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  102737:	e9 b8 f7 ff ff       	jmp    101ef4 <__alltraps>

0010273c <vector207>:
.globl vector207
vector207:
  pushl $0
  10273c:	6a 00                	push   $0x0
  pushl $207
  10273e:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  102743:	e9 ac f7 ff ff       	jmp    101ef4 <__alltraps>

00102748 <vector208>:
.globl vector208
vector208:
  pushl $0
  102748:	6a 00                	push   $0x0
  pushl $208
  10274a:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  10274f:	e9 a0 f7 ff ff       	jmp    101ef4 <__alltraps>

00102754 <vector209>:
.globl vector209
vector209:
  pushl $0
  102754:	6a 00                	push   $0x0
  pushl $209
  102756:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  10275b:	e9 94 f7 ff ff       	jmp    101ef4 <__alltraps>

00102760 <vector210>:
.globl vector210
vector210:
  pushl $0
  102760:	6a 00                	push   $0x0
  pushl $210
  102762:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  102767:	e9 88 f7 ff ff       	jmp    101ef4 <__alltraps>

0010276c <vector211>:
.globl vector211
vector211:
  pushl $0
  10276c:	6a 00                	push   $0x0
  pushl $211
  10276e:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  102773:	e9 7c f7 ff ff       	jmp    101ef4 <__alltraps>

00102778 <vector212>:
.globl vector212
vector212:
  pushl $0
  102778:	6a 00                	push   $0x0
  pushl $212
  10277a:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  10277f:	e9 70 f7 ff ff       	jmp    101ef4 <__alltraps>

00102784 <vector213>:
.globl vector213
vector213:
  pushl $0
  102784:	6a 00                	push   $0x0
  pushl $213
  102786:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  10278b:	e9 64 f7 ff ff       	jmp    101ef4 <__alltraps>

00102790 <vector214>:
.globl vector214
vector214:
  pushl $0
  102790:	6a 00                	push   $0x0
  pushl $214
  102792:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  102797:	e9 58 f7 ff ff       	jmp    101ef4 <__alltraps>

0010279c <vector215>:
.globl vector215
vector215:
  pushl $0
  10279c:	6a 00                	push   $0x0
  pushl $215
  10279e:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  1027a3:	e9 4c f7 ff ff       	jmp    101ef4 <__alltraps>

001027a8 <vector216>:
.globl vector216
vector216:
  pushl $0
  1027a8:	6a 00                	push   $0x0
  pushl $216
  1027aa:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  1027af:	e9 40 f7 ff ff       	jmp    101ef4 <__alltraps>

001027b4 <vector217>:
.globl vector217
vector217:
  pushl $0
  1027b4:	6a 00                	push   $0x0
  pushl $217
  1027b6:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  1027bb:	e9 34 f7 ff ff       	jmp    101ef4 <__alltraps>

001027c0 <vector218>:
.globl vector218
vector218:
  pushl $0
  1027c0:	6a 00                	push   $0x0
  pushl $218
  1027c2:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  1027c7:	e9 28 f7 ff ff       	jmp    101ef4 <__alltraps>

001027cc <vector219>:
.globl vector219
vector219:
  pushl $0
  1027cc:	6a 00                	push   $0x0
  pushl $219
  1027ce:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  1027d3:	e9 1c f7 ff ff       	jmp    101ef4 <__alltraps>

001027d8 <vector220>:
.globl vector220
vector220:
  pushl $0
  1027d8:	6a 00                	push   $0x0
  pushl $220
  1027da:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  1027df:	e9 10 f7 ff ff       	jmp    101ef4 <__alltraps>

001027e4 <vector221>:
.globl vector221
vector221:
  pushl $0
  1027e4:	6a 00                	push   $0x0
  pushl $221
  1027e6:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  1027eb:	e9 04 f7 ff ff       	jmp    101ef4 <__alltraps>

001027f0 <vector222>:
.globl vector222
vector222:
  pushl $0
  1027f0:	6a 00                	push   $0x0
  pushl $222
  1027f2:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  1027f7:	e9 f8 f6 ff ff       	jmp    101ef4 <__alltraps>

001027fc <vector223>:
.globl vector223
vector223:
  pushl $0
  1027fc:	6a 00                	push   $0x0
  pushl $223
  1027fe:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  102803:	e9 ec f6 ff ff       	jmp    101ef4 <__alltraps>

00102808 <vector224>:
.globl vector224
vector224:
  pushl $0
  102808:	6a 00                	push   $0x0
  pushl $224
  10280a:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  10280f:	e9 e0 f6 ff ff       	jmp    101ef4 <__alltraps>

00102814 <vector225>:
.globl vector225
vector225:
  pushl $0
  102814:	6a 00                	push   $0x0
  pushl $225
  102816:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  10281b:	e9 d4 f6 ff ff       	jmp    101ef4 <__alltraps>

00102820 <vector226>:
.globl vector226
vector226:
  pushl $0
  102820:	6a 00                	push   $0x0
  pushl $226
  102822:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  102827:	e9 c8 f6 ff ff       	jmp    101ef4 <__alltraps>

0010282c <vector227>:
.globl vector227
vector227:
  pushl $0
  10282c:	6a 00                	push   $0x0
  pushl $227
  10282e:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  102833:	e9 bc f6 ff ff       	jmp    101ef4 <__alltraps>

00102838 <vector228>:
.globl vector228
vector228:
  pushl $0
  102838:	6a 00                	push   $0x0
  pushl $228
  10283a:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  10283f:	e9 b0 f6 ff ff       	jmp    101ef4 <__alltraps>

00102844 <vector229>:
.globl vector229
vector229:
  pushl $0
  102844:	6a 00                	push   $0x0
  pushl $229
  102846:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  10284b:	e9 a4 f6 ff ff       	jmp    101ef4 <__alltraps>

00102850 <vector230>:
.globl vector230
vector230:
  pushl $0
  102850:	6a 00                	push   $0x0
  pushl $230
  102852:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  102857:	e9 98 f6 ff ff       	jmp    101ef4 <__alltraps>

0010285c <vector231>:
.globl vector231
vector231:
  pushl $0
  10285c:	6a 00                	push   $0x0
  pushl $231
  10285e:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  102863:	e9 8c f6 ff ff       	jmp    101ef4 <__alltraps>

00102868 <vector232>:
.globl vector232
vector232:
  pushl $0
  102868:	6a 00                	push   $0x0
  pushl $232
  10286a:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  10286f:	e9 80 f6 ff ff       	jmp    101ef4 <__alltraps>

00102874 <vector233>:
.globl vector233
vector233:
  pushl $0
  102874:	6a 00                	push   $0x0
  pushl $233
  102876:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  10287b:	e9 74 f6 ff ff       	jmp    101ef4 <__alltraps>

00102880 <vector234>:
.globl vector234
vector234:
  pushl $0
  102880:	6a 00                	push   $0x0
  pushl $234
  102882:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  102887:	e9 68 f6 ff ff       	jmp    101ef4 <__alltraps>

0010288c <vector235>:
.globl vector235
vector235:
  pushl $0
  10288c:	6a 00                	push   $0x0
  pushl $235
  10288e:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  102893:	e9 5c f6 ff ff       	jmp    101ef4 <__alltraps>

00102898 <vector236>:
.globl vector236
vector236:
  pushl $0
  102898:	6a 00                	push   $0x0
  pushl $236
  10289a:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  10289f:	e9 50 f6 ff ff       	jmp    101ef4 <__alltraps>

001028a4 <vector237>:
.globl vector237
vector237:
  pushl $0
  1028a4:	6a 00                	push   $0x0
  pushl $237
  1028a6:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  1028ab:	e9 44 f6 ff ff       	jmp    101ef4 <__alltraps>

001028b0 <vector238>:
.globl vector238
vector238:
  pushl $0
  1028b0:	6a 00                	push   $0x0
  pushl $238
  1028b2:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  1028b7:	e9 38 f6 ff ff       	jmp    101ef4 <__alltraps>

001028bc <vector239>:
.globl vector239
vector239:
  pushl $0
  1028bc:	6a 00                	push   $0x0
  pushl $239
  1028be:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  1028c3:	e9 2c f6 ff ff       	jmp    101ef4 <__alltraps>

001028c8 <vector240>:
.globl vector240
vector240:
  pushl $0
  1028c8:	6a 00                	push   $0x0
  pushl $240
  1028ca:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  1028cf:	e9 20 f6 ff ff       	jmp    101ef4 <__alltraps>

001028d4 <vector241>:
.globl vector241
vector241:
  pushl $0
  1028d4:	6a 00                	push   $0x0
  pushl $241
  1028d6:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  1028db:	e9 14 f6 ff ff       	jmp    101ef4 <__alltraps>

001028e0 <vector242>:
.globl vector242
vector242:
  pushl $0
  1028e0:	6a 00                	push   $0x0
  pushl $242
  1028e2:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  1028e7:	e9 08 f6 ff ff       	jmp    101ef4 <__alltraps>

001028ec <vector243>:
.globl vector243
vector243:
  pushl $0
  1028ec:	6a 00                	push   $0x0
  pushl $243
  1028ee:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  1028f3:	e9 fc f5 ff ff       	jmp    101ef4 <__alltraps>

001028f8 <vector244>:
.globl vector244
vector244:
  pushl $0
  1028f8:	6a 00                	push   $0x0
  pushl $244
  1028fa:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  1028ff:	e9 f0 f5 ff ff       	jmp    101ef4 <__alltraps>

00102904 <vector245>:
.globl vector245
vector245:
  pushl $0
  102904:	6a 00                	push   $0x0
  pushl $245
  102906:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  10290b:	e9 e4 f5 ff ff       	jmp    101ef4 <__alltraps>

00102910 <vector246>:
.globl vector246
vector246:
  pushl $0
  102910:	6a 00                	push   $0x0
  pushl $246
  102912:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  102917:	e9 d8 f5 ff ff       	jmp    101ef4 <__alltraps>

0010291c <vector247>:
.globl vector247
vector247:
  pushl $0
  10291c:	6a 00                	push   $0x0
  pushl $247
  10291e:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  102923:	e9 cc f5 ff ff       	jmp    101ef4 <__alltraps>

00102928 <vector248>:
.globl vector248
vector248:
  pushl $0
  102928:	6a 00                	push   $0x0
  pushl $248
  10292a:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  10292f:	e9 c0 f5 ff ff       	jmp    101ef4 <__alltraps>

00102934 <vector249>:
.globl vector249
vector249:
  pushl $0
  102934:	6a 00                	push   $0x0
  pushl $249
  102936:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  10293b:	e9 b4 f5 ff ff       	jmp    101ef4 <__alltraps>

00102940 <vector250>:
.globl vector250
vector250:
  pushl $0
  102940:	6a 00                	push   $0x0
  pushl $250
  102942:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  102947:	e9 a8 f5 ff ff       	jmp    101ef4 <__alltraps>

0010294c <vector251>:
.globl vector251
vector251:
  pushl $0
  10294c:	6a 00                	push   $0x0
  pushl $251
  10294e:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  102953:	e9 9c f5 ff ff       	jmp    101ef4 <__alltraps>

00102958 <vector252>:
.globl vector252
vector252:
  pushl $0
  102958:	6a 00                	push   $0x0
  pushl $252
  10295a:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  10295f:	e9 90 f5 ff ff       	jmp    101ef4 <__alltraps>

00102964 <vector253>:
.globl vector253
vector253:
  pushl $0
  102964:	6a 00                	push   $0x0
  pushl $253
  102966:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  10296b:	e9 84 f5 ff ff       	jmp    101ef4 <__alltraps>

00102970 <vector254>:
.globl vector254
vector254:
  pushl $0
  102970:	6a 00                	push   $0x0
  pushl $254
  102972:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  102977:	e9 78 f5 ff ff       	jmp    101ef4 <__alltraps>

0010297c <vector255>:
.globl vector255
vector255:
  pushl $0
  10297c:	6a 00                	push   $0x0
  pushl $255
  10297e:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102983:	e9 6c f5 ff ff       	jmp    101ef4 <__alltraps>

00102988 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  102988:	55                   	push   %ebp
  102989:	89 e5                	mov    %esp,%ebp
    return page - pages;
  10298b:	8b 15 a0 ce 11 00    	mov    0x11cea0,%edx
  102991:	8b 45 08             	mov    0x8(%ebp),%eax
  102994:	29 d0                	sub    %edx,%eax
  102996:	c1 f8 02             	sar    $0x2,%eax
  102999:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  10299f:	5d                   	pop    %ebp
  1029a0:	c3                   	ret    

001029a1 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  1029a1:	55                   	push   %ebp
  1029a2:	89 e5                	mov    %esp,%ebp
  1029a4:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  1029a7:	8b 45 08             	mov    0x8(%ebp),%eax
  1029aa:	89 04 24             	mov    %eax,(%esp)
  1029ad:	e8 d6 ff ff ff       	call   102988 <page2ppn>
  1029b2:	c1 e0 0c             	shl    $0xc,%eax
}
  1029b5:	89 ec                	mov    %ebp,%esp
  1029b7:	5d                   	pop    %ebp
  1029b8:	c3                   	ret    

001029b9 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
  1029b9:	55                   	push   %ebp
  1029ba:	89 e5                	mov    %esp,%ebp
    return page->ref;
  1029bc:	8b 45 08             	mov    0x8(%ebp),%eax
  1029bf:	8b 00                	mov    (%eax),%eax
}
  1029c1:	5d                   	pop    %ebp
  1029c2:	c3                   	ret    

001029c3 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  1029c3:	55                   	push   %ebp
  1029c4:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  1029c6:	8b 45 08             	mov    0x8(%ebp),%eax
  1029c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  1029cc:	89 10                	mov    %edx,(%eax)
}
  1029ce:	90                   	nop
  1029cf:	5d                   	pop    %ebp
  1029d0:	c3                   	ret    

001029d1 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
  1029d1:	55                   	push   %ebp
  1029d2:	89 e5                	mov    %esp,%ebp
  1029d4:	83 ec 10             	sub    $0x10,%esp
  1029d7:	c7 45 fc 80 ce 11 00 	movl   $0x11ce80,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  1029de:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1029e1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1029e4:	89 50 04             	mov    %edx,0x4(%eax)
  1029e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1029ea:	8b 50 04             	mov    0x4(%eax),%edx
  1029ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1029f0:	89 10                	mov    %edx,(%eax)
}
  1029f2:	90                   	nop
    list_init(&free_list);
    nr_free = 0;
  1029f3:	c7 05 88 ce 11 00 00 	movl   $0x0,0x11ce88
  1029fa:	00 00 00 
}
  1029fd:	90                   	nop
  1029fe:	89 ec                	mov    %ebp,%esp
  102a00:	5d                   	pop    %ebp
  102a01:	c3                   	ret    

00102a02 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
  102a02:	55                   	push   %ebp
  102a03:	89 e5                	mov    %esp,%ebp
  102a05:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
  102a08:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102a0c:	75 24                	jne    102a32 <default_init_memmap+0x30>
  102a0e:	c7 44 24 0c 30 68 10 	movl   $0x106830,0xc(%esp)
  102a15:	00 
  102a16:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  102a1d:	00 
  102a1e:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  102a25:	00 
  102a26:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  102a2d:	e8 d0 e2 ff ff       	call   100d02 <__panic>
    struct Page *p = base;
  102a32:	8b 45 08             	mov    0x8(%ebp),%eax
  102a35:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  102a38:	eb 7d                	jmp    102ab7 <default_init_memmap+0xb5>
        assert(PageReserved(p));
  102a3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a3d:	83 c0 04             	add    $0x4,%eax
  102a40:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  102a47:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102a4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102a4d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102a50:	0f a3 10             	bt     %edx,(%eax)
  102a53:	19 c0                	sbb    %eax,%eax
  102a55:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
  102a58:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102a5c:	0f 95 c0             	setne  %al
  102a5f:	0f b6 c0             	movzbl %al,%eax
  102a62:	85 c0                	test   %eax,%eax
  102a64:	75 24                	jne    102a8a <default_init_memmap+0x88>
  102a66:	c7 44 24 0c 61 68 10 	movl   $0x106861,0xc(%esp)
  102a6d:	00 
  102a6e:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  102a75:	00 
  102a76:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
  102a7d:	00 
  102a7e:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  102a85:	e8 78 e2 ff ff       	call   100d02 <__panic>
        p->flags = p->property = 0;
  102a8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a8d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  102a94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a97:	8b 50 08             	mov    0x8(%eax),%edx
  102a9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a9d:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
  102aa0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102aa7:	00 
  102aa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102aab:	89 04 24             	mov    %eax,(%esp)
  102aae:	e8 10 ff ff ff       	call   1029c3 <set_page_ref>
    for (; p != base + n; p ++) {
  102ab3:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  102ab7:	8b 55 0c             	mov    0xc(%ebp),%edx
  102aba:	89 d0                	mov    %edx,%eax
  102abc:	c1 e0 02             	shl    $0x2,%eax
  102abf:	01 d0                	add    %edx,%eax
  102ac1:	c1 e0 02             	shl    $0x2,%eax
  102ac4:	89 c2                	mov    %eax,%edx
  102ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  102ac9:	01 d0                	add    %edx,%eax
  102acb:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  102ace:	0f 85 66 ff ff ff    	jne    102a3a <default_init_memmap+0x38>
    }
    base->property = n;
  102ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  102ad7:	8b 55 0c             	mov    0xc(%ebp),%edx
  102ada:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  102add:	8b 45 08             	mov    0x8(%ebp),%eax
  102ae0:	83 c0 04             	add    $0x4,%eax
  102ae3:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  102aea:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102aed:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102af0:	8b 55 c8             	mov    -0x38(%ebp),%edx
  102af3:	0f ab 10             	bts    %edx,(%eax)
}
  102af6:	90                   	nop
    nr_free += n;
  102af7:	8b 15 88 ce 11 00    	mov    0x11ce88,%edx
  102afd:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b00:	01 d0                	add    %edx,%eax
  102b02:	a3 88 ce 11 00       	mov    %eax,0x11ce88
    list_add(&free_list, &(base->page_link));
  102b07:	8b 45 08             	mov    0x8(%ebp),%eax
  102b0a:	83 c0 0c             	add    $0xc,%eax
  102b0d:	c7 45 e4 80 ce 11 00 	movl   $0x11ce80,-0x1c(%ebp)
  102b14:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102b17:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102b1a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  102b1d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102b20:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
  102b23:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102b26:	8b 40 04             	mov    0x4(%eax),%eax
  102b29:	8b 55 d8             	mov    -0x28(%ebp),%edx
  102b2c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102b2f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102b32:	89 55 d0             	mov    %edx,-0x30(%ebp)
  102b35:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102b38:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102b3b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102b3e:	89 10                	mov    %edx,(%eax)
  102b40:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102b43:	8b 10                	mov    (%eax),%edx
  102b45:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102b48:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102b4b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102b4e:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102b51:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102b54:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102b57:	8b 55 d0             	mov    -0x30(%ebp),%edx
  102b5a:	89 10                	mov    %edx,(%eax)
}
  102b5c:	90                   	nop
}
  102b5d:	90                   	nop
}
  102b5e:	90                   	nop
}
  102b5f:	90                   	nop
  102b60:	89 ec                	mov    %ebp,%esp
  102b62:	5d                   	pop    %ebp
  102b63:	c3                   	ret    

00102b64 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
  102b64:	55                   	push   %ebp
  102b65:	89 e5                	mov    %esp,%ebp
  102b67:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
  102b6a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102b6e:	75 24                	jne    102b94 <default_alloc_pages+0x30>
  102b70:	c7 44 24 0c 30 68 10 	movl   $0x106830,0xc(%esp)
  102b77:	00 
  102b78:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  102b7f:	00 
  102b80:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  102b87:	00 
  102b88:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  102b8f:	e8 6e e1 ff ff       	call   100d02 <__panic>
    if (n > nr_free) {
  102b94:	a1 88 ce 11 00       	mov    0x11ce88,%eax
  102b99:	39 45 08             	cmp    %eax,0x8(%ebp)
  102b9c:	76 0a                	jbe    102ba8 <default_alloc_pages+0x44>
        return NULL;
  102b9e:	b8 00 00 00 00       	mov    $0x0,%eax
  102ba3:	e9 62 01 00 00       	jmp    102d0a <default_alloc_pages+0x1a6>
    }
    struct Page *page = NULL;
  102ba8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
  102baf:	c7 45 f0 80 ce 11 00 	movl   $0x11ce80,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
  102bb6:	eb 1c                	jmp    102bd4 <default_alloc_pages+0x70>
        struct Page *p = le2page(le, page_link);
  102bb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102bbb:	83 e8 0c             	sub    $0xc,%eax
  102bbe:	89 45 e8             	mov    %eax,-0x18(%ebp)
        if (p->property >= n) {
  102bc1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102bc4:	8b 40 08             	mov    0x8(%eax),%eax
  102bc7:	39 45 08             	cmp    %eax,0x8(%ebp)
  102bca:	77 08                	ja     102bd4 <default_alloc_pages+0x70>
            page = p;
  102bcc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102bcf:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  102bd2:	eb 18                	jmp    102bec <default_alloc_pages+0x88>
  102bd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102bd7:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return listelm->next;
  102bda:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102bdd:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  102be0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102be3:	81 7d f0 80 ce 11 00 	cmpl   $0x11ce80,-0x10(%ebp)
  102bea:	75 cc                	jne    102bb8 <default_alloc_pages+0x54>
        }
    }
    if (page != NULL) {
  102bec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  102bf0:	0f 84 11 01 00 00    	je     102d07 <default_alloc_pages+0x1a3>
        list_del(&(page->page_link));
  102bf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102bf9:	83 c0 0c             	add    $0xc,%eax
  102bfc:	89 45 dc             	mov    %eax,-0x24(%ebp)
    __list_del(listelm->prev, listelm->next);
  102bff:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102c02:	8b 40 04             	mov    0x4(%eax),%eax
  102c05:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102c08:	8b 12                	mov    (%edx),%edx
  102c0a:	89 55 d8             	mov    %edx,-0x28(%ebp)
  102c0d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  102c10:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102c13:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102c16:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102c19:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102c1c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  102c1f:	89 10                	mov    %edx,(%eax)
}
  102c21:	90                   	nop
}
  102c22:	90                   	nop
        if (page->property > n) {
  102c23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c26:	8b 40 08             	mov    0x8(%eax),%eax
  102c29:	39 45 08             	cmp    %eax,0x8(%ebp)
  102c2c:	0f 83 ae 00 00 00    	jae    102ce0 <default_alloc_pages+0x17c>
            struct Page *p = page + n;
  102c32:	8b 55 08             	mov    0x8(%ebp),%edx
  102c35:	89 d0                	mov    %edx,%eax
  102c37:	c1 e0 02             	shl    $0x2,%eax
  102c3a:	01 d0                	add    %edx,%eax
  102c3c:	c1 e0 02             	shl    $0x2,%eax
  102c3f:	89 c2                	mov    %eax,%edx
  102c41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c44:	01 d0                	add    %edx,%eax
  102c46:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            p->property = page->property - n;
  102c49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c4c:	8b 40 08             	mov    0x8(%eax),%eax
  102c4f:	2b 45 08             	sub    0x8(%ebp),%eax
  102c52:	89 c2                	mov    %eax,%edx
  102c54:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102c57:	89 50 08             	mov    %edx,0x8(%eax)
  102c5a:	c7 45 d0 80 ce 11 00 	movl   $0x11ce80,-0x30(%ebp)
    return listelm->next;
  102c61:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102c64:	8b 40 04             	mov    0x4(%eax),%eax
            //原来的代码没有实现有序链入
            //list_add(&free_list, &(p->page_link));
            
            //找到第一个比剩余内存块要大的内存块，并把剩余块插到它之前
            struct list_entry_t* it;
            for(it=list_next(&free_list);it!=&free_list && le2page(it,page_link)->property < p->property;it=list_next(it));
  102c67:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102c6a:	eb 0f                	jmp    102c7b <default_alloc_pages+0x117>
  102c6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102c6f:	89 45 cc             	mov    %eax,-0x34(%ebp)
  102c72:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102c75:	8b 40 04             	mov    0x4(%eax),%eax
  102c78:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102c7b:	81 7d ec 80 ce 11 00 	cmpl   $0x11ce80,-0x14(%ebp)
  102c82:	74 13                	je     102c97 <default_alloc_pages+0x133>
  102c84:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102c87:	83 e8 0c             	sub    $0xc,%eax
  102c8a:	8b 50 08             	mov    0x8(%eax),%edx
  102c8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102c90:	8b 40 08             	mov    0x8(%eax),%eax
  102c93:	39 c2                	cmp    %eax,%edx
  102c95:	72 d5                	jb     102c6c <default_alloc_pages+0x108>
            list_add_before(it, &(p->page_link));
  102c97:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102c9a:	8d 50 0c             	lea    0xc(%eax),%edx
  102c9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102ca0:	89 45 c8             	mov    %eax,-0x38(%ebp)
  102ca3:	89 55 c4             	mov    %edx,-0x3c(%ebp)
    __list_add(elm, listelm->prev, listelm);
  102ca6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102ca9:	8b 00                	mov    (%eax),%eax
  102cab:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102cae:	89 55 c0             	mov    %edx,-0x40(%ebp)
  102cb1:	89 45 bc             	mov    %eax,-0x44(%ebp)
  102cb4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102cb7:	89 45 b8             	mov    %eax,-0x48(%ebp)
    prev->next = next->prev = elm;
  102cba:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102cbd:	8b 55 c0             	mov    -0x40(%ebp),%edx
  102cc0:	89 10                	mov    %edx,(%eax)
  102cc2:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102cc5:	8b 10                	mov    (%eax),%edx
  102cc7:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102cca:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102ccd:	8b 45 c0             	mov    -0x40(%ebp),%eax
  102cd0:	8b 55 b8             	mov    -0x48(%ebp),%edx
  102cd3:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102cd6:	8b 45 c0             	mov    -0x40(%ebp),%eax
  102cd9:	8b 55 bc             	mov    -0x44(%ebp),%edx
  102cdc:	89 10                	mov    %edx,(%eax)
}
  102cde:	90                   	nop
}
  102cdf:	90                   	nop
    }
        nr_free -= n;
  102ce0:	a1 88 ce 11 00       	mov    0x11ce88,%eax
  102ce5:	2b 45 08             	sub    0x8(%ebp),%eax
  102ce8:	a3 88 ce 11 00       	mov    %eax,0x11ce88
        ClearPageProperty(page);
  102ced:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102cf0:	83 c0 04             	add    $0x4,%eax
  102cf3:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
  102cfa:	89 45 b0             	mov    %eax,-0x50(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102cfd:	8b 45 b0             	mov    -0x50(%ebp),%eax
  102d00:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  102d03:	0f b3 10             	btr    %edx,(%eax)
}
  102d06:	90                   	nop
    }
    return page;
  102d07:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102d0a:	89 ec                	mov    %ebp,%esp
  102d0c:	5d                   	pop    %ebp
  102d0d:	c3                   	ret    

00102d0e <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
  102d0e:	55                   	push   %ebp
  102d0f:	89 e5                	mov    %esp,%ebp
  102d11:	81 ec 98 00 00 00    	sub    $0x98,%esp
    assert(n > 0);
  102d17:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102d1b:	75 24                	jne    102d41 <default_free_pages+0x33>
  102d1d:	c7 44 24 0c 30 68 10 	movl   $0x106830,0xc(%esp)
  102d24:	00 
  102d25:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  102d2c:	00 
  102d2d:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
  102d34:	00 
  102d35:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  102d3c:	e8 c1 df ff ff       	call   100d02 <__panic>
    struct Page *p = base;
  102d41:	8b 45 08             	mov    0x8(%ebp),%eax
  102d44:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  102d47:	e9 9d 00 00 00       	jmp    102de9 <default_free_pages+0xdb>
        assert(!PageReserved(p) && !PageProperty(p));
  102d4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d4f:	83 c0 04             	add    $0x4,%eax
  102d52:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  102d59:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102d5c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102d5f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  102d62:	0f a3 10             	bt     %edx,(%eax)
  102d65:	19 c0                	sbb    %eax,%eax
  102d67:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return oldbit != 0;
  102d6a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  102d6e:	0f 95 c0             	setne  %al
  102d71:	0f b6 c0             	movzbl %al,%eax
  102d74:	85 c0                	test   %eax,%eax
  102d76:	75 2c                	jne    102da4 <default_free_pages+0x96>
  102d78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d7b:	83 c0 04             	add    $0x4,%eax
  102d7e:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
  102d85:	89 45 d8             	mov    %eax,-0x28(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102d88:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102d8b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102d8e:	0f a3 10             	bt     %edx,(%eax)
  102d91:	19 c0                	sbb    %eax,%eax
  102d93:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    return oldbit != 0;
  102d96:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  102d9a:	0f 95 c0             	setne  %al
  102d9d:	0f b6 c0             	movzbl %al,%eax
  102da0:	85 c0                	test   %eax,%eax
  102da2:	74 24                	je     102dc8 <default_free_pages+0xba>
  102da4:	c7 44 24 0c 74 68 10 	movl   $0x106874,0xc(%esp)
  102dab:	00 
  102dac:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  102db3:	00 
  102db4:	c7 44 24 04 a1 00 00 	movl   $0xa1,0x4(%esp)
  102dbb:	00 
  102dbc:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  102dc3:	e8 3a df ff ff       	call   100d02 <__panic>
        p->flags = 0;
  102dc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102dcb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
  102dd2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102dd9:	00 
  102dda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ddd:	89 04 24             	mov    %eax,(%esp)
  102de0:	e8 de fb ff ff       	call   1029c3 <set_page_ref>
    for (; p != base + n; p ++) {
  102de5:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  102de9:	8b 55 0c             	mov    0xc(%ebp),%edx
  102dec:	89 d0                	mov    %edx,%eax
  102dee:	c1 e0 02             	shl    $0x2,%eax
  102df1:	01 d0                	add    %edx,%eax
  102df3:	c1 e0 02             	shl    $0x2,%eax
  102df6:	89 c2                	mov    %eax,%edx
  102df8:	8b 45 08             	mov    0x8(%ebp),%eax
  102dfb:	01 d0                	add    %edx,%eax
  102dfd:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  102e00:	0f 85 46 ff ff ff    	jne    102d4c <default_free_pages+0x3e>
    }
    base->property = n;
  102e06:	8b 45 08             	mov    0x8(%ebp),%eax
  102e09:	8b 55 0c             	mov    0xc(%ebp),%edx
  102e0c:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  102e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  102e12:	83 c0 04             	add    $0x4,%eax
  102e15:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
  102e1c:	89 45 c8             	mov    %eax,-0x38(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102e1f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102e22:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102e25:	0f ab 10             	bts    %edx,(%eax)
}
  102e28:	90                   	nop
  102e29:	c7 45 d0 80 ce 11 00 	movl   $0x11ce80,-0x30(%ebp)
    return listelm->next;
  102e30:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102e33:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
  102e36:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
  102e39:	e9 0e 01 00 00       	jmp    102f4c <default_free_pages+0x23e>
        p = le2page(le, page_link);
  102e3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e41:	83 e8 0c             	sub    $0xc,%eax
  102e44:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102e47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e4a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  102e4d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102e50:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
  102e53:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (base + base->property == p) {
  102e56:	8b 45 08             	mov    0x8(%ebp),%eax
  102e59:	8b 50 08             	mov    0x8(%eax),%edx
  102e5c:	89 d0                	mov    %edx,%eax
  102e5e:	c1 e0 02             	shl    $0x2,%eax
  102e61:	01 d0                	add    %edx,%eax
  102e63:	c1 e0 02             	shl    $0x2,%eax
  102e66:	89 c2                	mov    %eax,%edx
  102e68:	8b 45 08             	mov    0x8(%ebp),%eax
  102e6b:	01 d0                	add    %edx,%eax
  102e6d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  102e70:	75 5d                	jne    102ecf <default_free_pages+0x1c1>
            base->property += p->property;
  102e72:	8b 45 08             	mov    0x8(%ebp),%eax
  102e75:	8b 50 08             	mov    0x8(%eax),%edx
  102e78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e7b:	8b 40 08             	mov    0x8(%eax),%eax
  102e7e:	01 c2                	add    %eax,%edx
  102e80:	8b 45 08             	mov    0x8(%ebp),%eax
  102e83:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
  102e86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e89:	83 c0 04             	add    $0x4,%eax
  102e8c:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
  102e93:	89 45 b0             	mov    %eax,-0x50(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102e96:	8b 45 b0             	mov    -0x50(%ebp),%eax
  102e99:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  102e9c:	0f b3 10             	btr    %edx,(%eax)
}
  102e9f:	90                   	nop
            list_del(&(p->page_link));
  102ea0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ea3:	83 c0 0c             	add    $0xc,%eax
  102ea6:	89 45 c0             	mov    %eax,-0x40(%ebp)
    __list_del(listelm->prev, listelm->next);
  102ea9:	8b 45 c0             	mov    -0x40(%ebp),%eax
  102eac:	8b 40 04             	mov    0x4(%eax),%eax
  102eaf:	8b 55 c0             	mov    -0x40(%ebp),%edx
  102eb2:	8b 12                	mov    (%edx),%edx
  102eb4:	89 55 bc             	mov    %edx,-0x44(%ebp)
  102eb7:	89 45 b8             	mov    %eax,-0x48(%ebp)
    prev->next = next;
  102eba:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102ebd:	8b 55 b8             	mov    -0x48(%ebp),%edx
  102ec0:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102ec3:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102ec6:	8b 55 bc             	mov    -0x44(%ebp),%edx
  102ec9:	89 10                	mov    %edx,(%eax)
}
  102ecb:	90                   	nop
}
  102ecc:	90                   	nop
  102ecd:	eb 7d                	jmp    102f4c <default_free_pages+0x23e>
        }
        else if (p + p->property == base) {
  102ecf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ed2:	8b 50 08             	mov    0x8(%eax),%edx
  102ed5:	89 d0                	mov    %edx,%eax
  102ed7:	c1 e0 02             	shl    $0x2,%eax
  102eda:	01 d0                	add    %edx,%eax
  102edc:	c1 e0 02             	shl    $0x2,%eax
  102edf:	89 c2                	mov    %eax,%edx
  102ee1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ee4:	01 d0                	add    %edx,%eax
  102ee6:	39 45 08             	cmp    %eax,0x8(%ebp)
  102ee9:	75 61                	jne    102f4c <default_free_pages+0x23e>
            p->property += base->property;
  102eeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102eee:	8b 50 08             	mov    0x8(%eax),%edx
  102ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  102ef4:	8b 40 08             	mov    0x8(%eax),%eax
  102ef7:	01 c2                	add    %eax,%edx
  102ef9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102efc:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
  102eff:	8b 45 08             	mov    0x8(%ebp),%eax
  102f02:	83 c0 04             	add    $0x4,%eax
  102f05:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
  102f0c:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102f0f:	8b 45 9c             	mov    -0x64(%ebp),%eax
  102f12:	8b 55 a0             	mov    -0x60(%ebp),%edx
  102f15:	0f b3 10             	btr    %edx,(%eax)
}
  102f18:	90                   	nop
            base = p;
  102f19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f1c:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
  102f1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f22:	83 c0 0c             	add    $0xc,%eax
  102f25:	89 45 ac             	mov    %eax,-0x54(%ebp)
    __list_del(listelm->prev, listelm->next);
  102f28:	8b 45 ac             	mov    -0x54(%ebp),%eax
  102f2b:	8b 40 04             	mov    0x4(%eax),%eax
  102f2e:	8b 55 ac             	mov    -0x54(%ebp),%edx
  102f31:	8b 12                	mov    (%edx),%edx
  102f33:	89 55 a8             	mov    %edx,-0x58(%ebp)
  102f36:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    prev->next = next;
  102f39:	8b 45 a8             	mov    -0x58(%ebp),%eax
  102f3c:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  102f3f:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102f42:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  102f45:	8b 55 a8             	mov    -0x58(%ebp),%edx
  102f48:	89 10                	mov    %edx,(%eax)
}
  102f4a:	90                   	nop
}
  102f4b:	90                   	nop
    while (le != &free_list) {
  102f4c:	81 7d f0 80 ce 11 00 	cmpl   $0x11ce80,-0x10(%ebp)
  102f53:	0f 85 e5 fe ff ff    	jne    102e3e <default_free_pages+0x130>
        }
    }
    nr_free += n;
  102f59:	8b 15 88 ce 11 00    	mov    0x11ce88,%edx
  102f5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f62:	01 d0                	add    %edx,%eax
  102f64:	a3 88 ce 11 00       	mov    %eax,0x11ce88
  102f69:	c7 45 98 80 ce 11 00 	movl   $0x11ce80,-0x68(%ebp)
    return listelm->next;
  102f70:	8b 45 98             	mov    -0x68(%ebp),%eax
  102f73:	8b 40 04             	mov    0x4(%eax),%eax
    struct list_entry_t* it;
    for(it=list_next(&free_list);it!=&free_list && le2page(it,page_link)->property < base->property;it=list_next(it));
  102f76:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102f79:	eb 0f                	jmp    102f8a <default_free_pages+0x27c>
  102f7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102f7e:	89 45 94             	mov    %eax,-0x6c(%ebp)
  102f81:	8b 45 94             	mov    -0x6c(%ebp),%eax
  102f84:	8b 40 04             	mov    0x4(%eax),%eax
  102f87:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102f8a:	81 7d ec 80 ce 11 00 	cmpl   $0x11ce80,-0x14(%ebp)
  102f91:	74 13                	je     102fa6 <default_free_pages+0x298>
  102f93:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102f96:	83 e8 0c             	sub    $0xc,%eax
  102f99:	8b 50 08             	mov    0x8(%eax),%edx
  102f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  102f9f:	8b 40 08             	mov    0x8(%eax),%eax
  102fa2:	39 c2                	cmp    %eax,%edx
  102fa4:	72 d5                	jb     102f7b <default_free_pages+0x26d>
    list_add_before(it, &(base->page_link));
  102fa6:	8b 45 08             	mov    0x8(%ebp),%eax
  102fa9:	8d 50 0c             	lea    0xc(%eax),%edx
  102fac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102faf:	89 45 90             	mov    %eax,-0x70(%ebp)
  102fb2:	89 55 8c             	mov    %edx,-0x74(%ebp)
    __list_add(elm, listelm->prev, listelm);
  102fb5:	8b 45 90             	mov    -0x70(%ebp),%eax
  102fb8:	8b 00                	mov    (%eax),%eax
  102fba:	8b 55 8c             	mov    -0x74(%ebp),%edx
  102fbd:	89 55 88             	mov    %edx,-0x78(%ebp)
  102fc0:	89 45 84             	mov    %eax,-0x7c(%ebp)
  102fc3:	8b 45 90             	mov    -0x70(%ebp),%eax
  102fc6:	89 45 80             	mov    %eax,-0x80(%ebp)
    prev->next = next->prev = elm;
  102fc9:	8b 45 80             	mov    -0x80(%ebp),%eax
  102fcc:	8b 55 88             	mov    -0x78(%ebp),%edx
  102fcf:	89 10                	mov    %edx,(%eax)
  102fd1:	8b 45 80             	mov    -0x80(%ebp),%eax
  102fd4:	8b 10                	mov    (%eax),%edx
  102fd6:	8b 45 84             	mov    -0x7c(%ebp),%eax
  102fd9:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102fdc:	8b 45 88             	mov    -0x78(%ebp),%eax
  102fdf:	8b 55 80             	mov    -0x80(%ebp),%edx
  102fe2:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102fe5:	8b 45 88             	mov    -0x78(%ebp),%eax
  102fe8:	8b 55 84             	mov    -0x7c(%ebp),%edx
  102feb:	89 10                	mov    %edx,(%eax)
}
  102fed:	90                   	nop
}
  102fee:	90                   	nop
    
    //原来的代码没有实现有序链入
    //list_add(&free_list, &(base->page_link));
}
  102fef:	90                   	nop
  102ff0:	89 ec                	mov    %ebp,%esp
  102ff2:	5d                   	pop    %ebp
  102ff3:	c3                   	ret    

00102ff4 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
  102ff4:	55                   	push   %ebp
  102ff5:	89 e5                	mov    %esp,%ebp
    return nr_free;
  102ff7:	a1 88 ce 11 00       	mov    0x11ce88,%eax
}
  102ffc:	5d                   	pop    %ebp
  102ffd:	c3                   	ret    

00102ffe <basic_check>:

static void
basic_check(void) {
  102ffe:	55                   	push   %ebp
  102fff:	89 e5                	mov    %esp,%ebp
  103001:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  103004:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  10300b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10300e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103011:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103014:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
  103017:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10301e:	e8 ed 0e 00 00       	call   103f10 <alloc_pages>
  103023:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103026:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  10302a:	75 24                	jne    103050 <basic_check+0x52>
  10302c:	c7 44 24 0c 99 68 10 	movl   $0x106899,0xc(%esp)
  103033:	00 
  103034:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  10303b:	00 
  10303c:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
  103043:	00 
  103044:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  10304b:	e8 b2 dc ff ff       	call   100d02 <__panic>
    assert((p1 = alloc_page()) != NULL);
  103050:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103057:	e8 b4 0e 00 00       	call   103f10 <alloc_pages>
  10305c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10305f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103063:	75 24                	jne    103089 <basic_check+0x8b>
  103065:	c7 44 24 0c b5 68 10 	movl   $0x1068b5,0xc(%esp)
  10306c:	00 
  10306d:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  103074:	00 
  103075:	c7 44 24 04 ca 00 00 	movl   $0xca,0x4(%esp)
  10307c:	00 
  10307d:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  103084:	e8 79 dc ff ff       	call   100d02 <__panic>
    assert((p2 = alloc_page()) != NULL);
  103089:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103090:	e8 7b 0e 00 00       	call   103f10 <alloc_pages>
  103095:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103098:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10309c:	75 24                	jne    1030c2 <basic_check+0xc4>
  10309e:	c7 44 24 0c d1 68 10 	movl   $0x1068d1,0xc(%esp)
  1030a5:	00 
  1030a6:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  1030ad:	00 
  1030ae:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
  1030b5:	00 
  1030b6:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  1030bd:	e8 40 dc ff ff       	call   100d02 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
  1030c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1030c5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  1030c8:	74 10                	je     1030da <basic_check+0xdc>
  1030ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1030cd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  1030d0:	74 08                	je     1030da <basic_check+0xdc>
  1030d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1030d5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  1030d8:	75 24                	jne    1030fe <basic_check+0x100>
  1030da:	c7 44 24 0c f0 68 10 	movl   $0x1068f0,0xc(%esp)
  1030e1:	00 
  1030e2:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  1030e9:	00 
  1030ea:	c7 44 24 04 cd 00 00 	movl   $0xcd,0x4(%esp)
  1030f1:	00 
  1030f2:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  1030f9:	e8 04 dc ff ff       	call   100d02 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  1030fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103101:	89 04 24             	mov    %eax,(%esp)
  103104:	e8 b0 f8 ff ff       	call   1029b9 <page_ref>
  103109:	85 c0                	test   %eax,%eax
  10310b:	75 1e                	jne    10312b <basic_check+0x12d>
  10310d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103110:	89 04 24             	mov    %eax,(%esp)
  103113:	e8 a1 f8 ff ff       	call   1029b9 <page_ref>
  103118:	85 c0                	test   %eax,%eax
  10311a:	75 0f                	jne    10312b <basic_check+0x12d>
  10311c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10311f:	89 04 24             	mov    %eax,(%esp)
  103122:	e8 92 f8 ff ff       	call   1029b9 <page_ref>
  103127:	85 c0                	test   %eax,%eax
  103129:	74 24                	je     10314f <basic_check+0x151>
  10312b:	c7 44 24 0c 14 69 10 	movl   $0x106914,0xc(%esp)
  103132:	00 
  103133:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  10313a:	00 
  10313b:	c7 44 24 04 ce 00 00 	movl   $0xce,0x4(%esp)
  103142:	00 
  103143:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  10314a:	e8 b3 db ff ff       	call   100d02 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  10314f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103152:	89 04 24             	mov    %eax,(%esp)
  103155:	e8 47 f8 ff ff       	call   1029a1 <page2pa>
  10315a:	8b 15 a4 ce 11 00    	mov    0x11cea4,%edx
  103160:	c1 e2 0c             	shl    $0xc,%edx
  103163:	39 d0                	cmp    %edx,%eax
  103165:	72 24                	jb     10318b <basic_check+0x18d>
  103167:	c7 44 24 0c 50 69 10 	movl   $0x106950,0xc(%esp)
  10316e:	00 
  10316f:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  103176:	00 
  103177:	c7 44 24 04 d0 00 00 	movl   $0xd0,0x4(%esp)
  10317e:	00 
  10317f:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  103186:	e8 77 db ff ff       	call   100d02 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  10318b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10318e:	89 04 24             	mov    %eax,(%esp)
  103191:	e8 0b f8 ff ff       	call   1029a1 <page2pa>
  103196:	8b 15 a4 ce 11 00    	mov    0x11cea4,%edx
  10319c:	c1 e2 0c             	shl    $0xc,%edx
  10319f:	39 d0                	cmp    %edx,%eax
  1031a1:	72 24                	jb     1031c7 <basic_check+0x1c9>
  1031a3:	c7 44 24 0c 6d 69 10 	movl   $0x10696d,0xc(%esp)
  1031aa:	00 
  1031ab:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  1031b2:	00 
  1031b3:	c7 44 24 04 d1 00 00 	movl   $0xd1,0x4(%esp)
  1031ba:	00 
  1031bb:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  1031c2:	e8 3b db ff ff       	call   100d02 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  1031c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1031ca:	89 04 24             	mov    %eax,(%esp)
  1031cd:	e8 cf f7 ff ff       	call   1029a1 <page2pa>
  1031d2:	8b 15 a4 ce 11 00    	mov    0x11cea4,%edx
  1031d8:	c1 e2 0c             	shl    $0xc,%edx
  1031db:	39 d0                	cmp    %edx,%eax
  1031dd:	72 24                	jb     103203 <basic_check+0x205>
  1031df:	c7 44 24 0c 8a 69 10 	movl   $0x10698a,0xc(%esp)
  1031e6:	00 
  1031e7:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  1031ee:	00 
  1031ef:	c7 44 24 04 d2 00 00 	movl   $0xd2,0x4(%esp)
  1031f6:	00 
  1031f7:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  1031fe:	e8 ff da ff ff       	call   100d02 <__panic>

    list_entry_t free_list_store = free_list;
  103203:	a1 80 ce 11 00       	mov    0x11ce80,%eax
  103208:	8b 15 84 ce 11 00    	mov    0x11ce84,%edx
  10320e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103211:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  103214:	c7 45 dc 80 ce 11 00 	movl   $0x11ce80,-0x24(%ebp)
    elm->prev = elm->next = elm;
  10321b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10321e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103221:	89 50 04             	mov    %edx,0x4(%eax)
  103224:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103227:	8b 50 04             	mov    0x4(%eax),%edx
  10322a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10322d:	89 10                	mov    %edx,(%eax)
}
  10322f:	90                   	nop
  103230:	c7 45 e0 80 ce 11 00 	movl   $0x11ce80,-0x20(%ebp)
    return list->next == list;
  103237:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10323a:	8b 40 04             	mov    0x4(%eax),%eax
  10323d:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  103240:	0f 94 c0             	sete   %al
  103243:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  103246:	85 c0                	test   %eax,%eax
  103248:	75 24                	jne    10326e <basic_check+0x270>
  10324a:	c7 44 24 0c a7 69 10 	movl   $0x1069a7,0xc(%esp)
  103251:	00 
  103252:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  103259:	00 
  10325a:	c7 44 24 04 d6 00 00 	movl   $0xd6,0x4(%esp)
  103261:	00 
  103262:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  103269:	e8 94 da ff ff       	call   100d02 <__panic>

    unsigned int nr_free_store = nr_free;
  10326e:	a1 88 ce 11 00       	mov    0x11ce88,%eax
  103273:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
  103276:	c7 05 88 ce 11 00 00 	movl   $0x0,0x11ce88
  10327d:	00 00 00 

    assert(alloc_page() == NULL);
  103280:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103287:	e8 84 0c 00 00       	call   103f10 <alloc_pages>
  10328c:	85 c0                	test   %eax,%eax
  10328e:	74 24                	je     1032b4 <basic_check+0x2b6>
  103290:	c7 44 24 0c be 69 10 	movl   $0x1069be,0xc(%esp)
  103297:	00 
  103298:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  10329f:	00 
  1032a0:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
  1032a7:	00 
  1032a8:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  1032af:	e8 4e da ff ff       	call   100d02 <__panic>

    free_page(p0);
  1032b4:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1032bb:	00 
  1032bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1032bf:	89 04 24             	mov    %eax,(%esp)
  1032c2:	e8 83 0c 00 00       	call   103f4a <free_pages>
    free_page(p1);
  1032c7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1032ce:	00 
  1032cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1032d2:	89 04 24             	mov    %eax,(%esp)
  1032d5:	e8 70 0c 00 00       	call   103f4a <free_pages>
    free_page(p2);
  1032da:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1032e1:	00 
  1032e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1032e5:	89 04 24             	mov    %eax,(%esp)
  1032e8:	e8 5d 0c 00 00       	call   103f4a <free_pages>
    assert(nr_free == 3);
  1032ed:	a1 88 ce 11 00       	mov    0x11ce88,%eax
  1032f2:	83 f8 03             	cmp    $0x3,%eax
  1032f5:	74 24                	je     10331b <basic_check+0x31d>
  1032f7:	c7 44 24 0c d3 69 10 	movl   $0x1069d3,0xc(%esp)
  1032fe:	00 
  1032ff:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  103306:	00 
  103307:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
  10330e:	00 
  10330f:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  103316:	e8 e7 d9 ff ff       	call   100d02 <__panic>

    assert((p0 = alloc_page()) != NULL);
  10331b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103322:	e8 e9 0b 00 00       	call   103f10 <alloc_pages>
  103327:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10332a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  10332e:	75 24                	jne    103354 <basic_check+0x356>
  103330:	c7 44 24 0c 99 68 10 	movl   $0x106899,0xc(%esp)
  103337:	00 
  103338:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  10333f:	00 
  103340:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
  103347:	00 
  103348:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  10334f:	e8 ae d9 ff ff       	call   100d02 <__panic>
    assert((p1 = alloc_page()) != NULL);
  103354:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10335b:	e8 b0 0b 00 00       	call   103f10 <alloc_pages>
  103360:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103363:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103367:	75 24                	jne    10338d <basic_check+0x38f>
  103369:	c7 44 24 0c b5 68 10 	movl   $0x1068b5,0xc(%esp)
  103370:	00 
  103371:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  103378:	00 
  103379:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
  103380:	00 
  103381:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  103388:	e8 75 d9 ff ff       	call   100d02 <__panic>
    assert((p2 = alloc_page()) != NULL);
  10338d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103394:	e8 77 0b 00 00       	call   103f10 <alloc_pages>
  103399:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10339c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1033a0:	75 24                	jne    1033c6 <basic_check+0x3c8>
  1033a2:	c7 44 24 0c d1 68 10 	movl   $0x1068d1,0xc(%esp)
  1033a9:	00 
  1033aa:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  1033b1:	00 
  1033b2:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
  1033b9:	00 
  1033ba:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  1033c1:	e8 3c d9 ff ff       	call   100d02 <__panic>

    assert(alloc_page() == NULL);
  1033c6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1033cd:	e8 3e 0b 00 00       	call   103f10 <alloc_pages>
  1033d2:	85 c0                	test   %eax,%eax
  1033d4:	74 24                	je     1033fa <basic_check+0x3fc>
  1033d6:	c7 44 24 0c be 69 10 	movl   $0x1069be,0xc(%esp)
  1033dd:	00 
  1033de:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  1033e5:	00 
  1033e6:	c7 44 24 04 e6 00 00 	movl   $0xe6,0x4(%esp)
  1033ed:	00 
  1033ee:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  1033f5:	e8 08 d9 ff ff       	call   100d02 <__panic>

    free_page(p0);
  1033fa:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103401:	00 
  103402:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103405:	89 04 24             	mov    %eax,(%esp)
  103408:	e8 3d 0b 00 00       	call   103f4a <free_pages>
  10340d:	c7 45 d8 80 ce 11 00 	movl   $0x11ce80,-0x28(%ebp)
  103414:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103417:	8b 40 04             	mov    0x4(%eax),%eax
  10341a:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  10341d:	0f 94 c0             	sete   %al
  103420:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
  103423:	85 c0                	test   %eax,%eax
  103425:	74 24                	je     10344b <basic_check+0x44d>
  103427:	c7 44 24 0c e0 69 10 	movl   $0x1069e0,0xc(%esp)
  10342e:	00 
  10342f:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  103436:	00 
  103437:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
  10343e:	00 
  10343f:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  103446:	e8 b7 d8 ff ff       	call   100d02 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
  10344b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103452:	e8 b9 0a 00 00       	call   103f10 <alloc_pages>
  103457:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10345a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10345d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  103460:	74 24                	je     103486 <basic_check+0x488>
  103462:	c7 44 24 0c f8 69 10 	movl   $0x1069f8,0xc(%esp)
  103469:	00 
  10346a:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  103471:	00 
  103472:	c7 44 24 04 ec 00 00 	movl   $0xec,0x4(%esp)
  103479:	00 
  10347a:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  103481:	e8 7c d8 ff ff       	call   100d02 <__panic>
    assert(alloc_page() == NULL);
  103486:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10348d:	e8 7e 0a 00 00       	call   103f10 <alloc_pages>
  103492:	85 c0                	test   %eax,%eax
  103494:	74 24                	je     1034ba <basic_check+0x4bc>
  103496:	c7 44 24 0c be 69 10 	movl   $0x1069be,0xc(%esp)
  10349d:	00 
  10349e:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  1034a5:	00 
  1034a6:	c7 44 24 04 ed 00 00 	movl   $0xed,0x4(%esp)
  1034ad:	00 
  1034ae:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  1034b5:	e8 48 d8 ff ff       	call   100d02 <__panic>

    assert(nr_free == 0);
  1034ba:	a1 88 ce 11 00       	mov    0x11ce88,%eax
  1034bf:	85 c0                	test   %eax,%eax
  1034c1:	74 24                	je     1034e7 <basic_check+0x4e9>
  1034c3:	c7 44 24 0c 11 6a 10 	movl   $0x106a11,0xc(%esp)
  1034ca:	00 
  1034cb:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  1034d2:	00 
  1034d3:	c7 44 24 04 ef 00 00 	movl   $0xef,0x4(%esp)
  1034da:	00 
  1034db:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  1034e2:	e8 1b d8 ff ff       	call   100d02 <__panic>
    free_list = free_list_store;
  1034e7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1034ea:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1034ed:	a3 80 ce 11 00       	mov    %eax,0x11ce80
  1034f2:	89 15 84 ce 11 00    	mov    %edx,0x11ce84
    nr_free = nr_free_store;
  1034f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1034fb:	a3 88 ce 11 00       	mov    %eax,0x11ce88

    free_page(p);
  103500:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103507:	00 
  103508:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10350b:	89 04 24             	mov    %eax,(%esp)
  10350e:	e8 37 0a 00 00       	call   103f4a <free_pages>
    free_page(p1);
  103513:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10351a:	00 
  10351b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10351e:	89 04 24             	mov    %eax,(%esp)
  103521:	e8 24 0a 00 00       	call   103f4a <free_pages>
    free_page(p2);
  103526:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10352d:	00 
  10352e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103531:	89 04 24             	mov    %eax,(%esp)
  103534:	e8 11 0a 00 00       	call   103f4a <free_pages>
}
  103539:	90                   	nop
  10353a:	89 ec                	mov    %ebp,%esp
  10353c:	5d                   	pop    %ebp
  10353d:	c3                   	ret    

0010353e <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
  10353e:	55                   	push   %ebp
  10353f:	89 e5                	mov    %esp,%ebp
  103541:	81 ec 98 00 00 00    	sub    $0x98,%esp
    int count = 0, total = 0;
  103547:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  10354e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  103555:	c7 45 ec 80 ce 11 00 	movl   $0x11ce80,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  10355c:	eb 6a                	jmp    1035c8 <default_check+0x8a>
        struct Page *p = le2page(le, page_link);
  10355e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103561:	83 e8 0c             	sub    $0xc,%eax
  103564:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(PageProperty(p));
  103567:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10356a:	83 c0 04             	add    $0x4,%eax
  10356d:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  103574:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103577:	8b 45 cc             	mov    -0x34(%ebp),%eax
  10357a:	8b 55 d0             	mov    -0x30(%ebp),%edx
  10357d:	0f a3 10             	bt     %edx,(%eax)
  103580:	19 c0                	sbb    %eax,%eax
  103582:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
  103585:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  103589:	0f 95 c0             	setne  %al
  10358c:	0f b6 c0             	movzbl %al,%eax
  10358f:	85 c0                	test   %eax,%eax
  103591:	75 24                	jne    1035b7 <default_check+0x79>
  103593:	c7 44 24 0c 1e 6a 10 	movl   $0x106a1e,0xc(%esp)
  10359a:	00 
  10359b:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  1035a2:	00 
  1035a3:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
  1035aa:	00 
  1035ab:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  1035b2:	e8 4b d7 ff ff       	call   100d02 <__panic>
        count ++, total += p->property;
  1035b7:	ff 45 f4             	incl   -0xc(%ebp)
  1035ba:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1035bd:	8b 50 08             	mov    0x8(%eax),%edx
  1035c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1035c3:	01 d0                	add    %edx,%eax
  1035c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1035c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1035cb:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
  1035ce:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1035d1:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  1035d4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1035d7:	81 7d ec 80 ce 11 00 	cmpl   $0x11ce80,-0x14(%ebp)
  1035de:	0f 85 7a ff ff ff    	jne    10355e <default_check+0x20>
    }
    assert(total == nr_free_pages());
  1035e4:	e8 96 09 00 00       	call   103f7f <nr_free_pages>
  1035e9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1035ec:	39 d0                	cmp    %edx,%eax
  1035ee:	74 24                	je     103614 <default_check+0xd6>
  1035f0:	c7 44 24 0c 2e 6a 10 	movl   $0x106a2e,0xc(%esp)
  1035f7:	00 
  1035f8:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  1035ff:	00 
  103600:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
  103607:	00 
  103608:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  10360f:	e8 ee d6 ff ff       	call   100d02 <__panic>

    basic_check();
  103614:	e8 e5 f9 ff ff       	call   102ffe <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
  103619:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  103620:	e8 eb 08 00 00       	call   103f10 <alloc_pages>
  103625:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(p0 != NULL);
  103628:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10362c:	75 24                	jne    103652 <default_check+0x114>
  10362e:	c7 44 24 0c 47 6a 10 	movl   $0x106a47,0xc(%esp)
  103635:	00 
  103636:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  10363d:	00 
  10363e:	c7 44 24 04 08 01 00 	movl   $0x108,0x4(%esp)
  103645:	00 
  103646:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  10364d:	e8 b0 d6 ff ff       	call   100d02 <__panic>
    assert(!PageProperty(p0));
  103652:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103655:	83 c0 04             	add    $0x4,%eax
  103658:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  10365f:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103662:	8b 45 bc             	mov    -0x44(%ebp),%eax
  103665:	8b 55 c0             	mov    -0x40(%ebp),%edx
  103668:	0f a3 10             	bt     %edx,(%eax)
  10366b:	19 c0                	sbb    %eax,%eax
  10366d:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
  103670:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  103674:	0f 95 c0             	setne  %al
  103677:	0f b6 c0             	movzbl %al,%eax
  10367a:	85 c0                	test   %eax,%eax
  10367c:	74 24                	je     1036a2 <default_check+0x164>
  10367e:	c7 44 24 0c 52 6a 10 	movl   $0x106a52,0xc(%esp)
  103685:	00 
  103686:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  10368d:	00 
  10368e:	c7 44 24 04 09 01 00 	movl   $0x109,0x4(%esp)
  103695:	00 
  103696:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  10369d:	e8 60 d6 ff ff       	call   100d02 <__panic>

    list_entry_t free_list_store = free_list;
  1036a2:	a1 80 ce 11 00       	mov    0x11ce80,%eax
  1036a7:	8b 15 84 ce 11 00    	mov    0x11ce84,%edx
  1036ad:	89 45 80             	mov    %eax,-0x80(%ebp)
  1036b0:	89 55 84             	mov    %edx,-0x7c(%ebp)
  1036b3:	c7 45 b0 80 ce 11 00 	movl   $0x11ce80,-0x50(%ebp)
    elm->prev = elm->next = elm;
  1036ba:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1036bd:	8b 55 b0             	mov    -0x50(%ebp),%edx
  1036c0:	89 50 04             	mov    %edx,0x4(%eax)
  1036c3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1036c6:	8b 50 04             	mov    0x4(%eax),%edx
  1036c9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1036cc:	89 10                	mov    %edx,(%eax)
}
  1036ce:	90                   	nop
  1036cf:	c7 45 b4 80 ce 11 00 	movl   $0x11ce80,-0x4c(%ebp)
    return list->next == list;
  1036d6:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1036d9:	8b 40 04             	mov    0x4(%eax),%eax
  1036dc:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
  1036df:	0f 94 c0             	sete   %al
  1036e2:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  1036e5:	85 c0                	test   %eax,%eax
  1036e7:	75 24                	jne    10370d <default_check+0x1cf>
  1036e9:	c7 44 24 0c a7 69 10 	movl   $0x1069a7,0xc(%esp)
  1036f0:	00 
  1036f1:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  1036f8:	00 
  1036f9:	c7 44 24 04 0d 01 00 	movl   $0x10d,0x4(%esp)
  103700:	00 
  103701:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  103708:	e8 f5 d5 ff ff       	call   100d02 <__panic>
    assert(alloc_page() == NULL);
  10370d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103714:	e8 f7 07 00 00       	call   103f10 <alloc_pages>
  103719:	85 c0                	test   %eax,%eax
  10371b:	74 24                	je     103741 <default_check+0x203>
  10371d:	c7 44 24 0c be 69 10 	movl   $0x1069be,0xc(%esp)
  103724:	00 
  103725:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  10372c:	00 
  10372d:	c7 44 24 04 0e 01 00 	movl   $0x10e,0x4(%esp)
  103734:	00 
  103735:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  10373c:	e8 c1 d5 ff ff       	call   100d02 <__panic>

    unsigned int nr_free_store = nr_free;
  103741:	a1 88 ce 11 00       	mov    0x11ce88,%eax
  103746:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nr_free = 0;
  103749:	c7 05 88 ce 11 00 00 	movl   $0x0,0x11ce88
  103750:	00 00 00 

    free_pages(p0 + 2, 3);
  103753:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103756:	83 c0 28             	add    $0x28,%eax
  103759:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  103760:	00 
  103761:	89 04 24             	mov    %eax,(%esp)
  103764:	e8 e1 07 00 00       	call   103f4a <free_pages>
    assert(alloc_pages(4) == NULL);
  103769:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  103770:	e8 9b 07 00 00       	call   103f10 <alloc_pages>
  103775:	85 c0                	test   %eax,%eax
  103777:	74 24                	je     10379d <default_check+0x25f>
  103779:	c7 44 24 0c 64 6a 10 	movl   $0x106a64,0xc(%esp)
  103780:	00 
  103781:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  103788:	00 
  103789:	c7 44 24 04 14 01 00 	movl   $0x114,0x4(%esp)
  103790:	00 
  103791:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  103798:	e8 65 d5 ff ff       	call   100d02 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
  10379d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1037a0:	83 c0 28             	add    $0x28,%eax
  1037a3:	83 c0 04             	add    $0x4,%eax
  1037a6:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
  1037ad:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1037b0:	8b 45 a8             	mov    -0x58(%ebp),%eax
  1037b3:	8b 55 ac             	mov    -0x54(%ebp),%edx
  1037b6:	0f a3 10             	bt     %edx,(%eax)
  1037b9:	19 c0                	sbb    %eax,%eax
  1037bb:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
  1037be:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  1037c2:	0f 95 c0             	setne  %al
  1037c5:	0f b6 c0             	movzbl %al,%eax
  1037c8:	85 c0                	test   %eax,%eax
  1037ca:	74 0e                	je     1037da <default_check+0x29c>
  1037cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1037cf:	83 c0 28             	add    $0x28,%eax
  1037d2:	8b 40 08             	mov    0x8(%eax),%eax
  1037d5:	83 f8 03             	cmp    $0x3,%eax
  1037d8:	74 24                	je     1037fe <default_check+0x2c0>
  1037da:	c7 44 24 0c 7c 6a 10 	movl   $0x106a7c,0xc(%esp)
  1037e1:	00 
  1037e2:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  1037e9:	00 
  1037ea:	c7 44 24 04 15 01 00 	movl   $0x115,0x4(%esp)
  1037f1:	00 
  1037f2:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  1037f9:	e8 04 d5 ff ff       	call   100d02 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  1037fe:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  103805:	e8 06 07 00 00       	call   103f10 <alloc_pages>
  10380a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10380d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  103811:	75 24                	jne    103837 <default_check+0x2f9>
  103813:	c7 44 24 0c a8 6a 10 	movl   $0x106aa8,0xc(%esp)
  10381a:	00 
  10381b:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  103822:	00 
  103823:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
  10382a:	00 
  10382b:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  103832:	e8 cb d4 ff ff       	call   100d02 <__panic>
    assert(alloc_page() == NULL);
  103837:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10383e:	e8 cd 06 00 00       	call   103f10 <alloc_pages>
  103843:	85 c0                	test   %eax,%eax
  103845:	74 24                	je     10386b <default_check+0x32d>
  103847:	c7 44 24 0c be 69 10 	movl   $0x1069be,0xc(%esp)
  10384e:	00 
  10384f:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  103856:	00 
  103857:	c7 44 24 04 17 01 00 	movl   $0x117,0x4(%esp)
  10385e:	00 
  10385f:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  103866:	e8 97 d4 ff ff       	call   100d02 <__panic>
    assert(p0 + 2 == p1);
  10386b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10386e:	83 c0 28             	add    $0x28,%eax
  103871:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  103874:	74 24                	je     10389a <default_check+0x35c>
  103876:	c7 44 24 0c c6 6a 10 	movl   $0x106ac6,0xc(%esp)
  10387d:	00 
  10387e:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  103885:	00 
  103886:	c7 44 24 04 18 01 00 	movl   $0x118,0x4(%esp)
  10388d:	00 
  10388e:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  103895:	e8 68 d4 ff ff       	call   100d02 <__panic>

    p2 = p0 + 1;
  10389a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10389d:	83 c0 14             	add    $0x14,%eax
  1038a0:	89 45 dc             	mov    %eax,-0x24(%ebp)
    free_page(p0);
  1038a3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1038aa:	00 
  1038ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1038ae:	89 04 24             	mov    %eax,(%esp)
  1038b1:	e8 94 06 00 00       	call   103f4a <free_pages>
    free_pages(p1, 3);
  1038b6:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  1038bd:	00 
  1038be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1038c1:	89 04 24             	mov    %eax,(%esp)
  1038c4:	e8 81 06 00 00       	call   103f4a <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
  1038c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1038cc:	83 c0 04             	add    $0x4,%eax
  1038cf:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
  1038d6:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1038d9:	8b 45 9c             	mov    -0x64(%ebp),%eax
  1038dc:	8b 55 a0             	mov    -0x60(%ebp),%edx
  1038df:	0f a3 10             	bt     %edx,(%eax)
  1038e2:	19 c0                	sbb    %eax,%eax
  1038e4:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
  1038e7:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  1038eb:	0f 95 c0             	setne  %al
  1038ee:	0f b6 c0             	movzbl %al,%eax
  1038f1:	85 c0                	test   %eax,%eax
  1038f3:	74 0b                	je     103900 <default_check+0x3c2>
  1038f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1038f8:	8b 40 08             	mov    0x8(%eax),%eax
  1038fb:	83 f8 01             	cmp    $0x1,%eax
  1038fe:	74 24                	je     103924 <default_check+0x3e6>
  103900:	c7 44 24 0c d4 6a 10 	movl   $0x106ad4,0xc(%esp)
  103907:	00 
  103908:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  10390f:	00 
  103910:	c7 44 24 04 1d 01 00 	movl   $0x11d,0x4(%esp)
  103917:	00 
  103918:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  10391f:	e8 de d3 ff ff       	call   100d02 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
  103924:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103927:	83 c0 04             	add    $0x4,%eax
  10392a:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
  103931:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103934:	8b 45 90             	mov    -0x70(%ebp),%eax
  103937:	8b 55 94             	mov    -0x6c(%ebp),%edx
  10393a:	0f a3 10             	bt     %edx,(%eax)
  10393d:	19 c0                	sbb    %eax,%eax
  10393f:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
  103942:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
  103946:	0f 95 c0             	setne  %al
  103949:	0f b6 c0             	movzbl %al,%eax
  10394c:	85 c0                	test   %eax,%eax
  10394e:	74 0b                	je     10395b <default_check+0x41d>
  103950:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103953:	8b 40 08             	mov    0x8(%eax),%eax
  103956:	83 f8 03             	cmp    $0x3,%eax
  103959:	74 24                	je     10397f <default_check+0x441>
  10395b:	c7 44 24 0c fc 6a 10 	movl   $0x106afc,0xc(%esp)
  103962:	00 
  103963:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  10396a:	00 
  10396b:	c7 44 24 04 1e 01 00 	movl   $0x11e,0x4(%esp)
  103972:	00 
  103973:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  10397a:	e8 83 d3 ff ff       	call   100d02 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
  10397f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103986:	e8 85 05 00 00       	call   103f10 <alloc_pages>
  10398b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10398e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103991:	83 e8 14             	sub    $0x14,%eax
  103994:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  103997:	74 24                	je     1039bd <default_check+0x47f>
  103999:	c7 44 24 0c 22 6b 10 	movl   $0x106b22,0xc(%esp)
  1039a0:	00 
  1039a1:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  1039a8:	00 
  1039a9:	c7 44 24 04 20 01 00 	movl   $0x120,0x4(%esp)
  1039b0:	00 
  1039b1:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  1039b8:	e8 45 d3 ff ff       	call   100d02 <__panic>
    free_page(p0);
  1039bd:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1039c4:	00 
  1039c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1039c8:	89 04 24             	mov    %eax,(%esp)
  1039cb:	e8 7a 05 00 00       	call   103f4a <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
  1039d0:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1039d7:	e8 34 05 00 00       	call   103f10 <alloc_pages>
  1039dc:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1039df:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1039e2:	83 c0 14             	add    $0x14,%eax
  1039e5:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  1039e8:	74 24                	je     103a0e <default_check+0x4d0>
  1039ea:	c7 44 24 0c 40 6b 10 	movl   $0x106b40,0xc(%esp)
  1039f1:	00 
  1039f2:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  1039f9:	00 
  1039fa:	c7 44 24 04 22 01 00 	movl   $0x122,0x4(%esp)
  103a01:	00 
  103a02:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  103a09:	e8 f4 d2 ff ff       	call   100d02 <__panic>

    free_pages(p0, 2);
  103a0e:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  103a15:	00 
  103a16:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103a19:	89 04 24             	mov    %eax,(%esp)
  103a1c:	e8 29 05 00 00       	call   103f4a <free_pages>
    free_page(p2);
  103a21:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103a28:	00 
  103a29:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103a2c:	89 04 24             	mov    %eax,(%esp)
  103a2f:	e8 16 05 00 00       	call   103f4a <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
  103a34:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  103a3b:	e8 d0 04 00 00       	call   103f10 <alloc_pages>
  103a40:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103a43:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103a47:	75 24                	jne    103a6d <default_check+0x52f>
  103a49:	c7 44 24 0c 60 6b 10 	movl   $0x106b60,0xc(%esp)
  103a50:	00 
  103a51:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  103a58:	00 
  103a59:	c7 44 24 04 27 01 00 	movl   $0x127,0x4(%esp)
  103a60:	00 
  103a61:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  103a68:	e8 95 d2 ff ff       	call   100d02 <__panic>
    assert(alloc_page() == NULL);
  103a6d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103a74:	e8 97 04 00 00       	call   103f10 <alloc_pages>
  103a79:	85 c0                	test   %eax,%eax
  103a7b:	74 24                	je     103aa1 <default_check+0x563>
  103a7d:	c7 44 24 0c be 69 10 	movl   $0x1069be,0xc(%esp)
  103a84:	00 
  103a85:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  103a8c:	00 
  103a8d:	c7 44 24 04 28 01 00 	movl   $0x128,0x4(%esp)
  103a94:	00 
  103a95:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  103a9c:	e8 61 d2 ff ff       	call   100d02 <__panic>

    assert(nr_free == 0);
  103aa1:	a1 88 ce 11 00       	mov    0x11ce88,%eax
  103aa6:	85 c0                	test   %eax,%eax
  103aa8:	74 24                	je     103ace <default_check+0x590>
  103aaa:	c7 44 24 0c 11 6a 10 	movl   $0x106a11,0xc(%esp)
  103ab1:	00 
  103ab2:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  103ab9:	00 
  103aba:	c7 44 24 04 2a 01 00 	movl   $0x12a,0x4(%esp)
  103ac1:	00 
  103ac2:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  103ac9:	e8 34 d2 ff ff       	call   100d02 <__panic>
    nr_free = nr_free_store;
  103ace:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103ad1:	a3 88 ce 11 00       	mov    %eax,0x11ce88

    free_list = free_list_store;
  103ad6:	8b 45 80             	mov    -0x80(%ebp),%eax
  103ad9:	8b 55 84             	mov    -0x7c(%ebp),%edx
  103adc:	a3 80 ce 11 00       	mov    %eax,0x11ce80
  103ae1:	89 15 84 ce 11 00    	mov    %edx,0x11ce84
    free_pages(p0, 5);
  103ae7:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  103aee:	00 
  103aef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103af2:	89 04 24             	mov    %eax,(%esp)
  103af5:	e8 50 04 00 00       	call   103f4a <free_pages>

    le = &free_list;
  103afa:	c7 45 ec 80 ce 11 00 	movl   $0x11ce80,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  103b01:	eb 5a                	jmp    103b5d <default_check+0x61f>
        assert(le->next->prev == le && le->prev->next == le);
  103b03:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103b06:	8b 40 04             	mov    0x4(%eax),%eax
  103b09:	8b 00                	mov    (%eax),%eax
  103b0b:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  103b0e:	75 0d                	jne    103b1d <default_check+0x5df>
  103b10:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103b13:	8b 00                	mov    (%eax),%eax
  103b15:	8b 40 04             	mov    0x4(%eax),%eax
  103b18:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  103b1b:	74 24                	je     103b41 <default_check+0x603>
  103b1d:	c7 44 24 0c 80 6b 10 	movl   $0x106b80,0xc(%esp)
  103b24:	00 
  103b25:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  103b2c:	00 
  103b2d:	c7 44 24 04 32 01 00 	movl   $0x132,0x4(%esp)
  103b34:	00 
  103b35:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  103b3c:	e8 c1 d1 ff ff       	call   100d02 <__panic>
        struct Page *p = le2page(le, page_link);
  103b41:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103b44:	83 e8 0c             	sub    $0xc,%eax
  103b47:	89 45 d8             	mov    %eax,-0x28(%ebp)
        count --, total -= p->property;
  103b4a:	ff 4d f4             	decl   -0xc(%ebp)
  103b4d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103b50:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103b53:	8b 48 08             	mov    0x8(%eax),%ecx
  103b56:	89 d0                	mov    %edx,%eax
  103b58:	29 c8                	sub    %ecx,%eax
  103b5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103b5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103b60:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
  103b63:	8b 45 88             	mov    -0x78(%ebp),%eax
  103b66:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  103b69:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103b6c:	81 7d ec 80 ce 11 00 	cmpl   $0x11ce80,-0x14(%ebp)
  103b73:	75 8e                	jne    103b03 <default_check+0x5c5>
    }
    assert(count == 0);
  103b75:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103b79:	74 24                	je     103b9f <default_check+0x661>
  103b7b:	c7 44 24 0c ad 6b 10 	movl   $0x106bad,0xc(%esp)
  103b82:	00 
  103b83:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  103b8a:	00 
  103b8b:	c7 44 24 04 36 01 00 	movl   $0x136,0x4(%esp)
  103b92:	00 
  103b93:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  103b9a:	e8 63 d1 ff ff       	call   100d02 <__panic>
    assert(total == 0);
  103b9f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103ba3:	74 24                	je     103bc9 <default_check+0x68b>
  103ba5:	c7 44 24 0c b8 6b 10 	movl   $0x106bb8,0xc(%esp)
  103bac:	00 
  103bad:	c7 44 24 08 36 68 10 	movl   $0x106836,0x8(%esp)
  103bb4:	00 
  103bb5:	c7 44 24 04 37 01 00 	movl   $0x137,0x4(%esp)
  103bbc:	00 
  103bbd:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  103bc4:	e8 39 d1 ff ff       	call   100d02 <__panic>
}
  103bc9:	90                   	nop
  103bca:	89 ec                	mov    %ebp,%esp
  103bcc:	5d                   	pop    %ebp
  103bcd:	c3                   	ret    

00103bce <page2ppn>:
page2ppn(struct Page *page) {
  103bce:	55                   	push   %ebp
  103bcf:	89 e5                	mov    %esp,%ebp
    return page - pages;
  103bd1:	8b 15 a0 ce 11 00    	mov    0x11cea0,%edx
  103bd7:	8b 45 08             	mov    0x8(%ebp),%eax
  103bda:	29 d0                	sub    %edx,%eax
  103bdc:	c1 f8 02             	sar    $0x2,%eax
  103bdf:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  103be5:	5d                   	pop    %ebp
  103be6:	c3                   	ret    

00103be7 <page2pa>:
page2pa(struct Page *page) {
  103be7:	55                   	push   %ebp
  103be8:	89 e5                	mov    %esp,%ebp
  103bea:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  103bed:	8b 45 08             	mov    0x8(%ebp),%eax
  103bf0:	89 04 24             	mov    %eax,(%esp)
  103bf3:	e8 d6 ff ff ff       	call   103bce <page2ppn>
  103bf8:	c1 e0 0c             	shl    $0xc,%eax
}
  103bfb:	89 ec                	mov    %ebp,%esp
  103bfd:	5d                   	pop    %ebp
  103bfe:	c3                   	ret    

00103bff <pa2page>:
pa2page(uintptr_t pa) {
  103bff:	55                   	push   %ebp
  103c00:	89 e5                	mov    %esp,%ebp
  103c02:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
  103c05:	8b 45 08             	mov    0x8(%ebp),%eax
  103c08:	c1 e8 0c             	shr    $0xc,%eax
  103c0b:	89 c2                	mov    %eax,%edx
  103c0d:	a1 a4 ce 11 00       	mov    0x11cea4,%eax
  103c12:	39 c2                	cmp    %eax,%edx
  103c14:	72 1c                	jb     103c32 <pa2page+0x33>
        panic("pa2page called with invalid pa");
  103c16:	c7 44 24 08 f4 6b 10 	movl   $0x106bf4,0x8(%esp)
  103c1d:	00 
  103c1e:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  103c25:	00 
  103c26:	c7 04 24 13 6c 10 00 	movl   $0x106c13,(%esp)
  103c2d:	e8 d0 d0 ff ff       	call   100d02 <__panic>
    return &pages[PPN(pa)];
  103c32:	8b 0d a0 ce 11 00    	mov    0x11cea0,%ecx
  103c38:	8b 45 08             	mov    0x8(%ebp),%eax
  103c3b:	c1 e8 0c             	shr    $0xc,%eax
  103c3e:	89 c2                	mov    %eax,%edx
  103c40:	89 d0                	mov    %edx,%eax
  103c42:	c1 e0 02             	shl    $0x2,%eax
  103c45:	01 d0                	add    %edx,%eax
  103c47:	c1 e0 02             	shl    $0x2,%eax
  103c4a:	01 c8                	add    %ecx,%eax
}
  103c4c:	89 ec                	mov    %ebp,%esp
  103c4e:	5d                   	pop    %ebp
  103c4f:	c3                   	ret    

00103c50 <page2kva>:
page2kva(struct Page *page) {
  103c50:	55                   	push   %ebp
  103c51:	89 e5                	mov    %esp,%ebp
  103c53:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
  103c56:	8b 45 08             	mov    0x8(%ebp),%eax
  103c59:	89 04 24             	mov    %eax,(%esp)
  103c5c:	e8 86 ff ff ff       	call   103be7 <page2pa>
  103c61:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103c64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103c67:	c1 e8 0c             	shr    $0xc,%eax
  103c6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103c6d:	a1 a4 ce 11 00       	mov    0x11cea4,%eax
  103c72:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  103c75:	72 23                	jb     103c9a <page2kva+0x4a>
  103c77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103c7a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103c7e:	c7 44 24 08 24 6c 10 	movl   $0x106c24,0x8(%esp)
  103c85:	00 
  103c86:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  103c8d:	00 
  103c8e:	c7 04 24 13 6c 10 00 	movl   $0x106c13,(%esp)
  103c95:	e8 68 d0 ff ff       	call   100d02 <__panic>
  103c9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103c9d:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  103ca2:	89 ec                	mov    %ebp,%esp
  103ca4:	5d                   	pop    %ebp
  103ca5:	c3                   	ret    

00103ca6 <pte2page>:
pte2page(pte_t pte) {
  103ca6:	55                   	push   %ebp
  103ca7:	89 e5                	mov    %esp,%ebp
  103ca9:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
  103cac:	8b 45 08             	mov    0x8(%ebp),%eax
  103caf:	83 e0 01             	and    $0x1,%eax
  103cb2:	85 c0                	test   %eax,%eax
  103cb4:	75 1c                	jne    103cd2 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
  103cb6:	c7 44 24 08 48 6c 10 	movl   $0x106c48,0x8(%esp)
  103cbd:	00 
  103cbe:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
  103cc5:	00 
  103cc6:	c7 04 24 13 6c 10 00 	movl   $0x106c13,(%esp)
  103ccd:	e8 30 d0 ff ff       	call   100d02 <__panic>
    return pa2page(PTE_ADDR(pte));
  103cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  103cd5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103cda:	89 04 24             	mov    %eax,(%esp)
  103cdd:	e8 1d ff ff ff       	call   103bff <pa2page>
}
  103ce2:	89 ec                	mov    %ebp,%esp
  103ce4:	5d                   	pop    %ebp
  103ce5:	c3                   	ret    

00103ce6 <pde2page>:
pde2page(pde_t pde) {
  103ce6:	55                   	push   %ebp
  103ce7:	89 e5                	mov    %esp,%ebp
  103ce9:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
  103cec:	8b 45 08             	mov    0x8(%ebp),%eax
  103cef:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103cf4:	89 04 24             	mov    %eax,(%esp)
  103cf7:	e8 03 ff ff ff       	call   103bff <pa2page>
}
  103cfc:	89 ec                	mov    %ebp,%esp
  103cfe:	5d                   	pop    %ebp
  103cff:	c3                   	ret    

00103d00 <page_ref>:
page_ref(struct Page *page) {
  103d00:	55                   	push   %ebp
  103d01:	89 e5                	mov    %esp,%ebp
    return page->ref;
  103d03:	8b 45 08             	mov    0x8(%ebp),%eax
  103d06:	8b 00                	mov    (%eax),%eax
}
  103d08:	5d                   	pop    %ebp
  103d09:	c3                   	ret    

00103d0a <set_page_ref>:
set_page_ref(struct Page *page, int val) {
  103d0a:	55                   	push   %ebp
  103d0b:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  103d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  103d10:	8b 55 0c             	mov    0xc(%ebp),%edx
  103d13:	89 10                	mov    %edx,(%eax)
}
  103d15:	90                   	nop
  103d16:	5d                   	pop    %ebp
  103d17:	c3                   	ret    

00103d18 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
  103d18:	55                   	push   %ebp
  103d19:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
  103d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  103d1e:	8b 00                	mov    (%eax),%eax
  103d20:	8d 50 01             	lea    0x1(%eax),%edx
  103d23:	8b 45 08             	mov    0x8(%ebp),%eax
  103d26:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103d28:	8b 45 08             	mov    0x8(%ebp),%eax
  103d2b:	8b 00                	mov    (%eax),%eax
}
  103d2d:	5d                   	pop    %ebp
  103d2e:	c3                   	ret    

00103d2f <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
  103d2f:	55                   	push   %ebp
  103d30:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
  103d32:	8b 45 08             	mov    0x8(%ebp),%eax
  103d35:	8b 00                	mov    (%eax),%eax
  103d37:	8d 50 ff             	lea    -0x1(%eax),%edx
  103d3a:	8b 45 08             	mov    0x8(%ebp),%eax
  103d3d:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  103d42:	8b 00                	mov    (%eax),%eax
}
  103d44:	5d                   	pop    %ebp
  103d45:	c3                   	ret    

00103d46 <__intr_save>:
__intr_save(void) {
  103d46:	55                   	push   %ebp
  103d47:	89 e5                	mov    %esp,%ebp
  103d49:	83 ec 18             	sub    $0x18,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  103d4c:	9c                   	pushf  
  103d4d:	58                   	pop    %eax
  103d4e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  103d51:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  103d54:	25 00 02 00 00       	and    $0x200,%eax
  103d59:	85 c0                	test   %eax,%eax
  103d5b:	74 0c                	je     103d69 <__intr_save+0x23>
        intr_disable();
  103d5d:	e8 f9 d9 ff ff       	call   10175b <intr_disable>
        return 1;
  103d62:	b8 01 00 00 00       	mov    $0x1,%eax
  103d67:	eb 05                	jmp    103d6e <__intr_save+0x28>
    return 0;
  103d69:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103d6e:	89 ec                	mov    %ebp,%esp
  103d70:	5d                   	pop    %ebp
  103d71:	c3                   	ret    

00103d72 <__intr_restore>:
__intr_restore(bool flag) {
  103d72:	55                   	push   %ebp
  103d73:	89 e5                	mov    %esp,%ebp
  103d75:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  103d78:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103d7c:	74 05                	je     103d83 <__intr_restore+0x11>
        intr_enable();
  103d7e:	e8 d0 d9 ff ff       	call   101753 <intr_enable>
}
  103d83:	90                   	nop
  103d84:	89 ec                	mov    %ebp,%esp
  103d86:	5d                   	pop    %ebp
  103d87:	c3                   	ret    

00103d88 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  103d88:	55                   	push   %ebp
  103d89:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  103d8b:	8b 45 08             	mov    0x8(%ebp),%eax
  103d8e:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  103d91:	b8 23 00 00 00       	mov    $0x23,%eax
  103d96:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  103d98:	b8 23 00 00 00       	mov    $0x23,%eax
  103d9d:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  103d9f:	b8 10 00 00 00       	mov    $0x10,%eax
  103da4:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  103da6:	b8 10 00 00 00       	mov    $0x10,%eax
  103dab:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  103dad:	b8 10 00 00 00       	mov    $0x10,%eax
  103db2:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  103db4:	ea bb 3d 10 00 08 00 	ljmp   $0x8,$0x103dbb
}
  103dbb:	90                   	nop
  103dbc:	5d                   	pop    %ebp
  103dbd:	c3                   	ret    

00103dbe <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
  103dbe:	55                   	push   %ebp
  103dbf:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
  103dc1:	8b 45 08             	mov    0x8(%ebp),%eax
  103dc4:	a3 c4 ce 11 00       	mov    %eax,0x11cec4
}
  103dc9:	90                   	nop
  103dca:	5d                   	pop    %ebp
  103dcb:	c3                   	ret    

00103dcc <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  103dcc:	55                   	push   %ebp
  103dcd:	89 e5                	mov    %esp,%ebp
  103dcf:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
  103dd2:	b8 00 90 11 00       	mov    $0x119000,%eax
  103dd7:	89 04 24             	mov    %eax,(%esp)
  103dda:	e8 df ff ff ff       	call   103dbe <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
  103ddf:	66 c7 05 c8 ce 11 00 	movw   $0x10,0x11cec8
  103de6:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
  103de8:	66 c7 05 28 9a 11 00 	movw   $0x68,0x119a28
  103def:	68 00 
  103df1:	b8 c0 ce 11 00       	mov    $0x11cec0,%eax
  103df6:	0f b7 c0             	movzwl %ax,%eax
  103df9:	66 a3 2a 9a 11 00    	mov    %ax,0x119a2a
  103dff:	b8 c0 ce 11 00       	mov    $0x11cec0,%eax
  103e04:	c1 e8 10             	shr    $0x10,%eax
  103e07:	a2 2c 9a 11 00       	mov    %al,0x119a2c
  103e0c:	0f b6 05 2d 9a 11 00 	movzbl 0x119a2d,%eax
  103e13:	24 f0                	and    $0xf0,%al
  103e15:	0c 09                	or     $0x9,%al
  103e17:	a2 2d 9a 11 00       	mov    %al,0x119a2d
  103e1c:	0f b6 05 2d 9a 11 00 	movzbl 0x119a2d,%eax
  103e23:	24 ef                	and    $0xef,%al
  103e25:	a2 2d 9a 11 00       	mov    %al,0x119a2d
  103e2a:	0f b6 05 2d 9a 11 00 	movzbl 0x119a2d,%eax
  103e31:	24 9f                	and    $0x9f,%al
  103e33:	a2 2d 9a 11 00       	mov    %al,0x119a2d
  103e38:	0f b6 05 2d 9a 11 00 	movzbl 0x119a2d,%eax
  103e3f:	0c 80                	or     $0x80,%al
  103e41:	a2 2d 9a 11 00       	mov    %al,0x119a2d
  103e46:	0f b6 05 2e 9a 11 00 	movzbl 0x119a2e,%eax
  103e4d:	24 f0                	and    $0xf0,%al
  103e4f:	a2 2e 9a 11 00       	mov    %al,0x119a2e
  103e54:	0f b6 05 2e 9a 11 00 	movzbl 0x119a2e,%eax
  103e5b:	24 ef                	and    $0xef,%al
  103e5d:	a2 2e 9a 11 00       	mov    %al,0x119a2e
  103e62:	0f b6 05 2e 9a 11 00 	movzbl 0x119a2e,%eax
  103e69:	24 df                	and    $0xdf,%al
  103e6b:	a2 2e 9a 11 00       	mov    %al,0x119a2e
  103e70:	0f b6 05 2e 9a 11 00 	movzbl 0x119a2e,%eax
  103e77:	0c 40                	or     $0x40,%al
  103e79:	a2 2e 9a 11 00       	mov    %al,0x119a2e
  103e7e:	0f b6 05 2e 9a 11 00 	movzbl 0x119a2e,%eax
  103e85:	24 7f                	and    $0x7f,%al
  103e87:	a2 2e 9a 11 00       	mov    %al,0x119a2e
  103e8c:	b8 c0 ce 11 00       	mov    $0x11cec0,%eax
  103e91:	c1 e8 18             	shr    $0x18,%eax
  103e94:	a2 2f 9a 11 00       	mov    %al,0x119a2f

    // reload all segment registers
    lgdt(&gdt_pd);
  103e99:	c7 04 24 30 9a 11 00 	movl   $0x119a30,(%esp)
  103ea0:	e8 e3 fe ff ff       	call   103d88 <lgdt>
  103ea5:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
  103eab:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  103eaf:	0f 00 d8             	ltr    %ax
}
  103eb2:	90                   	nop

    // load the TSS
    ltr(GD_TSS);
}
  103eb3:	90                   	nop
  103eb4:	89 ec                	mov    %ebp,%esp
  103eb6:	5d                   	pop    %ebp
  103eb7:	c3                   	ret    

00103eb8 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
  103eb8:	55                   	push   %ebp
  103eb9:	89 e5                	mov    %esp,%ebp
  103ebb:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
  103ebe:	c7 05 ac ce 11 00 d8 	movl   $0x106bd8,0x11ceac
  103ec5:	6b 10 00 
    cprintf("memory management: %s\n", pmm_manager->name);
  103ec8:	a1 ac ce 11 00       	mov    0x11ceac,%eax
  103ecd:	8b 00                	mov    (%eax),%eax
  103ecf:	89 44 24 04          	mov    %eax,0x4(%esp)
  103ed3:	c7 04 24 74 6c 10 00 	movl   $0x106c74,(%esp)
  103eda:	e8 82 c4 ff ff       	call   100361 <cprintf>
    pmm_manager->init();
  103edf:	a1 ac ce 11 00       	mov    0x11ceac,%eax
  103ee4:	8b 40 04             	mov    0x4(%eax),%eax
  103ee7:	ff d0                	call   *%eax
}
  103ee9:	90                   	nop
  103eea:	89 ec                	mov    %ebp,%esp
  103eec:	5d                   	pop    %ebp
  103eed:	c3                   	ret    

00103eee <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
  103eee:	55                   	push   %ebp
  103eef:	89 e5                	mov    %esp,%ebp
  103ef1:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
  103ef4:	a1 ac ce 11 00       	mov    0x11ceac,%eax
  103ef9:	8b 40 08             	mov    0x8(%eax),%eax
  103efc:	8b 55 0c             	mov    0xc(%ebp),%edx
  103eff:	89 54 24 04          	mov    %edx,0x4(%esp)
  103f03:	8b 55 08             	mov    0x8(%ebp),%edx
  103f06:	89 14 24             	mov    %edx,(%esp)
  103f09:	ff d0                	call   *%eax
}
  103f0b:	90                   	nop
  103f0c:	89 ec                	mov    %ebp,%esp
  103f0e:	5d                   	pop    %ebp
  103f0f:	c3                   	ret    

00103f10 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
  103f10:	55                   	push   %ebp
  103f11:	89 e5                	mov    %esp,%ebp
  103f13:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
  103f16:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  103f1d:	e8 24 fe ff ff       	call   103d46 <__intr_save>
  103f22:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
  103f25:	a1 ac ce 11 00       	mov    0x11ceac,%eax
  103f2a:	8b 40 0c             	mov    0xc(%eax),%eax
  103f2d:	8b 55 08             	mov    0x8(%ebp),%edx
  103f30:	89 14 24             	mov    %edx,(%esp)
  103f33:	ff d0                	call   *%eax
  103f35:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
  103f38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103f3b:	89 04 24             	mov    %eax,(%esp)
  103f3e:	e8 2f fe ff ff       	call   103d72 <__intr_restore>
    return page;
  103f43:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103f46:	89 ec                	mov    %ebp,%esp
  103f48:	5d                   	pop    %ebp
  103f49:	c3                   	ret    

00103f4a <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
  103f4a:	55                   	push   %ebp
  103f4b:	89 e5                	mov    %esp,%ebp
  103f4d:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  103f50:	e8 f1 fd ff ff       	call   103d46 <__intr_save>
  103f55:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
  103f58:	a1 ac ce 11 00       	mov    0x11ceac,%eax
  103f5d:	8b 40 10             	mov    0x10(%eax),%eax
  103f60:	8b 55 0c             	mov    0xc(%ebp),%edx
  103f63:	89 54 24 04          	mov    %edx,0x4(%esp)
  103f67:	8b 55 08             	mov    0x8(%ebp),%edx
  103f6a:	89 14 24             	mov    %edx,(%esp)
  103f6d:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
  103f6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103f72:	89 04 24             	mov    %eax,(%esp)
  103f75:	e8 f8 fd ff ff       	call   103d72 <__intr_restore>
}
  103f7a:	90                   	nop
  103f7b:	89 ec                	mov    %ebp,%esp
  103f7d:	5d                   	pop    %ebp
  103f7e:	c3                   	ret    

00103f7f <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
  103f7f:	55                   	push   %ebp
  103f80:	89 e5                	mov    %esp,%ebp
  103f82:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
  103f85:	e8 bc fd ff ff       	call   103d46 <__intr_save>
  103f8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
  103f8d:	a1 ac ce 11 00       	mov    0x11ceac,%eax
  103f92:	8b 40 14             	mov    0x14(%eax),%eax
  103f95:	ff d0                	call   *%eax
  103f97:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
  103f9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103f9d:	89 04 24             	mov    %eax,(%esp)
  103fa0:	e8 cd fd ff ff       	call   103d72 <__intr_restore>
    return ret;
  103fa5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  103fa8:	89 ec                	mov    %ebp,%esp
  103faa:	5d                   	pop    %ebp
  103fab:	c3                   	ret    

00103fac <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
  103fac:	55                   	push   %ebp
  103fad:	89 e5                	mov    %esp,%ebp
  103faf:	57                   	push   %edi
  103fb0:	56                   	push   %esi
  103fb1:	53                   	push   %ebx
  103fb2:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
  103fb8:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
  103fbf:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  103fc6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
  103fcd:	c7 04 24 8b 6c 10 00 	movl   $0x106c8b,(%esp)
  103fd4:	e8 88 c3 ff ff       	call   100361 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  103fd9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103fe0:	e9 0c 01 00 00       	jmp    1040f1 <page_init+0x145>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  103fe5:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103fe8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103feb:	89 d0                	mov    %edx,%eax
  103fed:	c1 e0 02             	shl    $0x2,%eax
  103ff0:	01 d0                	add    %edx,%eax
  103ff2:	c1 e0 02             	shl    $0x2,%eax
  103ff5:	01 c8                	add    %ecx,%eax
  103ff7:	8b 50 08             	mov    0x8(%eax),%edx
  103ffa:	8b 40 04             	mov    0x4(%eax),%eax
  103ffd:	89 45 a0             	mov    %eax,-0x60(%ebp)
  104000:	89 55 a4             	mov    %edx,-0x5c(%ebp)
  104003:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104006:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104009:	89 d0                	mov    %edx,%eax
  10400b:	c1 e0 02             	shl    $0x2,%eax
  10400e:	01 d0                	add    %edx,%eax
  104010:	c1 e0 02             	shl    $0x2,%eax
  104013:	01 c8                	add    %ecx,%eax
  104015:	8b 48 0c             	mov    0xc(%eax),%ecx
  104018:	8b 58 10             	mov    0x10(%eax),%ebx
  10401b:	8b 45 a0             	mov    -0x60(%ebp),%eax
  10401e:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  104021:	01 c8                	add    %ecx,%eax
  104023:	11 da                	adc    %ebx,%edx
  104025:	89 45 98             	mov    %eax,-0x68(%ebp)
  104028:	89 55 9c             	mov    %edx,-0x64(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  10402b:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  10402e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104031:	89 d0                	mov    %edx,%eax
  104033:	c1 e0 02             	shl    $0x2,%eax
  104036:	01 d0                	add    %edx,%eax
  104038:	c1 e0 02             	shl    $0x2,%eax
  10403b:	01 c8                	add    %ecx,%eax
  10403d:	83 c0 14             	add    $0x14,%eax
  104040:	8b 00                	mov    (%eax),%eax
  104042:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  104048:	8b 45 98             	mov    -0x68(%ebp),%eax
  10404b:	8b 55 9c             	mov    -0x64(%ebp),%edx
  10404e:	83 c0 ff             	add    $0xffffffff,%eax
  104051:	83 d2 ff             	adc    $0xffffffff,%edx
  104054:	89 c6                	mov    %eax,%esi
  104056:	89 d7                	mov    %edx,%edi
  104058:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  10405b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10405e:	89 d0                	mov    %edx,%eax
  104060:	c1 e0 02             	shl    $0x2,%eax
  104063:	01 d0                	add    %edx,%eax
  104065:	c1 e0 02             	shl    $0x2,%eax
  104068:	01 c8                	add    %ecx,%eax
  10406a:	8b 48 0c             	mov    0xc(%eax),%ecx
  10406d:	8b 58 10             	mov    0x10(%eax),%ebx
  104070:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  104076:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  10407a:	89 74 24 14          	mov    %esi,0x14(%esp)
  10407e:	89 7c 24 18          	mov    %edi,0x18(%esp)
  104082:	8b 45 a0             	mov    -0x60(%ebp),%eax
  104085:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  104088:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10408c:	89 54 24 10          	mov    %edx,0x10(%esp)
  104090:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  104094:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  104098:	c7 04 24 98 6c 10 00 	movl   $0x106c98,(%esp)
  10409f:	e8 bd c2 ff ff       	call   100361 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
  1040a4:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  1040a7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1040aa:	89 d0                	mov    %edx,%eax
  1040ac:	c1 e0 02             	shl    $0x2,%eax
  1040af:	01 d0                	add    %edx,%eax
  1040b1:	c1 e0 02             	shl    $0x2,%eax
  1040b4:	01 c8                	add    %ecx,%eax
  1040b6:	83 c0 14             	add    $0x14,%eax
  1040b9:	8b 00                	mov    (%eax),%eax
  1040bb:	83 f8 01             	cmp    $0x1,%eax
  1040be:	75 2e                	jne    1040ee <page_init+0x142>
            if (maxpa < end && begin < KMEMSIZE) {
  1040c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1040c3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1040c6:	3b 45 98             	cmp    -0x68(%ebp),%eax
  1040c9:	89 d0                	mov    %edx,%eax
  1040cb:	1b 45 9c             	sbb    -0x64(%ebp),%eax
  1040ce:	73 1e                	jae    1040ee <page_init+0x142>
  1040d0:	ba ff ff ff 37       	mov    $0x37ffffff,%edx
  1040d5:	b8 00 00 00 00       	mov    $0x0,%eax
  1040da:	3b 55 a0             	cmp    -0x60(%ebp),%edx
  1040dd:	1b 45 a4             	sbb    -0x5c(%ebp),%eax
  1040e0:	72 0c                	jb     1040ee <page_init+0x142>
                maxpa = end;
  1040e2:	8b 45 98             	mov    -0x68(%ebp),%eax
  1040e5:	8b 55 9c             	mov    -0x64(%ebp),%edx
  1040e8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1040eb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i ++) {
  1040ee:	ff 45 dc             	incl   -0x24(%ebp)
  1040f1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1040f4:	8b 00                	mov    (%eax),%eax
  1040f6:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  1040f9:	0f 8c e6 fe ff ff    	jl     103fe5 <page_init+0x39>
            }
        }
    }
    if (maxpa > KMEMSIZE) {
  1040ff:	ba 00 00 00 38       	mov    $0x38000000,%edx
  104104:	b8 00 00 00 00       	mov    $0x0,%eax
  104109:	3b 55 e0             	cmp    -0x20(%ebp),%edx
  10410c:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
  10410f:	73 0e                	jae    10411f <page_init+0x173>
        maxpa = KMEMSIZE;
  104111:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
  104118:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
  10411f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104122:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104125:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  104129:	c1 ea 0c             	shr    $0xc,%edx
  10412c:	a3 a4 ce 11 00       	mov    %eax,0x11cea4
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  104131:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  104138:	b8 2c cf 11 00       	mov    $0x11cf2c,%eax
  10413d:	8d 50 ff             	lea    -0x1(%eax),%edx
  104140:	8b 45 c0             	mov    -0x40(%ebp),%eax
  104143:	01 d0                	add    %edx,%eax
  104145:	89 45 bc             	mov    %eax,-0x44(%ebp)
  104148:	8b 45 bc             	mov    -0x44(%ebp),%eax
  10414b:	ba 00 00 00 00       	mov    $0x0,%edx
  104150:	f7 75 c0             	divl   -0x40(%ebp)
  104153:	8b 45 bc             	mov    -0x44(%ebp),%eax
  104156:	29 d0                	sub    %edx,%eax
  104158:	a3 a0 ce 11 00       	mov    %eax,0x11cea0

    for (i = 0; i < npage; i ++) {
  10415d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  104164:	eb 2f                	jmp    104195 <page_init+0x1e9>
        SetPageReserved(pages + i);
  104166:	8b 0d a0 ce 11 00    	mov    0x11cea0,%ecx
  10416c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10416f:	89 d0                	mov    %edx,%eax
  104171:	c1 e0 02             	shl    $0x2,%eax
  104174:	01 d0                	add    %edx,%eax
  104176:	c1 e0 02             	shl    $0x2,%eax
  104179:	01 c8                	add    %ecx,%eax
  10417b:	83 c0 04             	add    $0x4,%eax
  10417e:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
  104185:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104188:	8b 45 90             	mov    -0x70(%ebp),%eax
  10418b:	8b 55 94             	mov    -0x6c(%ebp),%edx
  10418e:	0f ab 10             	bts    %edx,(%eax)
}
  104191:	90                   	nop
    for (i = 0; i < npage; i ++) {
  104192:	ff 45 dc             	incl   -0x24(%ebp)
  104195:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104198:	a1 a4 ce 11 00       	mov    0x11cea4,%eax
  10419d:	39 c2                	cmp    %eax,%edx
  10419f:	72 c5                	jb     104166 <page_init+0x1ba>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
  1041a1:	8b 15 a4 ce 11 00    	mov    0x11cea4,%edx
  1041a7:	89 d0                	mov    %edx,%eax
  1041a9:	c1 e0 02             	shl    $0x2,%eax
  1041ac:	01 d0                	add    %edx,%eax
  1041ae:	c1 e0 02             	shl    $0x2,%eax
  1041b1:	89 c2                	mov    %eax,%edx
  1041b3:	a1 a0 ce 11 00       	mov    0x11cea0,%eax
  1041b8:	01 d0                	add    %edx,%eax
  1041ba:	89 45 b8             	mov    %eax,-0x48(%ebp)
  1041bd:	81 7d b8 ff ff ff bf 	cmpl   $0xbfffffff,-0x48(%ebp)
  1041c4:	77 23                	ja     1041e9 <page_init+0x23d>
  1041c6:	8b 45 b8             	mov    -0x48(%ebp),%eax
  1041c9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1041cd:	c7 44 24 08 c8 6c 10 	movl   $0x106cc8,0x8(%esp)
  1041d4:	00 
  1041d5:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
  1041dc:	00 
  1041dd:	c7 04 24 ec 6c 10 00 	movl   $0x106cec,(%esp)
  1041e4:	e8 19 cb ff ff       	call   100d02 <__panic>
  1041e9:	8b 45 b8             	mov    -0x48(%ebp),%eax
  1041ec:	05 00 00 00 40       	add    $0x40000000,%eax
  1041f1:	89 45 b4             	mov    %eax,-0x4c(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
  1041f4:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  1041fb:	e9 53 01 00 00       	jmp    104353 <page_init+0x3a7>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  104200:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104203:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104206:	89 d0                	mov    %edx,%eax
  104208:	c1 e0 02             	shl    $0x2,%eax
  10420b:	01 d0                	add    %edx,%eax
  10420d:	c1 e0 02             	shl    $0x2,%eax
  104210:	01 c8                	add    %ecx,%eax
  104212:	8b 50 08             	mov    0x8(%eax),%edx
  104215:	8b 40 04             	mov    0x4(%eax),%eax
  104218:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10421b:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  10421e:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104221:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104224:	89 d0                	mov    %edx,%eax
  104226:	c1 e0 02             	shl    $0x2,%eax
  104229:	01 d0                	add    %edx,%eax
  10422b:	c1 e0 02             	shl    $0x2,%eax
  10422e:	01 c8                	add    %ecx,%eax
  104230:	8b 48 0c             	mov    0xc(%eax),%ecx
  104233:	8b 58 10             	mov    0x10(%eax),%ebx
  104236:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104239:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10423c:	01 c8                	add    %ecx,%eax
  10423e:	11 da                	adc    %ebx,%edx
  104240:	89 45 c8             	mov    %eax,-0x38(%ebp)
  104243:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
  104246:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104249:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10424c:	89 d0                	mov    %edx,%eax
  10424e:	c1 e0 02             	shl    $0x2,%eax
  104251:	01 d0                	add    %edx,%eax
  104253:	c1 e0 02             	shl    $0x2,%eax
  104256:	01 c8                	add    %ecx,%eax
  104258:	83 c0 14             	add    $0x14,%eax
  10425b:	8b 00                	mov    (%eax),%eax
  10425d:	83 f8 01             	cmp    $0x1,%eax
  104260:	0f 85 ea 00 00 00    	jne    104350 <page_init+0x3a4>
            if (begin < freemem) {
  104266:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  104269:	ba 00 00 00 00       	mov    $0x0,%edx
  10426e:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  104271:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  104274:	19 d1                	sbb    %edx,%ecx
  104276:	73 0d                	jae    104285 <page_init+0x2d9>
                begin = freemem;
  104278:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  10427b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10427e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
  104285:	ba 00 00 00 38       	mov    $0x38000000,%edx
  10428a:	b8 00 00 00 00       	mov    $0x0,%eax
  10428f:	3b 55 c8             	cmp    -0x38(%ebp),%edx
  104292:	1b 45 cc             	sbb    -0x34(%ebp),%eax
  104295:	73 0e                	jae    1042a5 <page_init+0x2f9>
                end = KMEMSIZE;
  104297:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
  10429e:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
  1042a5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1042a8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1042ab:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  1042ae:	89 d0                	mov    %edx,%eax
  1042b0:	1b 45 cc             	sbb    -0x34(%ebp),%eax
  1042b3:	0f 83 97 00 00 00    	jae    104350 <page_init+0x3a4>
                begin = ROUNDUP(begin, PGSIZE);
  1042b9:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  1042c0:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1042c3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1042c6:	01 d0                	add    %edx,%eax
  1042c8:	48                   	dec    %eax
  1042c9:	89 45 ac             	mov    %eax,-0x54(%ebp)
  1042cc:	8b 45 ac             	mov    -0x54(%ebp),%eax
  1042cf:	ba 00 00 00 00       	mov    $0x0,%edx
  1042d4:	f7 75 b0             	divl   -0x50(%ebp)
  1042d7:	8b 45 ac             	mov    -0x54(%ebp),%eax
  1042da:	29 d0                	sub    %edx,%eax
  1042dc:	ba 00 00 00 00       	mov    $0x0,%edx
  1042e1:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1042e4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
  1042e7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1042ea:	89 45 a8             	mov    %eax,-0x58(%ebp)
  1042ed:	8b 45 a8             	mov    -0x58(%ebp),%eax
  1042f0:	ba 00 00 00 00       	mov    $0x0,%edx
  1042f5:	89 c7                	mov    %eax,%edi
  1042f7:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  1042fd:	89 7d 80             	mov    %edi,-0x80(%ebp)
  104300:	89 d0                	mov    %edx,%eax
  104302:	83 e0 00             	and    $0x0,%eax
  104305:	89 45 84             	mov    %eax,-0x7c(%ebp)
  104308:	8b 45 80             	mov    -0x80(%ebp),%eax
  10430b:	8b 55 84             	mov    -0x7c(%ebp),%edx
  10430e:	89 45 c8             	mov    %eax,-0x38(%ebp)
  104311:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
  104314:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104317:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10431a:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  10431d:	89 d0                	mov    %edx,%eax
  10431f:	1b 45 cc             	sbb    -0x34(%ebp),%eax
  104322:	73 2c                	jae    104350 <page_init+0x3a4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
  104324:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104327:	8b 55 cc             	mov    -0x34(%ebp),%edx
  10432a:	2b 45 d0             	sub    -0x30(%ebp),%eax
  10432d:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
  104330:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  104334:	c1 ea 0c             	shr    $0xc,%edx
  104337:	89 c3                	mov    %eax,%ebx
  104339:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10433c:	89 04 24             	mov    %eax,(%esp)
  10433f:	e8 bb f8 ff ff       	call   103bff <pa2page>
  104344:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  104348:	89 04 24             	mov    %eax,(%esp)
  10434b:	e8 9e fb ff ff       	call   103eee <init_memmap>
    for (i = 0; i < memmap->nr_map; i ++) {
  104350:	ff 45 dc             	incl   -0x24(%ebp)
  104353:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104356:	8b 00                	mov    (%eax),%eax
  104358:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  10435b:	0f 8c 9f fe ff ff    	jl     104200 <page_init+0x254>
                }
            }
        }
    }
}
  104361:	90                   	nop
  104362:	90                   	nop
  104363:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  104369:	5b                   	pop    %ebx
  10436a:	5e                   	pop    %esi
  10436b:	5f                   	pop    %edi
  10436c:	5d                   	pop    %ebp
  10436d:	c3                   	ret    

0010436e <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
  10436e:	55                   	push   %ebp
  10436f:	89 e5                	mov    %esp,%ebp
  104371:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
  104374:	8b 45 0c             	mov    0xc(%ebp),%eax
  104377:	33 45 14             	xor    0x14(%ebp),%eax
  10437a:	25 ff 0f 00 00       	and    $0xfff,%eax
  10437f:	85 c0                	test   %eax,%eax
  104381:	74 24                	je     1043a7 <boot_map_segment+0x39>
  104383:	c7 44 24 0c fa 6c 10 	movl   $0x106cfa,0xc(%esp)
  10438a:	00 
  10438b:	c7 44 24 08 11 6d 10 	movl   $0x106d11,0x8(%esp)
  104392:	00 
  104393:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
  10439a:	00 
  10439b:	c7 04 24 ec 6c 10 00 	movl   $0x106cec,(%esp)
  1043a2:	e8 5b c9 ff ff       	call   100d02 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  1043a7:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  1043ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  1043b1:	25 ff 0f 00 00       	and    $0xfff,%eax
  1043b6:	89 c2                	mov    %eax,%edx
  1043b8:	8b 45 10             	mov    0x10(%ebp),%eax
  1043bb:	01 c2                	add    %eax,%edx
  1043bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1043c0:	01 d0                	add    %edx,%eax
  1043c2:	48                   	dec    %eax
  1043c3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1043c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1043c9:	ba 00 00 00 00       	mov    $0x0,%edx
  1043ce:	f7 75 f0             	divl   -0x10(%ebp)
  1043d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1043d4:	29 d0                	sub    %edx,%eax
  1043d6:	c1 e8 0c             	shr    $0xc,%eax
  1043d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
  1043dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1043df:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1043e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1043e5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1043ea:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
  1043ed:	8b 45 14             	mov    0x14(%ebp),%eax
  1043f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1043f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1043f6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1043fb:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  1043fe:	eb 68                	jmp    104468 <boot_map_segment+0xfa>
        pte_t *ptep = get_pte(pgdir, la, 1);
  104400:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  104407:	00 
  104408:	8b 45 0c             	mov    0xc(%ebp),%eax
  10440b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10440f:	8b 45 08             	mov    0x8(%ebp),%eax
  104412:	89 04 24             	mov    %eax,(%esp)
  104415:	e8 88 01 00 00       	call   1045a2 <get_pte>
  10441a:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  10441d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  104421:	75 24                	jne    104447 <boot_map_segment+0xd9>
  104423:	c7 44 24 0c 26 6d 10 	movl   $0x106d26,0xc(%esp)
  10442a:	00 
  10442b:	c7 44 24 08 11 6d 10 	movl   $0x106d11,0x8(%esp)
  104432:	00 
  104433:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
  10443a:	00 
  10443b:	c7 04 24 ec 6c 10 00 	movl   $0x106cec,(%esp)
  104442:	e8 bb c8 ff ff       	call   100d02 <__panic>
        *ptep = pa | PTE_P | perm;
  104447:	8b 45 14             	mov    0x14(%ebp),%eax
  10444a:	0b 45 18             	or     0x18(%ebp),%eax
  10444d:	83 c8 01             	or     $0x1,%eax
  104450:	89 c2                	mov    %eax,%edx
  104452:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104455:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  104457:	ff 4d f4             	decl   -0xc(%ebp)
  10445a:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  104461:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  104468:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10446c:	75 92                	jne    104400 <boot_map_segment+0x92>
    }
}
  10446e:	90                   	nop
  10446f:	90                   	nop
  104470:	89 ec                	mov    %ebp,%esp
  104472:	5d                   	pop    %ebp
  104473:	c3                   	ret    

00104474 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
  104474:	55                   	push   %ebp
  104475:	89 e5                	mov    %esp,%ebp
  104477:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
  10447a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104481:	e8 8a fa ff ff       	call   103f10 <alloc_pages>
  104486:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
  104489:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10448d:	75 1c                	jne    1044ab <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
  10448f:	c7 44 24 08 33 6d 10 	movl   $0x106d33,0x8(%esp)
  104496:	00 
  104497:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
  10449e:	00 
  10449f:	c7 04 24 ec 6c 10 00 	movl   $0x106cec,(%esp)
  1044a6:	e8 57 c8 ff ff       	call   100d02 <__panic>
    }
    return page2kva(p);
  1044ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1044ae:	89 04 24             	mov    %eax,(%esp)
  1044b1:	e8 9a f7 ff ff       	call   103c50 <page2kva>
}
  1044b6:	89 ec                	mov    %ebp,%esp
  1044b8:	5d                   	pop    %ebp
  1044b9:	c3                   	ret    

001044ba <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
  1044ba:	55                   	push   %ebp
  1044bb:	89 e5                	mov    %esp,%ebp
  1044bd:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
  1044c0:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  1044c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1044c8:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  1044cf:	77 23                	ja     1044f4 <pmm_init+0x3a>
  1044d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1044d4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1044d8:	c7 44 24 08 c8 6c 10 	movl   $0x106cc8,0x8(%esp)
  1044df:	00 
  1044e0:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
  1044e7:	00 
  1044e8:	c7 04 24 ec 6c 10 00 	movl   $0x106cec,(%esp)
  1044ef:	e8 0e c8 ff ff       	call   100d02 <__panic>
  1044f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1044f7:	05 00 00 00 40       	add    $0x40000000,%eax
  1044fc:	a3 a8 ce 11 00       	mov    %eax,0x11cea8
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  104501:	e8 b2 f9 ff ff       	call   103eb8 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
  104506:	e8 a1 fa ff ff       	call   103fac <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  10450b:	e8 1b 04 00 00       	call   10492b <check_alloc_page>

    check_pgdir();
  104510:	e8 37 04 00 00       	call   10494c <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  104515:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  10451a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10451d:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  104524:	77 23                	ja     104549 <pmm_init+0x8f>
  104526:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104529:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10452d:	c7 44 24 08 c8 6c 10 	movl   $0x106cc8,0x8(%esp)
  104534:	00 
  104535:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
  10453c:	00 
  10453d:	c7 04 24 ec 6c 10 00 	movl   $0x106cec,(%esp)
  104544:	e8 b9 c7 ff ff       	call   100d02 <__panic>
  104549:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10454c:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
  104552:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  104557:	05 ac 0f 00 00       	add    $0xfac,%eax
  10455c:	83 ca 03             	or     $0x3,%edx
  10455f:	89 10                	mov    %edx,(%eax)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
  104561:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  104566:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
  10456d:	00 
  10456e:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  104575:	00 
  104576:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
  10457d:	38 
  10457e:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
  104585:	c0 
  104586:	89 04 24             	mov    %eax,(%esp)
  104589:	e8 e0 fd ff ff       	call   10436e <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  10458e:	e8 39 f8 ff ff       	call   103dcc <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
  104593:	e8 52 0a 00 00       	call   104fea <check_boot_pgdir>

    print_pgdir();
  104598:	e8 cf 0e 00 00       	call   10546c <print_pgdir>

}
  10459d:	90                   	nop
  10459e:	89 ec                	mov    %ebp,%esp
  1045a0:	5d                   	pop    %ebp
  1045a1:	c3                   	ret    

001045a2 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
  1045a2:	55                   	push   %ebp
  1045a3:	89 e5                	mov    %esp,%ebp
  1045a5:	83 ec 38             	sub    $0x38,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    pde_t *pdep = pgdir + PDX(la);
  1045a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1045ab:	c1 e8 16             	shr    $0x16,%eax
  1045ae:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1045b5:	8b 45 08             	mov    0x8(%ebp),%eax
  1045b8:	01 d0                	add    %edx,%eax
  1045ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(((*pdep) & PTE_P)!=1){//如果不存在页目录项
  1045bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1045c0:	8b 00                	mov    (%eax),%eax
  1045c2:	83 e0 01             	and    $0x1,%eax
  1045c5:	85 c0                	test   %eax,%eax
  1045c7:	0f 85 d8 00 00 00    	jne    1046a5 <get_pte+0x103>
        if(!create)return NULL;//不需要创建则返回null
  1045cd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1045d1:	75 0a                	jne    1045dd <get_pte+0x3b>
  1045d3:	b8 00 00 00 00       	mov    $0x0,%eax
  1045d8:	e9 25 01 00 00       	jmp    104702 <get_pte+0x160>
        struct Page* ptPage;
        assert(ptPage=alloc_page());
  1045dd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1045e4:	e8 27 f9 ff ff       	call   103f10 <alloc_pages>
  1045e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1045ec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1045f0:	75 24                	jne    104616 <get_pte+0x74>
  1045f2:	c7 44 24 0c 4c 6d 10 	movl   $0x106d4c,0xc(%esp)
  1045f9:	00 
  1045fa:	c7 44 24 08 11 6d 10 	movl   $0x106d11,0x8(%esp)
  104601:	00 
  104602:	c7 44 24 04 6e 01 00 	movl   $0x16e,0x4(%esp)
  104609:	00 
  10460a:	c7 04 24 ec 6c 10 00 	movl   $0x106cec,(%esp)
  104611:	e8 ec c6 ff ff       	call   100d02 <__panic>
        set_page_ref(ptPage,1);
  104616:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10461d:	00 
  10461e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104621:	89 04 24             	mov    %eax,(%esp)
  104624:	e8 e1 f6 ff ff       	call   103d0a <set_page_ref>
        uintptr_t pa=page2pa(ptPage);
  104629:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10462c:	89 04 24             	mov    %eax,(%esp)
  10462f:	e8 b3 f5 ff ff       	call   103be7 <page2pa>
  104634:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(pa),0,PGSIZE);
  104637:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10463a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10463d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104640:	c1 e8 0c             	shr    $0xc,%eax
  104643:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104646:	a1 a4 ce 11 00       	mov    0x11cea4,%eax
  10464b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  10464e:	72 23                	jb     104673 <get_pte+0xd1>
  104650:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104653:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104657:	c7 44 24 08 24 6c 10 	movl   $0x106c24,0x8(%esp)
  10465e:	00 
  10465f:	c7 44 24 04 71 01 00 	movl   $0x171,0x4(%esp)
  104666:	00 
  104667:	c7 04 24 ec 6c 10 00 	movl   $0x106cec,(%esp)
  10466e:	e8 8f c6 ff ff       	call   100d02 <__panic>
  104673:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104676:	2d 00 00 00 40       	sub    $0x40000000,%eax
  10467b:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104682:	00 
  104683:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10468a:	00 
  10468b:	89 04 24             	mov    %eax,(%esp)
  10468e:	e8 de 18 00 00       	call   105f71 <memset>
        *pdep=((pa&~0x0FFF)| PTE_U | PTE_W | PTE_P);//未判断此页表项是否存在？
  104693:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104696:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10469b:	83 c8 07             	or     $0x7,%eax
  10469e:	89 c2                	mov    %eax,%edx
  1046a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046a3:	89 10                	mov    %edx,(%eax)
    }
    return ((pte_t*)KADDR((*pdep) & ~0xFFF)) + PTX(la);
  1046a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046a8:	8b 00                	mov    (%eax),%eax
  1046aa:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1046af:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1046b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1046b5:	c1 e8 0c             	shr    $0xc,%eax
  1046b8:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1046bb:	a1 a4 ce 11 00       	mov    0x11cea4,%eax
  1046c0:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  1046c3:	72 23                	jb     1046e8 <get_pte+0x146>
  1046c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1046c8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1046cc:	c7 44 24 08 24 6c 10 	movl   $0x106c24,0x8(%esp)
  1046d3:	00 
  1046d4:	c7 44 24 04 74 01 00 	movl   $0x174,0x4(%esp)
  1046db:	00 
  1046dc:	c7 04 24 ec 6c 10 00 	movl   $0x106cec,(%esp)
  1046e3:	e8 1a c6 ff ff       	call   100d02 <__panic>
  1046e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1046eb:	2d 00 00 00 40       	sub    $0x40000000,%eax
  1046f0:	89 c2                	mov    %eax,%edx
  1046f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1046f5:	c1 e8 0c             	shr    $0xc,%eax
  1046f8:	25 ff 03 00 00       	and    $0x3ff,%eax
  1046fd:	c1 e0 02             	shl    $0x2,%eax
  104700:	01 d0                	add    %edx,%eax

}
  104702:	89 ec                	mov    %ebp,%esp
  104704:	5d                   	pop    %ebp
  104705:	c3                   	ret    

00104706 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
  104706:	55                   	push   %ebp
  104707:	89 e5                	mov    %esp,%ebp
  104709:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  10470c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104713:	00 
  104714:	8b 45 0c             	mov    0xc(%ebp),%eax
  104717:	89 44 24 04          	mov    %eax,0x4(%esp)
  10471b:	8b 45 08             	mov    0x8(%ebp),%eax
  10471e:	89 04 24             	mov    %eax,(%esp)
  104721:	e8 7c fe ff ff       	call   1045a2 <get_pte>
  104726:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
  104729:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10472d:	74 08                	je     104737 <get_page+0x31>
        *ptep_store = ptep;
  10472f:	8b 45 10             	mov    0x10(%ebp),%eax
  104732:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104735:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
  104737:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10473b:	74 1b                	je     104758 <get_page+0x52>
  10473d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104740:	8b 00                	mov    (%eax),%eax
  104742:	83 e0 01             	and    $0x1,%eax
  104745:	85 c0                	test   %eax,%eax
  104747:	74 0f                	je     104758 <get_page+0x52>
        return pte2page(*ptep);
  104749:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10474c:	8b 00                	mov    (%eax),%eax
  10474e:	89 04 24             	mov    %eax,(%esp)
  104751:	e8 50 f5 ff ff       	call   103ca6 <pte2page>
  104756:	eb 05                	jmp    10475d <get_page+0x57>
    }
    return NULL;
  104758:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10475d:	89 ec                	mov    %ebp,%esp
  10475f:	5d                   	pop    %ebp
  104760:	c3                   	ret    

00104761 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
  104761:	55                   	push   %ebp
  104762:	89 e5                	mov    %esp,%ebp
  104764:	83 ec 28             	sub    $0x28,%esp
     *                        edited are the ones currently in use by the processor.
     * DEFINEs:
     *   PTE_P           0x001                   // page table/directory entry flags bit : Present
     */

    if(((*ptep)&PTE_P)==1){
  104767:	8b 45 10             	mov    0x10(%ebp),%eax
  10476a:	8b 00                	mov    (%eax),%eax
  10476c:	83 e0 01             	and    $0x1,%eax
  10476f:	85 c0                	test   %eax,%eax
  104771:	74 52                	je     1047c5 <page_remove_pte+0x64>
        struct Page* page=pte2page(*ptep);
  104773:	8b 45 10             	mov    0x10(%ebp),%eax
  104776:	8b 00                	mov    (%eax),%eax
  104778:	89 04 24             	mov    %eax,(%esp)
  10477b:	e8 26 f5 ff ff       	call   103ca6 <pte2page>
  104780:	89 45 f4             	mov    %eax,-0xc(%ebp)
        page_ref_dec(page);
  104783:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104786:	89 04 24             	mov    %eax,(%esp)
  104789:	e8 a1 f5 ff ff       	call   103d2f <page_ref_dec>
        if(page->ref==0)free_page(page);
  10478e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104791:	8b 00                	mov    (%eax),%eax
  104793:	85 c0                	test   %eax,%eax
  104795:	75 13                	jne    1047aa <page_remove_pte+0x49>
  104797:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10479e:	00 
  10479f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1047a2:	89 04 24             	mov    %eax,(%esp)
  1047a5:	e8 a0 f7 ff ff       	call   103f4a <free_pages>
        *ptep=NULL;
  1047aa:	8b 45 10             	mov    0x10(%ebp),%eax
  1047ad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir,la);
  1047b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1047b6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1047ba:	8b 45 08             	mov    0x8(%ebp),%eax
  1047bd:	89 04 24             	mov    %eax,(%esp)
  1047c0:	e8 07 01 00 00       	call   1048cc <tlb_invalidate>
#endif




}
  1047c5:	90                   	nop
  1047c6:	89 ec                	mov    %ebp,%esp
  1047c8:	5d                   	pop    %ebp
  1047c9:	c3                   	ret    

001047ca <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
  1047ca:	55                   	push   %ebp
  1047cb:	89 e5                	mov    %esp,%ebp
  1047cd:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  1047d0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1047d7:	00 
  1047d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1047db:	89 44 24 04          	mov    %eax,0x4(%esp)
  1047df:	8b 45 08             	mov    0x8(%ebp),%eax
  1047e2:	89 04 24             	mov    %eax,(%esp)
  1047e5:	e8 b8 fd ff ff       	call   1045a2 <get_pte>
  1047ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
  1047ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1047f1:	74 19                	je     10480c <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
  1047f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1047f6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1047fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1047fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  104801:	8b 45 08             	mov    0x8(%ebp),%eax
  104804:	89 04 24             	mov    %eax,(%esp)
  104807:	e8 55 ff ff ff       	call   104761 <page_remove_pte>
    }
}
  10480c:	90                   	nop
  10480d:	89 ec                	mov    %ebp,%esp
  10480f:	5d                   	pop    %ebp
  104810:	c3                   	ret    

00104811 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
  104811:	55                   	push   %ebp
  104812:	89 e5                	mov    %esp,%ebp
  104814:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
  104817:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  10481e:	00 
  10481f:	8b 45 10             	mov    0x10(%ebp),%eax
  104822:	89 44 24 04          	mov    %eax,0x4(%esp)
  104826:	8b 45 08             	mov    0x8(%ebp),%eax
  104829:	89 04 24             	mov    %eax,(%esp)
  10482c:	e8 71 fd ff ff       	call   1045a2 <get_pte>
  104831:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
  104834:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104838:	75 0a                	jne    104844 <page_insert+0x33>
        return -E_NO_MEM;
  10483a:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  10483f:	e9 84 00 00 00       	jmp    1048c8 <page_insert+0xb7>
    }
    page_ref_inc(page);
  104844:	8b 45 0c             	mov    0xc(%ebp),%eax
  104847:	89 04 24             	mov    %eax,(%esp)
  10484a:	e8 c9 f4 ff ff       	call   103d18 <page_ref_inc>
    if (*ptep & PTE_P) {
  10484f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104852:	8b 00                	mov    (%eax),%eax
  104854:	83 e0 01             	and    $0x1,%eax
  104857:	85 c0                	test   %eax,%eax
  104859:	74 3e                	je     104899 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
  10485b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10485e:	8b 00                	mov    (%eax),%eax
  104860:	89 04 24             	mov    %eax,(%esp)
  104863:	e8 3e f4 ff ff       	call   103ca6 <pte2page>
  104868:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
  10486b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10486e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  104871:	75 0d                	jne    104880 <page_insert+0x6f>
            page_ref_dec(page);
  104873:	8b 45 0c             	mov    0xc(%ebp),%eax
  104876:	89 04 24             	mov    %eax,(%esp)
  104879:	e8 b1 f4 ff ff       	call   103d2f <page_ref_dec>
  10487e:	eb 19                	jmp    104899 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
  104880:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104883:	89 44 24 08          	mov    %eax,0x8(%esp)
  104887:	8b 45 10             	mov    0x10(%ebp),%eax
  10488a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10488e:	8b 45 08             	mov    0x8(%ebp),%eax
  104891:	89 04 24             	mov    %eax,(%esp)
  104894:	e8 c8 fe ff ff       	call   104761 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  104899:	8b 45 0c             	mov    0xc(%ebp),%eax
  10489c:	89 04 24             	mov    %eax,(%esp)
  10489f:	e8 43 f3 ff ff       	call   103be7 <page2pa>
  1048a4:	0b 45 14             	or     0x14(%ebp),%eax
  1048a7:	83 c8 01             	or     $0x1,%eax
  1048aa:	89 c2                	mov    %eax,%edx
  1048ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1048af:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
  1048b1:	8b 45 10             	mov    0x10(%ebp),%eax
  1048b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1048b8:	8b 45 08             	mov    0x8(%ebp),%eax
  1048bb:	89 04 24             	mov    %eax,(%esp)
  1048be:	e8 09 00 00 00       	call   1048cc <tlb_invalidate>
    return 0;
  1048c3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1048c8:	89 ec                	mov    %ebp,%esp
  1048ca:	5d                   	pop    %ebp
  1048cb:	c3                   	ret    

001048cc <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
  1048cc:	55                   	push   %ebp
  1048cd:	89 e5                	mov    %esp,%ebp
  1048cf:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
  1048d2:	0f 20 d8             	mov    %cr3,%eax
  1048d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
  1048d8:	8b 55 f0             	mov    -0x10(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
  1048db:	8b 45 08             	mov    0x8(%ebp),%eax
  1048de:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1048e1:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  1048e8:	77 23                	ja     10490d <tlb_invalidate+0x41>
  1048ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1048ed:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1048f1:	c7 44 24 08 c8 6c 10 	movl   $0x106cc8,0x8(%esp)
  1048f8:	00 
  1048f9:	c7 44 24 04 de 01 00 	movl   $0x1de,0x4(%esp)
  104900:	00 
  104901:	c7 04 24 ec 6c 10 00 	movl   $0x106cec,(%esp)
  104908:	e8 f5 c3 ff ff       	call   100d02 <__panic>
  10490d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104910:	05 00 00 00 40       	add    $0x40000000,%eax
  104915:	39 d0                	cmp    %edx,%eax
  104917:	75 0d                	jne    104926 <tlb_invalidate+0x5a>
        invlpg((void *)la);
  104919:	8b 45 0c             	mov    0xc(%ebp),%eax
  10491c:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
  10491f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104922:	0f 01 38             	invlpg (%eax)
}
  104925:	90                   	nop
    }
}
  104926:	90                   	nop
  104927:	89 ec                	mov    %ebp,%esp
  104929:	5d                   	pop    %ebp
  10492a:	c3                   	ret    

0010492b <check_alloc_page>:

static void
check_alloc_page(void) {
  10492b:	55                   	push   %ebp
  10492c:	89 e5                	mov    %esp,%ebp
  10492e:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
  104931:	a1 ac ce 11 00       	mov    0x11ceac,%eax
  104936:	8b 40 18             	mov    0x18(%eax),%eax
  104939:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  10493b:	c7 04 24 60 6d 10 00 	movl   $0x106d60,(%esp)
  104942:	e8 1a ba ff ff       	call   100361 <cprintf>
}
  104947:	90                   	nop
  104948:	89 ec                	mov    %ebp,%esp
  10494a:	5d                   	pop    %ebp
  10494b:	c3                   	ret    

0010494c <check_pgdir>:

static void
check_pgdir(void) {
  10494c:	55                   	push   %ebp
  10494d:	89 e5                	mov    %esp,%ebp
  10494f:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
  104952:	a1 a4 ce 11 00       	mov    0x11cea4,%eax
  104957:	3d 00 80 03 00       	cmp    $0x38000,%eax
  10495c:	76 24                	jbe    104982 <check_pgdir+0x36>
  10495e:	c7 44 24 0c 7f 6d 10 	movl   $0x106d7f,0xc(%esp)
  104965:	00 
  104966:	c7 44 24 08 11 6d 10 	movl   $0x106d11,0x8(%esp)
  10496d:	00 
  10496e:	c7 44 24 04 eb 01 00 	movl   $0x1eb,0x4(%esp)
  104975:	00 
  104976:	c7 04 24 ec 6c 10 00 	movl   $0x106cec,(%esp)
  10497d:	e8 80 c3 ff ff       	call   100d02 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  104982:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  104987:	85 c0                	test   %eax,%eax
  104989:	74 0e                	je     104999 <check_pgdir+0x4d>
  10498b:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  104990:	25 ff 0f 00 00       	and    $0xfff,%eax
  104995:	85 c0                	test   %eax,%eax
  104997:	74 24                	je     1049bd <check_pgdir+0x71>
  104999:	c7 44 24 0c 9c 6d 10 	movl   $0x106d9c,0xc(%esp)
  1049a0:	00 
  1049a1:	c7 44 24 08 11 6d 10 	movl   $0x106d11,0x8(%esp)
  1049a8:	00 
  1049a9:	c7 44 24 04 ec 01 00 	movl   $0x1ec,0x4(%esp)
  1049b0:	00 
  1049b1:	c7 04 24 ec 6c 10 00 	movl   $0x106cec,(%esp)
  1049b8:	e8 45 c3 ff ff       	call   100d02 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  1049bd:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  1049c2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1049c9:	00 
  1049ca:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1049d1:	00 
  1049d2:	89 04 24             	mov    %eax,(%esp)
  1049d5:	e8 2c fd ff ff       	call   104706 <get_page>
  1049da:	85 c0                	test   %eax,%eax
  1049dc:	74 24                	je     104a02 <check_pgdir+0xb6>
  1049de:	c7 44 24 0c d4 6d 10 	movl   $0x106dd4,0xc(%esp)
  1049e5:	00 
  1049e6:	c7 44 24 08 11 6d 10 	movl   $0x106d11,0x8(%esp)
  1049ed:	00 
  1049ee:	c7 44 24 04 ed 01 00 	movl   $0x1ed,0x4(%esp)
  1049f5:	00 
  1049f6:	c7 04 24 ec 6c 10 00 	movl   $0x106cec,(%esp)
  1049fd:	e8 00 c3 ff ff       	call   100d02 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  104a02:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104a09:	e8 02 f5 ff ff       	call   103f10 <alloc_pages>
  104a0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  104a11:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  104a16:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  104a1d:	00 
  104a1e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104a25:	00 
  104a26:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104a29:	89 54 24 04          	mov    %edx,0x4(%esp)
  104a2d:	89 04 24             	mov    %eax,(%esp)
  104a30:	e8 dc fd ff ff       	call   104811 <page_insert>
  104a35:	85 c0                	test   %eax,%eax
  104a37:	74 24                	je     104a5d <check_pgdir+0x111>
  104a39:	c7 44 24 0c fc 6d 10 	movl   $0x106dfc,0xc(%esp)
  104a40:	00 
  104a41:	c7 44 24 08 11 6d 10 	movl   $0x106d11,0x8(%esp)
  104a48:	00 
  104a49:	c7 44 24 04 f1 01 00 	movl   $0x1f1,0x4(%esp)
  104a50:	00 
  104a51:	c7 04 24 ec 6c 10 00 	movl   $0x106cec,(%esp)
  104a58:	e8 a5 c2 ff ff       	call   100d02 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  104a5d:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  104a62:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104a69:	00 
  104a6a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104a71:	00 
  104a72:	89 04 24             	mov    %eax,(%esp)
  104a75:	e8 28 fb ff ff       	call   1045a2 <get_pte>
  104a7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104a7d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104a81:	75 24                	jne    104aa7 <check_pgdir+0x15b>
  104a83:	c7 44 24 0c 28 6e 10 	movl   $0x106e28,0xc(%esp)
  104a8a:	00 
  104a8b:	c7 44 24 08 11 6d 10 	movl   $0x106d11,0x8(%esp)
  104a92:	00 
  104a93:	c7 44 24 04 f4 01 00 	movl   $0x1f4,0x4(%esp)
  104a9a:	00 
  104a9b:	c7 04 24 ec 6c 10 00 	movl   $0x106cec,(%esp)
  104aa2:	e8 5b c2 ff ff       	call   100d02 <__panic>
    assert(pte2page(*ptep) == p1);
  104aa7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104aaa:	8b 00                	mov    (%eax),%eax
  104aac:	89 04 24             	mov    %eax,(%esp)
  104aaf:	e8 f2 f1 ff ff       	call   103ca6 <pte2page>
  104ab4:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  104ab7:	74 24                	je     104add <check_pgdir+0x191>
  104ab9:	c7 44 24 0c 55 6e 10 	movl   $0x106e55,0xc(%esp)
  104ac0:	00 
  104ac1:	c7 44 24 08 11 6d 10 	movl   $0x106d11,0x8(%esp)
  104ac8:	00 
  104ac9:	c7 44 24 04 f5 01 00 	movl   $0x1f5,0x4(%esp)
  104ad0:	00 
  104ad1:	c7 04 24 ec 6c 10 00 	movl   $0x106cec,(%esp)
  104ad8:	e8 25 c2 ff ff       	call   100d02 <__panic>
    assert(page_ref(p1) == 1);
  104add:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104ae0:	89 04 24             	mov    %eax,(%esp)
  104ae3:	e8 18 f2 ff ff       	call   103d00 <page_ref>
  104ae8:	83 f8 01             	cmp    $0x1,%eax
  104aeb:	74 24                	je     104b11 <check_pgdir+0x1c5>
  104aed:	c7 44 24 0c 6b 6e 10 	movl   $0x106e6b,0xc(%esp)
  104af4:	00 
  104af5:	c7 44 24 08 11 6d 10 	movl   $0x106d11,0x8(%esp)
  104afc:	00 
  104afd:	c7 44 24 04 f6 01 00 	movl   $0x1f6,0x4(%esp)
  104b04:	00 
  104b05:	c7 04 24 ec 6c 10 00 	movl   $0x106cec,(%esp)
  104b0c:	e8 f1 c1 ff ff       	call   100d02 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  104b11:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  104b16:	8b 00                	mov    (%eax),%eax
  104b18:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104b1d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104b20:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104b23:	c1 e8 0c             	shr    $0xc,%eax
  104b26:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104b29:	a1 a4 ce 11 00       	mov    0x11cea4,%eax
  104b2e:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  104b31:	72 23                	jb     104b56 <check_pgdir+0x20a>
  104b33:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104b36:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104b3a:	c7 44 24 08 24 6c 10 	movl   $0x106c24,0x8(%esp)
  104b41:	00 
  104b42:	c7 44 24 04 f8 01 00 	movl   $0x1f8,0x4(%esp)
  104b49:	00 
  104b4a:	c7 04 24 ec 6c 10 00 	movl   $0x106cec,(%esp)
  104b51:	e8 ac c1 ff ff       	call   100d02 <__panic>
  104b56:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104b59:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104b5e:	83 c0 04             	add    $0x4,%eax
  104b61:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  104b64:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  104b69:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104b70:	00 
  104b71:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104b78:	00 
  104b79:	89 04 24             	mov    %eax,(%esp)
  104b7c:	e8 21 fa ff ff       	call   1045a2 <get_pte>
  104b81:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  104b84:	74 24                	je     104baa <check_pgdir+0x25e>
  104b86:	c7 44 24 0c 80 6e 10 	movl   $0x106e80,0xc(%esp)
  104b8d:	00 
  104b8e:	c7 44 24 08 11 6d 10 	movl   $0x106d11,0x8(%esp)
  104b95:	00 
  104b96:	c7 44 24 04 f9 01 00 	movl   $0x1f9,0x4(%esp)
  104b9d:	00 
  104b9e:	c7 04 24 ec 6c 10 00 	movl   $0x106cec,(%esp)
  104ba5:	e8 58 c1 ff ff       	call   100d02 <__panic>

    p2 = alloc_page();
  104baa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104bb1:	e8 5a f3 ff ff       	call   103f10 <alloc_pages>
  104bb6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  104bb9:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  104bbe:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  104bc5:	00 
  104bc6:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104bcd:	00 
  104bce:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104bd1:	89 54 24 04          	mov    %edx,0x4(%esp)
  104bd5:	89 04 24             	mov    %eax,(%esp)
  104bd8:	e8 34 fc ff ff       	call   104811 <page_insert>
  104bdd:	85 c0                	test   %eax,%eax
  104bdf:	74 24                	je     104c05 <check_pgdir+0x2b9>
  104be1:	c7 44 24 0c a8 6e 10 	movl   $0x106ea8,0xc(%esp)
  104be8:	00 
  104be9:	c7 44 24 08 11 6d 10 	movl   $0x106d11,0x8(%esp)
  104bf0:	00 
  104bf1:	c7 44 24 04 fc 01 00 	movl   $0x1fc,0x4(%esp)
  104bf8:	00 
  104bf9:	c7 04 24 ec 6c 10 00 	movl   $0x106cec,(%esp)
  104c00:	e8 fd c0 ff ff       	call   100d02 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  104c05:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  104c0a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104c11:	00 
  104c12:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104c19:	00 
  104c1a:	89 04 24             	mov    %eax,(%esp)
  104c1d:	e8 80 f9 ff ff       	call   1045a2 <get_pte>
  104c22:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104c25:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104c29:	75 24                	jne    104c4f <check_pgdir+0x303>
  104c2b:	c7 44 24 0c e0 6e 10 	movl   $0x106ee0,0xc(%esp)
  104c32:	00 
  104c33:	c7 44 24 08 11 6d 10 	movl   $0x106d11,0x8(%esp)
  104c3a:	00 
  104c3b:	c7 44 24 04 fd 01 00 	movl   $0x1fd,0x4(%esp)
  104c42:	00 
  104c43:	c7 04 24 ec 6c 10 00 	movl   $0x106cec,(%esp)
  104c4a:	e8 b3 c0 ff ff       	call   100d02 <__panic>
    assert(*ptep & PTE_U);
  104c4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104c52:	8b 00                	mov    (%eax),%eax
  104c54:	83 e0 04             	and    $0x4,%eax
  104c57:	85 c0                	test   %eax,%eax
  104c59:	75 24                	jne    104c7f <check_pgdir+0x333>
  104c5b:	c7 44 24 0c 10 6f 10 	movl   $0x106f10,0xc(%esp)
  104c62:	00 
  104c63:	c7 44 24 08 11 6d 10 	movl   $0x106d11,0x8(%esp)
  104c6a:	00 
  104c6b:	c7 44 24 04 fe 01 00 	movl   $0x1fe,0x4(%esp)
  104c72:	00 
  104c73:	c7 04 24 ec 6c 10 00 	movl   $0x106cec,(%esp)
  104c7a:	e8 83 c0 ff ff       	call   100d02 <__panic>
    assert(*ptep & PTE_W);
  104c7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104c82:	8b 00                	mov    (%eax),%eax
  104c84:	83 e0 02             	and    $0x2,%eax
  104c87:	85 c0                	test   %eax,%eax
  104c89:	75 24                	jne    104caf <check_pgdir+0x363>
  104c8b:	c7 44 24 0c 1e 6f 10 	movl   $0x106f1e,0xc(%esp)
  104c92:	00 
  104c93:	c7 44 24 08 11 6d 10 	movl   $0x106d11,0x8(%esp)
  104c9a:	00 
  104c9b:	c7 44 24 04 ff 01 00 	movl   $0x1ff,0x4(%esp)
  104ca2:	00 
  104ca3:	c7 04 24 ec 6c 10 00 	movl   $0x106cec,(%esp)
  104caa:	e8 53 c0 ff ff       	call   100d02 <__panic>
    assert(boot_pgdir[0] & PTE_U);
  104caf:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  104cb4:	8b 00                	mov    (%eax),%eax
  104cb6:	83 e0 04             	and    $0x4,%eax
  104cb9:	85 c0                	test   %eax,%eax
  104cbb:	75 24                	jne    104ce1 <check_pgdir+0x395>
  104cbd:	c7 44 24 0c 2c 6f 10 	movl   $0x106f2c,0xc(%esp)
  104cc4:	00 
  104cc5:	c7 44 24 08 11 6d 10 	movl   $0x106d11,0x8(%esp)
  104ccc:	00 
  104ccd:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
  104cd4:	00 
  104cd5:	c7 04 24 ec 6c 10 00 	movl   $0x106cec,(%esp)
  104cdc:	e8 21 c0 ff ff       	call   100d02 <__panic>
    assert(page_ref(p2) == 1);
  104ce1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104ce4:	89 04 24             	mov    %eax,(%esp)
  104ce7:	e8 14 f0 ff ff       	call   103d00 <page_ref>
  104cec:	83 f8 01             	cmp    $0x1,%eax
  104cef:	74 24                	je     104d15 <check_pgdir+0x3c9>
  104cf1:	c7 44 24 0c 42 6f 10 	movl   $0x106f42,0xc(%esp)
  104cf8:	00 
  104cf9:	c7 44 24 08 11 6d 10 	movl   $0x106d11,0x8(%esp)
  104d00:	00 
  104d01:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
  104d08:	00 
  104d09:	c7 04 24 ec 6c 10 00 	movl   $0x106cec,(%esp)
  104d10:	e8 ed bf ff ff       	call   100d02 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  104d15:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  104d1a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  104d21:	00 
  104d22:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104d29:	00 
  104d2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104d2d:	89 54 24 04          	mov    %edx,0x4(%esp)
  104d31:	89 04 24             	mov    %eax,(%esp)
  104d34:	e8 d8 fa ff ff       	call   104811 <page_insert>
  104d39:	85 c0                	test   %eax,%eax
  104d3b:	74 24                	je     104d61 <check_pgdir+0x415>
  104d3d:	c7 44 24 0c 54 6f 10 	movl   $0x106f54,0xc(%esp)
  104d44:	00 
  104d45:	c7 44 24 08 11 6d 10 	movl   $0x106d11,0x8(%esp)
  104d4c:	00 
  104d4d:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
  104d54:	00 
  104d55:	c7 04 24 ec 6c 10 00 	movl   $0x106cec,(%esp)
  104d5c:	e8 a1 bf ff ff       	call   100d02 <__panic>
    assert(page_ref(p1) == 2);
  104d61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104d64:	89 04 24             	mov    %eax,(%esp)
  104d67:	e8 94 ef ff ff       	call   103d00 <page_ref>
  104d6c:	83 f8 02             	cmp    $0x2,%eax
  104d6f:	74 24                	je     104d95 <check_pgdir+0x449>
  104d71:	c7 44 24 0c 80 6f 10 	movl   $0x106f80,0xc(%esp)
  104d78:	00 
  104d79:	c7 44 24 08 11 6d 10 	movl   $0x106d11,0x8(%esp)
  104d80:	00 
  104d81:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
  104d88:	00 
  104d89:	c7 04 24 ec 6c 10 00 	movl   $0x106cec,(%esp)
  104d90:	e8 6d bf ff ff       	call   100d02 <__panic>
    assert(page_ref(p2) == 0);
  104d95:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104d98:	89 04 24             	mov    %eax,(%esp)
  104d9b:	e8 60 ef ff ff       	call   103d00 <page_ref>
  104da0:	85 c0                	test   %eax,%eax
  104da2:	74 24                	je     104dc8 <check_pgdir+0x47c>
  104da4:	c7 44 24 0c 92 6f 10 	movl   $0x106f92,0xc(%esp)
  104dab:	00 
  104dac:	c7 44 24 08 11 6d 10 	movl   $0x106d11,0x8(%esp)
  104db3:	00 
  104db4:	c7 44 24 04 05 02 00 	movl   $0x205,0x4(%esp)
  104dbb:	00 
  104dbc:	c7 04 24 ec 6c 10 00 	movl   $0x106cec,(%esp)
  104dc3:	e8 3a bf ff ff       	call   100d02 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  104dc8:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  104dcd:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104dd4:	00 
  104dd5:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104ddc:	00 
  104ddd:	89 04 24             	mov    %eax,(%esp)
  104de0:	e8 bd f7 ff ff       	call   1045a2 <get_pte>
  104de5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104de8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104dec:	75 24                	jne    104e12 <check_pgdir+0x4c6>
  104dee:	c7 44 24 0c e0 6e 10 	movl   $0x106ee0,0xc(%esp)
  104df5:	00 
  104df6:	c7 44 24 08 11 6d 10 	movl   $0x106d11,0x8(%esp)
  104dfd:	00 
  104dfe:	c7 44 24 04 06 02 00 	movl   $0x206,0x4(%esp)
  104e05:	00 
  104e06:	c7 04 24 ec 6c 10 00 	movl   $0x106cec,(%esp)
  104e0d:	e8 f0 be ff ff       	call   100d02 <__panic>
    assert(pte2page(*ptep) == p1);
  104e12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104e15:	8b 00                	mov    (%eax),%eax
  104e17:	89 04 24             	mov    %eax,(%esp)
  104e1a:	e8 87 ee ff ff       	call   103ca6 <pte2page>
  104e1f:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  104e22:	74 24                	je     104e48 <check_pgdir+0x4fc>
  104e24:	c7 44 24 0c 55 6e 10 	movl   $0x106e55,0xc(%esp)
  104e2b:	00 
  104e2c:	c7 44 24 08 11 6d 10 	movl   $0x106d11,0x8(%esp)
  104e33:	00 
  104e34:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
  104e3b:	00 
  104e3c:	c7 04 24 ec 6c 10 00 	movl   $0x106cec,(%esp)
  104e43:	e8 ba be ff ff       	call   100d02 <__panic>
    assert((*ptep & PTE_U) == 0);
  104e48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104e4b:	8b 00                	mov    (%eax),%eax
  104e4d:	83 e0 04             	and    $0x4,%eax
  104e50:	85 c0                	test   %eax,%eax
  104e52:	74 24                	je     104e78 <check_pgdir+0x52c>
  104e54:	c7 44 24 0c a4 6f 10 	movl   $0x106fa4,0xc(%esp)
  104e5b:	00 
  104e5c:	c7 44 24 08 11 6d 10 	movl   $0x106d11,0x8(%esp)
  104e63:	00 
  104e64:	c7 44 24 04 08 02 00 	movl   $0x208,0x4(%esp)
  104e6b:	00 
  104e6c:	c7 04 24 ec 6c 10 00 	movl   $0x106cec,(%esp)
  104e73:	e8 8a be ff ff       	call   100d02 <__panic>

    page_remove(boot_pgdir, 0x0);
  104e78:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  104e7d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104e84:	00 
  104e85:	89 04 24             	mov    %eax,(%esp)
  104e88:	e8 3d f9 ff ff       	call   1047ca <page_remove>
    assert(page_ref(p1) == 1);
  104e8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104e90:	89 04 24             	mov    %eax,(%esp)
  104e93:	e8 68 ee ff ff       	call   103d00 <page_ref>
  104e98:	83 f8 01             	cmp    $0x1,%eax
  104e9b:	74 24                	je     104ec1 <check_pgdir+0x575>
  104e9d:	c7 44 24 0c 6b 6e 10 	movl   $0x106e6b,0xc(%esp)
  104ea4:	00 
  104ea5:	c7 44 24 08 11 6d 10 	movl   $0x106d11,0x8(%esp)
  104eac:	00 
  104ead:	c7 44 24 04 0b 02 00 	movl   $0x20b,0x4(%esp)
  104eb4:	00 
  104eb5:	c7 04 24 ec 6c 10 00 	movl   $0x106cec,(%esp)
  104ebc:	e8 41 be ff ff       	call   100d02 <__panic>
    assert(page_ref(p2) == 0);
  104ec1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104ec4:	89 04 24             	mov    %eax,(%esp)
  104ec7:	e8 34 ee ff ff       	call   103d00 <page_ref>
  104ecc:	85 c0                	test   %eax,%eax
  104ece:	74 24                	je     104ef4 <check_pgdir+0x5a8>
  104ed0:	c7 44 24 0c 92 6f 10 	movl   $0x106f92,0xc(%esp)
  104ed7:	00 
  104ed8:	c7 44 24 08 11 6d 10 	movl   $0x106d11,0x8(%esp)
  104edf:	00 
  104ee0:	c7 44 24 04 0c 02 00 	movl   $0x20c,0x4(%esp)
  104ee7:	00 
  104ee8:	c7 04 24 ec 6c 10 00 	movl   $0x106cec,(%esp)
  104eef:	e8 0e be ff ff       	call   100d02 <__panic>

    page_remove(boot_pgdir, PGSIZE);
  104ef4:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  104ef9:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104f00:	00 
  104f01:	89 04 24             	mov    %eax,(%esp)
  104f04:	e8 c1 f8 ff ff       	call   1047ca <page_remove>
    assert(page_ref(p1) == 0);
  104f09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104f0c:	89 04 24             	mov    %eax,(%esp)
  104f0f:	e8 ec ed ff ff       	call   103d00 <page_ref>
  104f14:	85 c0                	test   %eax,%eax
  104f16:	74 24                	je     104f3c <check_pgdir+0x5f0>
  104f18:	c7 44 24 0c b9 6f 10 	movl   $0x106fb9,0xc(%esp)
  104f1f:	00 
  104f20:	c7 44 24 08 11 6d 10 	movl   $0x106d11,0x8(%esp)
  104f27:	00 
  104f28:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
  104f2f:	00 
  104f30:	c7 04 24 ec 6c 10 00 	movl   $0x106cec,(%esp)
  104f37:	e8 c6 bd ff ff       	call   100d02 <__panic>
    assert(page_ref(p2) == 0);
  104f3c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104f3f:	89 04 24             	mov    %eax,(%esp)
  104f42:	e8 b9 ed ff ff       	call   103d00 <page_ref>
  104f47:	85 c0                	test   %eax,%eax
  104f49:	74 24                	je     104f6f <check_pgdir+0x623>
  104f4b:	c7 44 24 0c 92 6f 10 	movl   $0x106f92,0xc(%esp)
  104f52:	00 
  104f53:	c7 44 24 08 11 6d 10 	movl   $0x106d11,0x8(%esp)
  104f5a:	00 
  104f5b:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
  104f62:	00 
  104f63:	c7 04 24 ec 6c 10 00 	movl   $0x106cec,(%esp)
  104f6a:	e8 93 bd ff ff       	call   100d02 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
  104f6f:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  104f74:	8b 00                	mov    (%eax),%eax
  104f76:	89 04 24             	mov    %eax,(%esp)
  104f79:	e8 68 ed ff ff       	call   103ce6 <pde2page>
  104f7e:	89 04 24             	mov    %eax,(%esp)
  104f81:	e8 7a ed ff ff       	call   103d00 <page_ref>
  104f86:	83 f8 01             	cmp    $0x1,%eax
  104f89:	74 24                	je     104faf <check_pgdir+0x663>
  104f8b:	c7 44 24 0c cc 6f 10 	movl   $0x106fcc,0xc(%esp)
  104f92:	00 
  104f93:	c7 44 24 08 11 6d 10 	movl   $0x106d11,0x8(%esp)
  104f9a:	00 
  104f9b:	c7 44 24 04 12 02 00 	movl   $0x212,0x4(%esp)
  104fa2:	00 
  104fa3:	c7 04 24 ec 6c 10 00 	movl   $0x106cec,(%esp)
  104faa:	e8 53 bd ff ff       	call   100d02 <__panic>
    free_page(pde2page(boot_pgdir[0]));
  104faf:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  104fb4:	8b 00                	mov    (%eax),%eax
  104fb6:	89 04 24             	mov    %eax,(%esp)
  104fb9:	e8 28 ed ff ff       	call   103ce6 <pde2page>
  104fbe:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104fc5:	00 
  104fc6:	89 04 24             	mov    %eax,(%esp)
  104fc9:	e8 7c ef ff ff       	call   103f4a <free_pages>
    boot_pgdir[0] = 0;
  104fce:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  104fd3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  104fd9:	c7 04 24 f3 6f 10 00 	movl   $0x106ff3,(%esp)
  104fe0:	e8 7c b3 ff ff       	call   100361 <cprintf>
}
  104fe5:	90                   	nop
  104fe6:	89 ec                	mov    %ebp,%esp
  104fe8:	5d                   	pop    %ebp
  104fe9:	c3                   	ret    

00104fea <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
  104fea:	55                   	push   %ebp
  104feb:	89 e5                	mov    %esp,%ebp
  104fed:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  104ff0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104ff7:	e9 ca 00 00 00       	jmp    1050c6 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
  104ffc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104fff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105002:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105005:	c1 e8 0c             	shr    $0xc,%eax
  105008:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10500b:	a1 a4 ce 11 00       	mov    0x11cea4,%eax
  105010:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  105013:	72 23                	jb     105038 <check_boot_pgdir+0x4e>
  105015:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105018:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10501c:	c7 44 24 08 24 6c 10 	movl   $0x106c24,0x8(%esp)
  105023:	00 
  105024:	c7 44 24 04 1e 02 00 	movl   $0x21e,0x4(%esp)
  10502b:	00 
  10502c:	c7 04 24 ec 6c 10 00 	movl   $0x106cec,(%esp)
  105033:	e8 ca bc ff ff       	call   100d02 <__panic>
  105038:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10503b:	2d 00 00 00 40       	sub    $0x40000000,%eax
  105040:	89 c2                	mov    %eax,%edx
  105042:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  105047:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10504e:	00 
  10504f:	89 54 24 04          	mov    %edx,0x4(%esp)
  105053:	89 04 24             	mov    %eax,(%esp)
  105056:	e8 47 f5 ff ff       	call   1045a2 <get_pte>
  10505b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  10505e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  105062:	75 24                	jne    105088 <check_boot_pgdir+0x9e>
  105064:	c7 44 24 0c 10 70 10 	movl   $0x107010,0xc(%esp)
  10506b:	00 
  10506c:	c7 44 24 08 11 6d 10 	movl   $0x106d11,0x8(%esp)
  105073:	00 
  105074:	c7 44 24 04 1e 02 00 	movl   $0x21e,0x4(%esp)
  10507b:	00 
  10507c:	c7 04 24 ec 6c 10 00 	movl   $0x106cec,(%esp)
  105083:	e8 7a bc ff ff       	call   100d02 <__panic>
        assert(PTE_ADDR(*ptep) == i);
  105088:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10508b:	8b 00                	mov    (%eax),%eax
  10508d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  105092:	89 c2                	mov    %eax,%edx
  105094:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105097:	39 c2                	cmp    %eax,%edx
  105099:	74 24                	je     1050bf <check_boot_pgdir+0xd5>
  10509b:	c7 44 24 0c 4d 70 10 	movl   $0x10704d,0xc(%esp)
  1050a2:	00 
  1050a3:	c7 44 24 08 11 6d 10 	movl   $0x106d11,0x8(%esp)
  1050aa:	00 
  1050ab:	c7 44 24 04 1f 02 00 	movl   $0x21f,0x4(%esp)
  1050b2:	00 
  1050b3:	c7 04 24 ec 6c 10 00 	movl   $0x106cec,(%esp)
  1050ba:	e8 43 bc ff ff       	call   100d02 <__panic>
    for (i = 0; i < npage; i += PGSIZE) {
  1050bf:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  1050c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1050c9:	a1 a4 ce 11 00       	mov    0x11cea4,%eax
  1050ce:	39 c2                	cmp    %eax,%edx
  1050d0:	0f 82 26 ff ff ff    	jb     104ffc <check_boot_pgdir+0x12>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  1050d6:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  1050db:	05 ac 0f 00 00       	add    $0xfac,%eax
  1050e0:	8b 00                	mov    (%eax),%eax
  1050e2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1050e7:	89 c2                	mov    %eax,%edx
  1050e9:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  1050ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1050f1:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  1050f8:	77 23                	ja     10511d <check_boot_pgdir+0x133>
  1050fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1050fd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105101:	c7 44 24 08 c8 6c 10 	movl   $0x106cc8,0x8(%esp)
  105108:	00 
  105109:	c7 44 24 04 22 02 00 	movl   $0x222,0x4(%esp)
  105110:	00 
  105111:	c7 04 24 ec 6c 10 00 	movl   $0x106cec,(%esp)
  105118:	e8 e5 bb ff ff       	call   100d02 <__panic>
  10511d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105120:	05 00 00 00 40       	add    $0x40000000,%eax
  105125:	39 d0                	cmp    %edx,%eax
  105127:	74 24                	je     10514d <check_boot_pgdir+0x163>
  105129:	c7 44 24 0c 64 70 10 	movl   $0x107064,0xc(%esp)
  105130:	00 
  105131:	c7 44 24 08 11 6d 10 	movl   $0x106d11,0x8(%esp)
  105138:	00 
  105139:	c7 44 24 04 22 02 00 	movl   $0x222,0x4(%esp)
  105140:	00 
  105141:	c7 04 24 ec 6c 10 00 	movl   $0x106cec,(%esp)
  105148:	e8 b5 bb ff ff       	call   100d02 <__panic>

    assert(boot_pgdir[0] == 0);
  10514d:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  105152:	8b 00                	mov    (%eax),%eax
  105154:	85 c0                	test   %eax,%eax
  105156:	74 24                	je     10517c <check_boot_pgdir+0x192>
  105158:	c7 44 24 0c 98 70 10 	movl   $0x107098,0xc(%esp)
  10515f:	00 
  105160:	c7 44 24 08 11 6d 10 	movl   $0x106d11,0x8(%esp)
  105167:	00 
  105168:	c7 44 24 04 24 02 00 	movl   $0x224,0x4(%esp)
  10516f:	00 
  105170:	c7 04 24 ec 6c 10 00 	movl   $0x106cec,(%esp)
  105177:	e8 86 bb ff ff       	call   100d02 <__panic>

    struct Page *p;
    p = alloc_page();
  10517c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105183:	e8 88 ed ff ff       	call   103f10 <alloc_pages>
  105188:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  10518b:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  105190:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  105197:	00 
  105198:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
  10519f:	00 
  1051a0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1051a3:	89 54 24 04          	mov    %edx,0x4(%esp)
  1051a7:	89 04 24             	mov    %eax,(%esp)
  1051aa:	e8 62 f6 ff ff       	call   104811 <page_insert>
  1051af:	85 c0                	test   %eax,%eax
  1051b1:	74 24                	je     1051d7 <check_boot_pgdir+0x1ed>
  1051b3:	c7 44 24 0c ac 70 10 	movl   $0x1070ac,0xc(%esp)
  1051ba:	00 
  1051bb:	c7 44 24 08 11 6d 10 	movl   $0x106d11,0x8(%esp)
  1051c2:	00 
  1051c3:	c7 44 24 04 28 02 00 	movl   $0x228,0x4(%esp)
  1051ca:	00 
  1051cb:	c7 04 24 ec 6c 10 00 	movl   $0x106cec,(%esp)
  1051d2:	e8 2b bb ff ff       	call   100d02 <__panic>
    assert(page_ref(p) == 1);
  1051d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1051da:	89 04 24             	mov    %eax,(%esp)
  1051dd:	e8 1e eb ff ff       	call   103d00 <page_ref>
  1051e2:	83 f8 01             	cmp    $0x1,%eax
  1051e5:	74 24                	je     10520b <check_boot_pgdir+0x221>
  1051e7:	c7 44 24 0c da 70 10 	movl   $0x1070da,0xc(%esp)
  1051ee:	00 
  1051ef:	c7 44 24 08 11 6d 10 	movl   $0x106d11,0x8(%esp)
  1051f6:	00 
  1051f7:	c7 44 24 04 29 02 00 	movl   $0x229,0x4(%esp)
  1051fe:	00 
  1051ff:	c7 04 24 ec 6c 10 00 	movl   $0x106cec,(%esp)
  105206:	e8 f7 ba ff ff       	call   100d02 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  10520b:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  105210:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  105217:	00 
  105218:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
  10521f:	00 
  105220:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105223:	89 54 24 04          	mov    %edx,0x4(%esp)
  105227:	89 04 24             	mov    %eax,(%esp)
  10522a:	e8 e2 f5 ff ff       	call   104811 <page_insert>
  10522f:	85 c0                	test   %eax,%eax
  105231:	74 24                	je     105257 <check_boot_pgdir+0x26d>
  105233:	c7 44 24 0c ec 70 10 	movl   $0x1070ec,0xc(%esp)
  10523a:	00 
  10523b:	c7 44 24 08 11 6d 10 	movl   $0x106d11,0x8(%esp)
  105242:	00 
  105243:	c7 44 24 04 2a 02 00 	movl   $0x22a,0x4(%esp)
  10524a:	00 
  10524b:	c7 04 24 ec 6c 10 00 	movl   $0x106cec,(%esp)
  105252:	e8 ab ba ff ff       	call   100d02 <__panic>
    assert(page_ref(p) == 2);
  105257:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10525a:	89 04 24             	mov    %eax,(%esp)
  10525d:	e8 9e ea ff ff       	call   103d00 <page_ref>
  105262:	83 f8 02             	cmp    $0x2,%eax
  105265:	74 24                	je     10528b <check_boot_pgdir+0x2a1>
  105267:	c7 44 24 0c 23 71 10 	movl   $0x107123,0xc(%esp)
  10526e:	00 
  10526f:	c7 44 24 08 11 6d 10 	movl   $0x106d11,0x8(%esp)
  105276:	00 
  105277:	c7 44 24 04 2b 02 00 	movl   $0x22b,0x4(%esp)
  10527e:	00 
  10527f:	c7 04 24 ec 6c 10 00 	movl   $0x106cec,(%esp)
  105286:	e8 77 ba ff ff       	call   100d02 <__panic>

    const char *str = "ucore: Hello world!!";
  10528b:	c7 45 e8 34 71 10 00 	movl   $0x107134,-0x18(%ebp)
    strcpy((void *)0x100, str);
  105292:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105295:	89 44 24 04          	mov    %eax,0x4(%esp)
  105299:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  1052a0:	e8 fc 09 00 00       	call   105ca1 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
  1052a5:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
  1052ac:	00 
  1052ad:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  1052b4:	e8 60 0a 00 00       	call   105d19 <strcmp>
  1052b9:	85 c0                	test   %eax,%eax
  1052bb:	74 24                	je     1052e1 <check_boot_pgdir+0x2f7>
  1052bd:	c7 44 24 0c 4c 71 10 	movl   $0x10714c,0xc(%esp)
  1052c4:	00 
  1052c5:	c7 44 24 08 11 6d 10 	movl   $0x106d11,0x8(%esp)
  1052cc:	00 
  1052cd:	c7 44 24 04 2f 02 00 	movl   $0x22f,0x4(%esp)
  1052d4:	00 
  1052d5:	c7 04 24 ec 6c 10 00 	movl   $0x106cec,(%esp)
  1052dc:	e8 21 ba ff ff       	call   100d02 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
  1052e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1052e4:	89 04 24             	mov    %eax,(%esp)
  1052e7:	e8 64 e9 ff ff       	call   103c50 <page2kva>
  1052ec:	05 00 01 00 00       	add    $0x100,%eax
  1052f1:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
  1052f4:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  1052fb:	e8 47 09 00 00       	call   105c47 <strlen>
  105300:	85 c0                	test   %eax,%eax
  105302:	74 24                	je     105328 <check_boot_pgdir+0x33e>
  105304:	c7 44 24 0c 84 71 10 	movl   $0x107184,0xc(%esp)
  10530b:	00 
  10530c:	c7 44 24 08 11 6d 10 	movl   $0x106d11,0x8(%esp)
  105313:	00 
  105314:	c7 44 24 04 32 02 00 	movl   $0x232,0x4(%esp)
  10531b:	00 
  10531c:	c7 04 24 ec 6c 10 00 	movl   $0x106cec,(%esp)
  105323:	e8 da b9 ff ff       	call   100d02 <__panic>

    free_page(p);
  105328:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10532f:	00 
  105330:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105333:	89 04 24             	mov    %eax,(%esp)
  105336:	e8 0f ec ff ff       	call   103f4a <free_pages>
    free_page(pde2page(boot_pgdir[0]));
  10533b:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  105340:	8b 00                	mov    (%eax),%eax
  105342:	89 04 24             	mov    %eax,(%esp)
  105345:	e8 9c e9 ff ff       	call   103ce6 <pde2page>
  10534a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105351:	00 
  105352:	89 04 24             	mov    %eax,(%esp)
  105355:	e8 f0 eb ff ff       	call   103f4a <free_pages>
    boot_pgdir[0] = 0;
  10535a:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  10535f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  105365:	c7 04 24 a8 71 10 00 	movl   $0x1071a8,(%esp)
  10536c:	e8 f0 af ff ff       	call   100361 <cprintf>
}
  105371:	90                   	nop
  105372:	89 ec                	mov    %ebp,%esp
  105374:	5d                   	pop    %ebp
  105375:	c3                   	ret    

00105376 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
  105376:	55                   	push   %ebp
  105377:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  105379:	8b 45 08             	mov    0x8(%ebp),%eax
  10537c:	83 e0 04             	and    $0x4,%eax
  10537f:	85 c0                	test   %eax,%eax
  105381:	74 04                	je     105387 <perm2str+0x11>
  105383:	b0 75                	mov    $0x75,%al
  105385:	eb 02                	jmp    105389 <perm2str+0x13>
  105387:	b0 2d                	mov    $0x2d,%al
  105389:	a2 28 cf 11 00       	mov    %al,0x11cf28
    str[1] = 'r';
  10538e:	c6 05 29 cf 11 00 72 	movb   $0x72,0x11cf29
    str[2] = (perm & PTE_W) ? 'w' : '-';
  105395:	8b 45 08             	mov    0x8(%ebp),%eax
  105398:	83 e0 02             	and    $0x2,%eax
  10539b:	85 c0                	test   %eax,%eax
  10539d:	74 04                	je     1053a3 <perm2str+0x2d>
  10539f:	b0 77                	mov    $0x77,%al
  1053a1:	eb 02                	jmp    1053a5 <perm2str+0x2f>
  1053a3:	b0 2d                	mov    $0x2d,%al
  1053a5:	a2 2a cf 11 00       	mov    %al,0x11cf2a
    str[3] = '\0';
  1053aa:	c6 05 2b cf 11 00 00 	movb   $0x0,0x11cf2b
    return str;
  1053b1:	b8 28 cf 11 00       	mov    $0x11cf28,%eax
}
  1053b6:	5d                   	pop    %ebp
  1053b7:	c3                   	ret    

001053b8 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
  1053b8:	55                   	push   %ebp
  1053b9:	89 e5                	mov    %esp,%ebp
  1053bb:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
  1053be:	8b 45 10             	mov    0x10(%ebp),%eax
  1053c1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1053c4:	72 0d                	jb     1053d3 <get_pgtable_items+0x1b>
        return 0;
  1053c6:	b8 00 00 00 00       	mov    $0x0,%eax
  1053cb:	e9 98 00 00 00       	jmp    105468 <get_pgtable_items+0xb0>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
  1053d0:	ff 45 10             	incl   0x10(%ebp)
    while (start < right && !(table[start] & PTE_P)) {
  1053d3:	8b 45 10             	mov    0x10(%ebp),%eax
  1053d6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1053d9:	73 18                	jae    1053f3 <get_pgtable_items+0x3b>
  1053db:	8b 45 10             	mov    0x10(%ebp),%eax
  1053de:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1053e5:	8b 45 14             	mov    0x14(%ebp),%eax
  1053e8:	01 d0                	add    %edx,%eax
  1053ea:	8b 00                	mov    (%eax),%eax
  1053ec:	83 e0 01             	and    $0x1,%eax
  1053ef:	85 c0                	test   %eax,%eax
  1053f1:	74 dd                	je     1053d0 <get_pgtable_items+0x18>
    }
    if (start < right) {
  1053f3:	8b 45 10             	mov    0x10(%ebp),%eax
  1053f6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1053f9:	73 68                	jae    105463 <get_pgtable_items+0xab>
        if (left_store != NULL) {
  1053fb:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  1053ff:	74 08                	je     105409 <get_pgtable_items+0x51>
            *left_store = start;
  105401:	8b 45 18             	mov    0x18(%ebp),%eax
  105404:	8b 55 10             	mov    0x10(%ebp),%edx
  105407:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
  105409:	8b 45 10             	mov    0x10(%ebp),%eax
  10540c:	8d 50 01             	lea    0x1(%eax),%edx
  10540f:	89 55 10             	mov    %edx,0x10(%ebp)
  105412:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  105419:	8b 45 14             	mov    0x14(%ebp),%eax
  10541c:	01 d0                	add    %edx,%eax
  10541e:	8b 00                	mov    (%eax),%eax
  105420:	83 e0 07             	and    $0x7,%eax
  105423:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  105426:	eb 03                	jmp    10542b <get_pgtable_items+0x73>
            start ++;
  105428:	ff 45 10             	incl   0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  10542b:	8b 45 10             	mov    0x10(%ebp),%eax
  10542e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105431:	73 1d                	jae    105450 <get_pgtable_items+0x98>
  105433:	8b 45 10             	mov    0x10(%ebp),%eax
  105436:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  10543d:	8b 45 14             	mov    0x14(%ebp),%eax
  105440:	01 d0                	add    %edx,%eax
  105442:	8b 00                	mov    (%eax),%eax
  105444:	83 e0 07             	and    $0x7,%eax
  105447:	89 c2                	mov    %eax,%edx
  105449:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10544c:	39 c2                	cmp    %eax,%edx
  10544e:	74 d8                	je     105428 <get_pgtable_items+0x70>
        }
        if (right_store != NULL) {
  105450:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  105454:	74 08                	je     10545e <get_pgtable_items+0xa6>
            *right_store = start;
  105456:	8b 45 1c             	mov    0x1c(%ebp),%eax
  105459:	8b 55 10             	mov    0x10(%ebp),%edx
  10545c:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  10545e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105461:	eb 05                	jmp    105468 <get_pgtable_items+0xb0>
    }
    return 0;
  105463:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105468:	89 ec                	mov    %ebp,%esp
  10546a:	5d                   	pop    %ebp
  10546b:	c3                   	ret    

0010546c <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  10546c:	55                   	push   %ebp
  10546d:	89 e5                	mov    %esp,%ebp
  10546f:	57                   	push   %edi
  105470:	56                   	push   %esi
  105471:	53                   	push   %ebx
  105472:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
  105475:	c7 04 24 c8 71 10 00 	movl   $0x1071c8,(%esp)
  10547c:	e8 e0 ae ff ff       	call   100361 <cprintf>
    size_t left, right = 0, perm;
  105481:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  105488:	e9 f2 00 00 00       	jmp    10557f <print_pgdir+0x113>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  10548d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105490:	89 04 24             	mov    %eax,(%esp)
  105493:	e8 de fe ff ff       	call   105376 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  105498:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10549b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  10549e:	29 ca                	sub    %ecx,%edx
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  1054a0:	89 d6                	mov    %edx,%esi
  1054a2:	c1 e6 16             	shl    $0x16,%esi
  1054a5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1054a8:	89 d3                	mov    %edx,%ebx
  1054aa:	c1 e3 16             	shl    $0x16,%ebx
  1054ad:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1054b0:	89 d1                	mov    %edx,%ecx
  1054b2:	c1 e1 16             	shl    $0x16,%ecx
  1054b5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1054b8:	8b 7d e0             	mov    -0x20(%ebp),%edi
  1054bb:	29 fa                	sub    %edi,%edx
  1054bd:	89 44 24 14          	mov    %eax,0x14(%esp)
  1054c1:	89 74 24 10          	mov    %esi,0x10(%esp)
  1054c5:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1054c9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1054cd:	89 54 24 04          	mov    %edx,0x4(%esp)
  1054d1:	c7 04 24 f9 71 10 00 	movl   $0x1071f9,(%esp)
  1054d8:	e8 84 ae ff ff       	call   100361 <cprintf>
        size_t l, r = left * NPTEENTRY;
  1054dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1054e0:	c1 e0 0a             	shl    $0xa,%eax
  1054e3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  1054e6:	eb 50                	jmp    105538 <print_pgdir+0xcc>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  1054e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1054eb:	89 04 24             	mov    %eax,(%esp)
  1054ee:	e8 83 fe ff ff       	call   105376 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  1054f3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1054f6:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  1054f9:	29 ca                	sub    %ecx,%edx
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  1054fb:	89 d6                	mov    %edx,%esi
  1054fd:	c1 e6 0c             	shl    $0xc,%esi
  105500:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  105503:	89 d3                	mov    %edx,%ebx
  105505:	c1 e3 0c             	shl    $0xc,%ebx
  105508:	8b 55 d8             	mov    -0x28(%ebp),%edx
  10550b:	89 d1                	mov    %edx,%ecx
  10550d:	c1 e1 0c             	shl    $0xc,%ecx
  105510:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  105513:	8b 7d d8             	mov    -0x28(%ebp),%edi
  105516:	29 fa                	sub    %edi,%edx
  105518:	89 44 24 14          	mov    %eax,0x14(%esp)
  10551c:	89 74 24 10          	mov    %esi,0x10(%esp)
  105520:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  105524:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  105528:	89 54 24 04          	mov    %edx,0x4(%esp)
  10552c:	c7 04 24 18 72 10 00 	movl   $0x107218,(%esp)
  105533:	e8 29 ae ff ff       	call   100361 <cprintf>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  105538:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
  10553d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  105540:	8b 55 dc             	mov    -0x24(%ebp),%edx
  105543:	89 d3                	mov    %edx,%ebx
  105545:	c1 e3 0a             	shl    $0xa,%ebx
  105548:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10554b:	89 d1                	mov    %edx,%ecx
  10554d:	c1 e1 0a             	shl    $0xa,%ecx
  105550:	8d 55 d4             	lea    -0x2c(%ebp),%edx
  105553:	89 54 24 14          	mov    %edx,0x14(%esp)
  105557:	8d 55 d8             	lea    -0x28(%ebp),%edx
  10555a:	89 54 24 10          	mov    %edx,0x10(%esp)
  10555e:	89 74 24 0c          	mov    %esi,0xc(%esp)
  105562:	89 44 24 08          	mov    %eax,0x8(%esp)
  105566:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  10556a:	89 0c 24             	mov    %ecx,(%esp)
  10556d:	e8 46 fe ff ff       	call   1053b8 <get_pgtable_items>
  105572:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105575:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105579:	0f 85 69 ff ff ff    	jne    1054e8 <print_pgdir+0x7c>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  10557f:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
  105584:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105587:	8d 55 dc             	lea    -0x24(%ebp),%edx
  10558a:	89 54 24 14          	mov    %edx,0x14(%esp)
  10558e:	8d 55 e0             	lea    -0x20(%ebp),%edx
  105591:	89 54 24 10          	mov    %edx,0x10(%esp)
  105595:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  105599:	89 44 24 08          	mov    %eax,0x8(%esp)
  10559d:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
  1055a4:	00 
  1055a5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1055ac:	e8 07 fe ff ff       	call   1053b8 <get_pgtable_items>
  1055b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1055b4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1055b8:	0f 85 cf fe ff ff    	jne    10548d <print_pgdir+0x21>
        }
    }
    cprintf("--------------------- END ---------------------\n");
  1055be:	c7 04 24 3c 72 10 00 	movl   $0x10723c,(%esp)
  1055c5:	e8 97 ad ff ff       	call   100361 <cprintf>
}
  1055ca:	90                   	nop
  1055cb:	83 c4 4c             	add    $0x4c,%esp
  1055ce:	5b                   	pop    %ebx
  1055cf:	5e                   	pop    %esi
  1055d0:	5f                   	pop    %edi
  1055d1:	5d                   	pop    %ebp
  1055d2:	c3                   	ret    

001055d3 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  1055d3:	55                   	push   %ebp
  1055d4:	89 e5                	mov    %esp,%ebp
  1055d6:	83 ec 58             	sub    $0x58,%esp
  1055d9:	8b 45 10             	mov    0x10(%ebp),%eax
  1055dc:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1055df:	8b 45 14             	mov    0x14(%ebp),%eax
  1055e2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  1055e5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1055e8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1055eb:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1055ee:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  1055f1:	8b 45 18             	mov    0x18(%ebp),%eax
  1055f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1055f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1055fa:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1055fd:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105600:	89 55 f0             	mov    %edx,-0x10(%ebp)
  105603:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105606:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105609:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10560d:	74 1c                	je     10562b <printnum+0x58>
  10560f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105612:	ba 00 00 00 00       	mov    $0x0,%edx
  105617:	f7 75 e4             	divl   -0x1c(%ebp)
  10561a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  10561d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105620:	ba 00 00 00 00       	mov    $0x0,%edx
  105625:	f7 75 e4             	divl   -0x1c(%ebp)
  105628:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10562b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10562e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105631:	f7 75 e4             	divl   -0x1c(%ebp)
  105634:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105637:	89 55 dc             	mov    %edx,-0x24(%ebp)
  10563a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10563d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105640:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105643:	89 55 ec             	mov    %edx,-0x14(%ebp)
  105646:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105649:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  10564c:	8b 45 18             	mov    0x18(%ebp),%eax
  10564f:	ba 00 00 00 00       	mov    $0x0,%edx
  105654:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  105657:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  10565a:	19 d1                	sbb    %edx,%ecx
  10565c:	72 4c                	jb     1056aa <printnum+0xd7>
        printnum(putch, putdat, result, base, width - 1, padc);
  10565e:	8b 45 1c             	mov    0x1c(%ebp),%eax
  105661:	8d 50 ff             	lea    -0x1(%eax),%edx
  105664:	8b 45 20             	mov    0x20(%ebp),%eax
  105667:	89 44 24 18          	mov    %eax,0x18(%esp)
  10566b:	89 54 24 14          	mov    %edx,0x14(%esp)
  10566f:	8b 45 18             	mov    0x18(%ebp),%eax
  105672:	89 44 24 10          	mov    %eax,0x10(%esp)
  105676:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105679:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10567c:	89 44 24 08          	mov    %eax,0x8(%esp)
  105680:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105684:	8b 45 0c             	mov    0xc(%ebp),%eax
  105687:	89 44 24 04          	mov    %eax,0x4(%esp)
  10568b:	8b 45 08             	mov    0x8(%ebp),%eax
  10568e:	89 04 24             	mov    %eax,(%esp)
  105691:	e8 3d ff ff ff       	call   1055d3 <printnum>
  105696:	eb 1b                	jmp    1056b3 <printnum+0xe0>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  105698:	8b 45 0c             	mov    0xc(%ebp),%eax
  10569b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10569f:	8b 45 20             	mov    0x20(%ebp),%eax
  1056a2:	89 04 24             	mov    %eax,(%esp)
  1056a5:	8b 45 08             	mov    0x8(%ebp),%eax
  1056a8:	ff d0                	call   *%eax
        while (-- width > 0)
  1056aa:	ff 4d 1c             	decl   0x1c(%ebp)
  1056ad:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  1056b1:	7f e5                	jg     105698 <printnum+0xc5>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  1056b3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1056b6:	05 f0 72 10 00       	add    $0x1072f0,%eax
  1056bb:	0f b6 00             	movzbl (%eax),%eax
  1056be:	0f be c0             	movsbl %al,%eax
  1056c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  1056c4:	89 54 24 04          	mov    %edx,0x4(%esp)
  1056c8:	89 04 24             	mov    %eax,(%esp)
  1056cb:	8b 45 08             	mov    0x8(%ebp),%eax
  1056ce:	ff d0                	call   *%eax
}
  1056d0:	90                   	nop
  1056d1:	89 ec                	mov    %ebp,%esp
  1056d3:	5d                   	pop    %ebp
  1056d4:	c3                   	ret    

001056d5 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  1056d5:	55                   	push   %ebp
  1056d6:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  1056d8:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  1056dc:	7e 14                	jle    1056f2 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  1056de:	8b 45 08             	mov    0x8(%ebp),%eax
  1056e1:	8b 00                	mov    (%eax),%eax
  1056e3:	8d 48 08             	lea    0x8(%eax),%ecx
  1056e6:	8b 55 08             	mov    0x8(%ebp),%edx
  1056e9:	89 0a                	mov    %ecx,(%edx)
  1056eb:	8b 50 04             	mov    0x4(%eax),%edx
  1056ee:	8b 00                	mov    (%eax),%eax
  1056f0:	eb 30                	jmp    105722 <getuint+0x4d>
    }
    else if (lflag) {
  1056f2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1056f6:	74 16                	je     10570e <getuint+0x39>
        return va_arg(*ap, unsigned long);
  1056f8:	8b 45 08             	mov    0x8(%ebp),%eax
  1056fb:	8b 00                	mov    (%eax),%eax
  1056fd:	8d 48 04             	lea    0x4(%eax),%ecx
  105700:	8b 55 08             	mov    0x8(%ebp),%edx
  105703:	89 0a                	mov    %ecx,(%edx)
  105705:	8b 00                	mov    (%eax),%eax
  105707:	ba 00 00 00 00       	mov    $0x0,%edx
  10570c:	eb 14                	jmp    105722 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  10570e:	8b 45 08             	mov    0x8(%ebp),%eax
  105711:	8b 00                	mov    (%eax),%eax
  105713:	8d 48 04             	lea    0x4(%eax),%ecx
  105716:	8b 55 08             	mov    0x8(%ebp),%edx
  105719:	89 0a                	mov    %ecx,(%edx)
  10571b:	8b 00                	mov    (%eax),%eax
  10571d:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  105722:	5d                   	pop    %ebp
  105723:	c3                   	ret    

00105724 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  105724:	55                   	push   %ebp
  105725:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  105727:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  10572b:	7e 14                	jle    105741 <getint+0x1d>
        return va_arg(*ap, long long);
  10572d:	8b 45 08             	mov    0x8(%ebp),%eax
  105730:	8b 00                	mov    (%eax),%eax
  105732:	8d 48 08             	lea    0x8(%eax),%ecx
  105735:	8b 55 08             	mov    0x8(%ebp),%edx
  105738:	89 0a                	mov    %ecx,(%edx)
  10573a:	8b 50 04             	mov    0x4(%eax),%edx
  10573d:	8b 00                	mov    (%eax),%eax
  10573f:	eb 28                	jmp    105769 <getint+0x45>
    }
    else if (lflag) {
  105741:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105745:	74 12                	je     105759 <getint+0x35>
        return va_arg(*ap, long);
  105747:	8b 45 08             	mov    0x8(%ebp),%eax
  10574a:	8b 00                	mov    (%eax),%eax
  10574c:	8d 48 04             	lea    0x4(%eax),%ecx
  10574f:	8b 55 08             	mov    0x8(%ebp),%edx
  105752:	89 0a                	mov    %ecx,(%edx)
  105754:	8b 00                	mov    (%eax),%eax
  105756:	99                   	cltd   
  105757:	eb 10                	jmp    105769 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  105759:	8b 45 08             	mov    0x8(%ebp),%eax
  10575c:	8b 00                	mov    (%eax),%eax
  10575e:	8d 48 04             	lea    0x4(%eax),%ecx
  105761:	8b 55 08             	mov    0x8(%ebp),%edx
  105764:	89 0a                	mov    %ecx,(%edx)
  105766:	8b 00                	mov    (%eax),%eax
  105768:	99                   	cltd   
    }
}
  105769:	5d                   	pop    %ebp
  10576a:	c3                   	ret    

0010576b <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  10576b:	55                   	push   %ebp
  10576c:	89 e5                	mov    %esp,%ebp
  10576e:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  105771:	8d 45 14             	lea    0x14(%ebp),%eax
  105774:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  105777:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10577a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10577e:	8b 45 10             	mov    0x10(%ebp),%eax
  105781:	89 44 24 08          	mov    %eax,0x8(%esp)
  105785:	8b 45 0c             	mov    0xc(%ebp),%eax
  105788:	89 44 24 04          	mov    %eax,0x4(%esp)
  10578c:	8b 45 08             	mov    0x8(%ebp),%eax
  10578f:	89 04 24             	mov    %eax,(%esp)
  105792:	e8 05 00 00 00       	call   10579c <vprintfmt>
    va_end(ap);
}
  105797:	90                   	nop
  105798:	89 ec                	mov    %ebp,%esp
  10579a:	5d                   	pop    %ebp
  10579b:	c3                   	ret    

0010579c <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  10579c:	55                   	push   %ebp
  10579d:	89 e5                	mov    %esp,%ebp
  10579f:	56                   	push   %esi
  1057a0:	53                   	push   %ebx
  1057a1:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1057a4:	eb 17                	jmp    1057bd <vprintfmt+0x21>
            if (ch == '\0') {
  1057a6:	85 db                	test   %ebx,%ebx
  1057a8:	0f 84 bf 03 00 00    	je     105b6d <vprintfmt+0x3d1>
                return;
            }
            putch(ch, putdat);
  1057ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  1057b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1057b5:	89 1c 24             	mov    %ebx,(%esp)
  1057b8:	8b 45 08             	mov    0x8(%ebp),%eax
  1057bb:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1057bd:	8b 45 10             	mov    0x10(%ebp),%eax
  1057c0:	8d 50 01             	lea    0x1(%eax),%edx
  1057c3:	89 55 10             	mov    %edx,0x10(%ebp)
  1057c6:	0f b6 00             	movzbl (%eax),%eax
  1057c9:	0f b6 d8             	movzbl %al,%ebx
  1057cc:	83 fb 25             	cmp    $0x25,%ebx
  1057cf:	75 d5                	jne    1057a6 <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
  1057d1:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  1057d5:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  1057dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1057df:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  1057e2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  1057e9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1057ec:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  1057ef:	8b 45 10             	mov    0x10(%ebp),%eax
  1057f2:	8d 50 01             	lea    0x1(%eax),%edx
  1057f5:	89 55 10             	mov    %edx,0x10(%ebp)
  1057f8:	0f b6 00             	movzbl (%eax),%eax
  1057fb:	0f b6 d8             	movzbl %al,%ebx
  1057fe:	8d 43 dd             	lea    -0x23(%ebx),%eax
  105801:	83 f8 55             	cmp    $0x55,%eax
  105804:	0f 87 37 03 00 00    	ja     105b41 <vprintfmt+0x3a5>
  10580a:	8b 04 85 14 73 10 00 	mov    0x107314(,%eax,4),%eax
  105811:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  105813:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  105817:	eb d6                	jmp    1057ef <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  105819:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  10581d:	eb d0                	jmp    1057ef <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  10581f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  105826:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105829:	89 d0                	mov    %edx,%eax
  10582b:	c1 e0 02             	shl    $0x2,%eax
  10582e:	01 d0                	add    %edx,%eax
  105830:	01 c0                	add    %eax,%eax
  105832:	01 d8                	add    %ebx,%eax
  105834:	83 e8 30             	sub    $0x30,%eax
  105837:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  10583a:	8b 45 10             	mov    0x10(%ebp),%eax
  10583d:	0f b6 00             	movzbl (%eax),%eax
  105840:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  105843:	83 fb 2f             	cmp    $0x2f,%ebx
  105846:	7e 38                	jle    105880 <vprintfmt+0xe4>
  105848:	83 fb 39             	cmp    $0x39,%ebx
  10584b:	7f 33                	jg     105880 <vprintfmt+0xe4>
            for (precision = 0; ; ++ fmt) {
  10584d:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
  105850:	eb d4                	jmp    105826 <vprintfmt+0x8a>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  105852:	8b 45 14             	mov    0x14(%ebp),%eax
  105855:	8d 50 04             	lea    0x4(%eax),%edx
  105858:	89 55 14             	mov    %edx,0x14(%ebp)
  10585b:	8b 00                	mov    (%eax),%eax
  10585d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  105860:	eb 1f                	jmp    105881 <vprintfmt+0xe5>

        case '.':
            if (width < 0)
  105862:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105866:	79 87                	jns    1057ef <vprintfmt+0x53>
                width = 0;
  105868:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  10586f:	e9 7b ff ff ff       	jmp    1057ef <vprintfmt+0x53>

        case '#':
            altflag = 1;
  105874:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  10587b:	e9 6f ff ff ff       	jmp    1057ef <vprintfmt+0x53>
            goto process_precision;
  105880:	90                   	nop

        process_precision:
            if (width < 0)
  105881:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105885:	0f 89 64 ff ff ff    	jns    1057ef <vprintfmt+0x53>
                width = precision, precision = -1;
  10588b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10588e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105891:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  105898:	e9 52 ff ff ff       	jmp    1057ef <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  10589d:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
  1058a0:	e9 4a ff ff ff       	jmp    1057ef <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  1058a5:	8b 45 14             	mov    0x14(%ebp),%eax
  1058a8:	8d 50 04             	lea    0x4(%eax),%edx
  1058ab:	89 55 14             	mov    %edx,0x14(%ebp)
  1058ae:	8b 00                	mov    (%eax),%eax
  1058b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  1058b3:	89 54 24 04          	mov    %edx,0x4(%esp)
  1058b7:	89 04 24             	mov    %eax,(%esp)
  1058ba:	8b 45 08             	mov    0x8(%ebp),%eax
  1058bd:	ff d0                	call   *%eax
            break;
  1058bf:	e9 a4 02 00 00       	jmp    105b68 <vprintfmt+0x3cc>

        // error message
        case 'e':
            err = va_arg(ap, int);
  1058c4:	8b 45 14             	mov    0x14(%ebp),%eax
  1058c7:	8d 50 04             	lea    0x4(%eax),%edx
  1058ca:	89 55 14             	mov    %edx,0x14(%ebp)
  1058cd:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  1058cf:	85 db                	test   %ebx,%ebx
  1058d1:	79 02                	jns    1058d5 <vprintfmt+0x139>
                err = -err;
  1058d3:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  1058d5:	83 fb 06             	cmp    $0x6,%ebx
  1058d8:	7f 0b                	jg     1058e5 <vprintfmt+0x149>
  1058da:	8b 34 9d d4 72 10 00 	mov    0x1072d4(,%ebx,4),%esi
  1058e1:	85 f6                	test   %esi,%esi
  1058e3:	75 23                	jne    105908 <vprintfmt+0x16c>
                printfmt(putch, putdat, "error %d", err);
  1058e5:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1058e9:	c7 44 24 08 01 73 10 	movl   $0x107301,0x8(%esp)
  1058f0:	00 
  1058f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1058f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058f8:	8b 45 08             	mov    0x8(%ebp),%eax
  1058fb:	89 04 24             	mov    %eax,(%esp)
  1058fe:	e8 68 fe ff ff       	call   10576b <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  105903:	e9 60 02 00 00       	jmp    105b68 <vprintfmt+0x3cc>
                printfmt(putch, putdat, "%s", p);
  105908:	89 74 24 0c          	mov    %esi,0xc(%esp)
  10590c:	c7 44 24 08 0a 73 10 	movl   $0x10730a,0x8(%esp)
  105913:	00 
  105914:	8b 45 0c             	mov    0xc(%ebp),%eax
  105917:	89 44 24 04          	mov    %eax,0x4(%esp)
  10591b:	8b 45 08             	mov    0x8(%ebp),%eax
  10591e:	89 04 24             	mov    %eax,(%esp)
  105921:	e8 45 fe ff ff       	call   10576b <printfmt>
            break;
  105926:	e9 3d 02 00 00       	jmp    105b68 <vprintfmt+0x3cc>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  10592b:	8b 45 14             	mov    0x14(%ebp),%eax
  10592e:	8d 50 04             	lea    0x4(%eax),%edx
  105931:	89 55 14             	mov    %edx,0x14(%ebp)
  105934:	8b 30                	mov    (%eax),%esi
  105936:	85 f6                	test   %esi,%esi
  105938:	75 05                	jne    10593f <vprintfmt+0x1a3>
                p = "(null)";
  10593a:	be 0d 73 10 00       	mov    $0x10730d,%esi
            }
            if (width > 0 && padc != '-') {
  10593f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105943:	7e 76                	jle    1059bb <vprintfmt+0x21f>
  105945:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  105949:	74 70                	je     1059bb <vprintfmt+0x21f>
                for (width -= strnlen(p, precision); width > 0; width --) {
  10594b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10594e:	89 44 24 04          	mov    %eax,0x4(%esp)
  105952:	89 34 24             	mov    %esi,(%esp)
  105955:	e8 16 03 00 00       	call   105c70 <strnlen>
  10595a:	89 c2                	mov    %eax,%edx
  10595c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10595f:	29 d0                	sub    %edx,%eax
  105961:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105964:	eb 16                	jmp    10597c <vprintfmt+0x1e0>
                    putch(padc, putdat);
  105966:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  10596a:	8b 55 0c             	mov    0xc(%ebp),%edx
  10596d:	89 54 24 04          	mov    %edx,0x4(%esp)
  105971:	89 04 24             	mov    %eax,(%esp)
  105974:	8b 45 08             	mov    0x8(%ebp),%eax
  105977:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
  105979:	ff 4d e8             	decl   -0x18(%ebp)
  10597c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105980:	7f e4                	jg     105966 <vprintfmt+0x1ca>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  105982:	eb 37                	jmp    1059bb <vprintfmt+0x21f>
                if (altflag && (ch < ' ' || ch > '~')) {
  105984:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  105988:	74 1f                	je     1059a9 <vprintfmt+0x20d>
  10598a:	83 fb 1f             	cmp    $0x1f,%ebx
  10598d:	7e 05                	jle    105994 <vprintfmt+0x1f8>
  10598f:	83 fb 7e             	cmp    $0x7e,%ebx
  105992:	7e 15                	jle    1059a9 <vprintfmt+0x20d>
                    putch('?', putdat);
  105994:	8b 45 0c             	mov    0xc(%ebp),%eax
  105997:	89 44 24 04          	mov    %eax,0x4(%esp)
  10599b:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  1059a2:	8b 45 08             	mov    0x8(%ebp),%eax
  1059a5:	ff d0                	call   *%eax
  1059a7:	eb 0f                	jmp    1059b8 <vprintfmt+0x21c>
                }
                else {
                    putch(ch, putdat);
  1059a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  1059b0:	89 1c 24             	mov    %ebx,(%esp)
  1059b3:	8b 45 08             	mov    0x8(%ebp),%eax
  1059b6:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  1059b8:	ff 4d e8             	decl   -0x18(%ebp)
  1059bb:	89 f0                	mov    %esi,%eax
  1059bd:	8d 70 01             	lea    0x1(%eax),%esi
  1059c0:	0f b6 00             	movzbl (%eax),%eax
  1059c3:	0f be d8             	movsbl %al,%ebx
  1059c6:	85 db                	test   %ebx,%ebx
  1059c8:	74 27                	je     1059f1 <vprintfmt+0x255>
  1059ca:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1059ce:	78 b4                	js     105984 <vprintfmt+0x1e8>
  1059d0:	ff 4d e4             	decl   -0x1c(%ebp)
  1059d3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1059d7:	79 ab                	jns    105984 <vprintfmt+0x1e8>
                }
            }
            for (; width > 0; width --) {
  1059d9:	eb 16                	jmp    1059f1 <vprintfmt+0x255>
                putch(' ', putdat);
  1059db:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059de:	89 44 24 04          	mov    %eax,0x4(%esp)
  1059e2:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1059e9:	8b 45 08             	mov    0x8(%ebp),%eax
  1059ec:	ff d0                	call   *%eax
            for (; width > 0; width --) {
  1059ee:	ff 4d e8             	decl   -0x18(%ebp)
  1059f1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1059f5:	7f e4                	jg     1059db <vprintfmt+0x23f>
            }
            break;
  1059f7:	e9 6c 01 00 00       	jmp    105b68 <vprintfmt+0x3cc>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  1059fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1059ff:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a03:	8d 45 14             	lea    0x14(%ebp),%eax
  105a06:	89 04 24             	mov    %eax,(%esp)
  105a09:	e8 16 fd ff ff       	call   105724 <getint>
  105a0e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105a11:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  105a14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105a17:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105a1a:	85 d2                	test   %edx,%edx
  105a1c:	79 26                	jns    105a44 <vprintfmt+0x2a8>
                putch('-', putdat);
  105a1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a21:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a25:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  105a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  105a2f:	ff d0                	call   *%eax
                num = -(long long)num;
  105a31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105a34:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105a37:	f7 d8                	neg    %eax
  105a39:	83 d2 00             	adc    $0x0,%edx
  105a3c:	f7 da                	neg    %edx
  105a3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105a41:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  105a44:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  105a4b:	e9 a8 00 00 00       	jmp    105af8 <vprintfmt+0x35c>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  105a50:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105a53:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a57:	8d 45 14             	lea    0x14(%ebp),%eax
  105a5a:	89 04 24             	mov    %eax,(%esp)
  105a5d:	e8 73 fc ff ff       	call   1056d5 <getuint>
  105a62:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105a65:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  105a68:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  105a6f:	e9 84 00 00 00       	jmp    105af8 <vprintfmt+0x35c>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  105a74:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105a77:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a7b:	8d 45 14             	lea    0x14(%ebp),%eax
  105a7e:	89 04 24             	mov    %eax,(%esp)
  105a81:	e8 4f fc ff ff       	call   1056d5 <getuint>
  105a86:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105a89:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  105a8c:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  105a93:	eb 63                	jmp    105af8 <vprintfmt+0x35c>

        // pointer
        case 'p':
            putch('0', putdat);
  105a95:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a98:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a9c:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  105aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  105aa6:	ff d0                	call   *%eax
            putch('x', putdat);
  105aa8:	8b 45 0c             	mov    0xc(%ebp),%eax
  105aab:	89 44 24 04          	mov    %eax,0x4(%esp)
  105aaf:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  105ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  105ab9:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  105abb:	8b 45 14             	mov    0x14(%ebp),%eax
  105abe:	8d 50 04             	lea    0x4(%eax),%edx
  105ac1:	89 55 14             	mov    %edx,0x14(%ebp)
  105ac4:	8b 00                	mov    (%eax),%eax
  105ac6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105ac9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  105ad0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  105ad7:	eb 1f                	jmp    105af8 <vprintfmt+0x35c>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  105ad9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105adc:	89 44 24 04          	mov    %eax,0x4(%esp)
  105ae0:	8d 45 14             	lea    0x14(%ebp),%eax
  105ae3:	89 04 24             	mov    %eax,(%esp)
  105ae6:	e8 ea fb ff ff       	call   1056d5 <getuint>
  105aeb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105aee:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  105af1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  105af8:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  105afc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105aff:	89 54 24 18          	mov    %edx,0x18(%esp)
  105b03:	8b 55 e8             	mov    -0x18(%ebp),%edx
  105b06:	89 54 24 14          	mov    %edx,0x14(%esp)
  105b0a:	89 44 24 10          	mov    %eax,0x10(%esp)
  105b0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105b11:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105b14:	89 44 24 08          	mov    %eax,0x8(%esp)
  105b18:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105b1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b1f:	89 44 24 04          	mov    %eax,0x4(%esp)
  105b23:	8b 45 08             	mov    0x8(%ebp),%eax
  105b26:	89 04 24             	mov    %eax,(%esp)
  105b29:	e8 a5 fa ff ff       	call   1055d3 <printnum>
            break;
  105b2e:	eb 38                	jmp    105b68 <vprintfmt+0x3cc>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  105b30:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b33:	89 44 24 04          	mov    %eax,0x4(%esp)
  105b37:	89 1c 24             	mov    %ebx,(%esp)
  105b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  105b3d:	ff d0                	call   *%eax
            break;
  105b3f:	eb 27                	jmp    105b68 <vprintfmt+0x3cc>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  105b41:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b44:	89 44 24 04          	mov    %eax,0x4(%esp)
  105b48:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  105b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  105b52:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  105b54:	ff 4d 10             	decl   0x10(%ebp)
  105b57:	eb 03                	jmp    105b5c <vprintfmt+0x3c0>
  105b59:	ff 4d 10             	decl   0x10(%ebp)
  105b5c:	8b 45 10             	mov    0x10(%ebp),%eax
  105b5f:	48                   	dec    %eax
  105b60:	0f b6 00             	movzbl (%eax),%eax
  105b63:	3c 25                	cmp    $0x25,%al
  105b65:	75 f2                	jne    105b59 <vprintfmt+0x3bd>
                /* do nothing */;
            break;
  105b67:	90                   	nop
    while (1) {
  105b68:	e9 37 fc ff ff       	jmp    1057a4 <vprintfmt+0x8>
                return;
  105b6d:	90                   	nop
        }
    }
}
  105b6e:	83 c4 40             	add    $0x40,%esp
  105b71:	5b                   	pop    %ebx
  105b72:	5e                   	pop    %esi
  105b73:	5d                   	pop    %ebp
  105b74:	c3                   	ret    

00105b75 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  105b75:	55                   	push   %ebp
  105b76:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  105b78:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b7b:	8b 40 08             	mov    0x8(%eax),%eax
  105b7e:	8d 50 01             	lea    0x1(%eax),%edx
  105b81:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b84:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  105b87:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b8a:	8b 10                	mov    (%eax),%edx
  105b8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b8f:	8b 40 04             	mov    0x4(%eax),%eax
  105b92:	39 c2                	cmp    %eax,%edx
  105b94:	73 12                	jae    105ba8 <sprintputch+0x33>
        *b->buf ++ = ch;
  105b96:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b99:	8b 00                	mov    (%eax),%eax
  105b9b:	8d 48 01             	lea    0x1(%eax),%ecx
  105b9e:	8b 55 0c             	mov    0xc(%ebp),%edx
  105ba1:	89 0a                	mov    %ecx,(%edx)
  105ba3:	8b 55 08             	mov    0x8(%ebp),%edx
  105ba6:	88 10                	mov    %dl,(%eax)
    }
}
  105ba8:	90                   	nop
  105ba9:	5d                   	pop    %ebp
  105baa:	c3                   	ret    

00105bab <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  105bab:	55                   	push   %ebp
  105bac:	89 e5                	mov    %esp,%ebp
  105bae:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  105bb1:	8d 45 14             	lea    0x14(%ebp),%eax
  105bb4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  105bb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105bba:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105bbe:	8b 45 10             	mov    0x10(%ebp),%eax
  105bc1:	89 44 24 08          	mov    %eax,0x8(%esp)
  105bc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  105bc8:	89 44 24 04          	mov    %eax,0x4(%esp)
  105bcc:	8b 45 08             	mov    0x8(%ebp),%eax
  105bcf:	89 04 24             	mov    %eax,(%esp)
  105bd2:	e8 0a 00 00 00       	call   105be1 <vsnprintf>
  105bd7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  105bda:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105bdd:	89 ec                	mov    %ebp,%esp
  105bdf:	5d                   	pop    %ebp
  105be0:	c3                   	ret    

00105be1 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  105be1:	55                   	push   %ebp
  105be2:	89 e5                	mov    %esp,%ebp
  105be4:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  105be7:	8b 45 08             	mov    0x8(%ebp),%eax
  105bea:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105bed:	8b 45 0c             	mov    0xc(%ebp),%eax
  105bf0:	8d 50 ff             	lea    -0x1(%eax),%edx
  105bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  105bf6:	01 d0                	add    %edx,%eax
  105bf8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105bfb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  105c02:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  105c06:	74 0a                	je     105c12 <vsnprintf+0x31>
  105c08:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105c0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105c0e:	39 c2                	cmp    %eax,%edx
  105c10:	76 07                	jbe    105c19 <vsnprintf+0x38>
        return -E_INVAL;
  105c12:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  105c17:	eb 2a                	jmp    105c43 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  105c19:	8b 45 14             	mov    0x14(%ebp),%eax
  105c1c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105c20:	8b 45 10             	mov    0x10(%ebp),%eax
  105c23:	89 44 24 08          	mov    %eax,0x8(%esp)
  105c27:	8d 45 ec             	lea    -0x14(%ebp),%eax
  105c2a:	89 44 24 04          	mov    %eax,0x4(%esp)
  105c2e:	c7 04 24 75 5b 10 00 	movl   $0x105b75,(%esp)
  105c35:	e8 62 fb ff ff       	call   10579c <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  105c3a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105c3d:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  105c40:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105c43:	89 ec                	mov    %ebp,%esp
  105c45:	5d                   	pop    %ebp
  105c46:	c3                   	ret    

00105c47 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  105c47:	55                   	push   %ebp
  105c48:	89 e5                	mov    %esp,%ebp
  105c4a:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105c4d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  105c54:	eb 03                	jmp    105c59 <strlen+0x12>
        cnt ++;
  105c56:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
  105c59:	8b 45 08             	mov    0x8(%ebp),%eax
  105c5c:	8d 50 01             	lea    0x1(%eax),%edx
  105c5f:	89 55 08             	mov    %edx,0x8(%ebp)
  105c62:	0f b6 00             	movzbl (%eax),%eax
  105c65:	84 c0                	test   %al,%al
  105c67:	75 ed                	jne    105c56 <strlen+0xf>
    }
    return cnt;
  105c69:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105c6c:	89 ec                	mov    %ebp,%esp
  105c6e:	5d                   	pop    %ebp
  105c6f:	c3                   	ret    

00105c70 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  105c70:	55                   	push   %ebp
  105c71:	89 e5                	mov    %esp,%ebp
  105c73:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105c76:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  105c7d:	eb 03                	jmp    105c82 <strnlen+0x12>
        cnt ++;
  105c7f:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  105c82:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105c85:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105c88:	73 10                	jae    105c9a <strnlen+0x2a>
  105c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  105c8d:	8d 50 01             	lea    0x1(%eax),%edx
  105c90:	89 55 08             	mov    %edx,0x8(%ebp)
  105c93:	0f b6 00             	movzbl (%eax),%eax
  105c96:	84 c0                	test   %al,%al
  105c98:	75 e5                	jne    105c7f <strnlen+0xf>
    }
    return cnt;
  105c9a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105c9d:	89 ec                	mov    %ebp,%esp
  105c9f:	5d                   	pop    %ebp
  105ca0:	c3                   	ret    

00105ca1 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  105ca1:	55                   	push   %ebp
  105ca2:	89 e5                	mov    %esp,%ebp
  105ca4:	57                   	push   %edi
  105ca5:	56                   	push   %esi
  105ca6:	83 ec 20             	sub    $0x20,%esp
  105ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  105cac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105caf:	8b 45 0c             	mov    0xc(%ebp),%eax
  105cb2:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  105cb5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105cb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105cbb:	89 d1                	mov    %edx,%ecx
  105cbd:	89 c2                	mov    %eax,%edx
  105cbf:	89 ce                	mov    %ecx,%esi
  105cc1:	89 d7                	mov    %edx,%edi
  105cc3:	ac                   	lods   %ds:(%esi),%al
  105cc4:	aa                   	stos   %al,%es:(%edi)
  105cc5:	84 c0                	test   %al,%al
  105cc7:	75 fa                	jne    105cc3 <strcpy+0x22>
  105cc9:	89 fa                	mov    %edi,%edx
  105ccb:	89 f1                	mov    %esi,%ecx
  105ccd:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105cd0:	89 55 e8             	mov    %edx,-0x18(%ebp)
  105cd3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  105cd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  105cd9:	83 c4 20             	add    $0x20,%esp
  105cdc:	5e                   	pop    %esi
  105cdd:	5f                   	pop    %edi
  105cde:	5d                   	pop    %ebp
  105cdf:	c3                   	ret    

00105ce0 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  105ce0:	55                   	push   %ebp
  105ce1:	89 e5                	mov    %esp,%ebp
  105ce3:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  105ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  105ce9:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  105cec:	eb 1e                	jmp    105d0c <strncpy+0x2c>
        if ((*p = *src) != '\0') {
  105cee:	8b 45 0c             	mov    0xc(%ebp),%eax
  105cf1:	0f b6 10             	movzbl (%eax),%edx
  105cf4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105cf7:	88 10                	mov    %dl,(%eax)
  105cf9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105cfc:	0f b6 00             	movzbl (%eax),%eax
  105cff:	84 c0                	test   %al,%al
  105d01:	74 03                	je     105d06 <strncpy+0x26>
            src ++;
  105d03:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
  105d06:	ff 45 fc             	incl   -0x4(%ebp)
  105d09:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
  105d0c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105d10:	75 dc                	jne    105cee <strncpy+0xe>
    }
    return dst;
  105d12:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105d15:	89 ec                	mov    %ebp,%esp
  105d17:	5d                   	pop    %ebp
  105d18:	c3                   	ret    

00105d19 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  105d19:	55                   	push   %ebp
  105d1a:	89 e5                	mov    %esp,%ebp
  105d1c:	57                   	push   %edi
  105d1d:	56                   	push   %esi
  105d1e:	83 ec 20             	sub    $0x20,%esp
  105d21:	8b 45 08             	mov    0x8(%ebp),%eax
  105d24:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105d27:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  105d2d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105d30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105d33:	89 d1                	mov    %edx,%ecx
  105d35:	89 c2                	mov    %eax,%edx
  105d37:	89 ce                	mov    %ecx,%esi
  105d39:	89 d7                	mov    %edx,%edi
  105d3b:	ac                   	lods   %ds:(%esi),%al
  105d3c:	ae                   	scas   %es:(%edi),%al
  105d3d:	75 08                	jne    105d47 <strcmp+0x2e>
  105d3f:	84 c0                	test   %al,%al
  105d41:	75 f8                	jne    105d3b <strcmp+0x22>
  105d43:	31 c0                	xor    %eax,%eax
  105d45:	eb 04                	jmp    105d4b <strcmp+0x32>
  105d47:	19 c0                	sbb    %eax,%eax
  105d49:	0c 01                	or     $0x1,%al
  105d4b:	89 fa                	mov    %edi,%edx
  105d4d:	89 f1                	mov    %esi,%ecx
  105d4f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105d52:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105d55:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  105d58:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  105d5b:	83 c4 20             	add    $0x20,%esp
  105d5e:	5e                   	pop    %esi
  105d5f:	5f                   	pop    %edi
  105d60:	5d                   	pop    %ebp
  105d61:	c3                   	ret    

00105d62 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  105d62:	55                   	push   %ebp
  105d63:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105d65:	eb 09                	jmp    105d70 <strncmp+0xe>
        n --, s1 ++, s2 ++;
  105d67:	ff 4d 10             	decl   0x10(%ebp)
  105d6a:	ff 45 08             	incl   0x8(%ebp)
  105d6d:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105d70:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105d74:	74 1a                	je     105d90 <strncmp+0x2e>
  105d76:	8b 45 08             	mov    0x8(%ebp),%eax
  105d79:	0f b6 00             	movzbl (%eax),%eax
  105d7c:	84 c0                	test   %al,%al
  105d7e:	74 10                	je     105d90 <strncmp+0x2e>
  105d80:	8b 45 08             	mov    0x8(%ebp),%eax
  105d83:	0f b6 10             	movzbl (%eax),%edx
  105d86:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d89:	0f b6 00             	movzbl (%eax),%eax
  105d8c:	38 c2                	cmp    %al,%dl
  105d8e:	74 d7                	je     105d67 <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  105d90:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105d94:	74 18                	je     105dae <strncmp+0x4c>
  105d96:	8b 45 08             	mov    0x8(%ebp),%eax
  105d99:	0f b6 00             	movzbl (%eax),%eax
  105d9c:	0f b6 d0             	movzbl %al,%edx
  105d9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  105da2:	0f b6 00             	movzbl (%eax),%eax
  105da5:	0f b6 c8             	movzbl %al,%ecx
  105da8:	89 d0                	mov    %edx,%eax
  105daa:	29 c8                	sub    %ecx,%eax
  105dac:	eb 05                	jmp    105db3 <strncmp+0x51>
  105dae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105db3:	5d                   	pop    %ebp
  105db4:	c3                   	ret    

00105db5 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  105db5:	55                   	push   %ebp
  105db6:	89 e5                	mov    %esp,%ebp
  105db8:	83 ec 04             	sub    $0x4,%esp
  105dbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  105dbe:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105dc1:	eb 13                	jmp    105dd6 <strchr+0x21>
        if (*s == c) {
  105dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  105dc6:	0f b6 00             	movzbl (%eax),%eax
  105dc9:	38 45 fc             	cmp    %al,-0x4(%ebp)
  105dcc:	75 05                	jne    105dd3 <strchr+0x1e>
            return (char *)s;
  105dce:	8b 45 08             	mov    0x8(%ebp),%eax
  105dd1:	eb 12                	jmp    105de5 <strchr+0x30>
        }
        s ++;
  105dd3:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  105dd6:	8b 45 08             	mov    0x8(%ebp),%eax
  105dd9:	0f b6 00             	movzbl (%eax),%eax
  105ddc:	84 c0                	test   %al,%al
  105dde:	75 e3                	jne    105dc3 <strchr+0xe>
    }
    return NULL;
  105de0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105de5:	89 ec                	mov    %ebp,%esp
  105de7:	5d                   	pop    %ebp
  105de8:	c3                   	ret    

00105de9 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  105de9:	55                   	push   %ebp
  105dea:	89 e5                	mov    %esp,%ebp
  105dec:	83 ec 04             	sub    $0x4,%esp
  105def:	8b 45 0c             	mov    0xc(%ebp),%eax
  105df2:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105df5:	eb 0e                	jmp    105e05 <strfind+0x1c>
        if (*s == c) {
  105df7:	8b 45 08             	mov    0x8(%ebp),%eax
  105dfa:	0f b6 00             	movzbl (%eax),%eax
  105dfd:	38 45 fc             	cmp    %al,-0x4(%ebp)
  105e00:	74 0f                	je     105e11 <strfind+0x28>
            break;
        }
        s ++;
  105e02:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  105e05:	8b 45 08             	mov    0x8(%ebp),%eax
  105e08:	0f b6 00             	movzbl (%eax),%eax
  105e0b:	84 c0                	test   %al,%al
  105e0d:	75 e8                	jne    105df7 <strfind+0xe>
  105e0f:	eb 01                	jmp    105e12 <strfind+0x29>
            break;
  105e11:	90                   	nop
    }
    return (char *)s;
  105e12:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105e15:	89 ec                	mov    %ebp,%esp
  105e17:	5d                   	pop    %ebp
  105e18:	c3                   	ret    

00105e19 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  105e19:	55                   	push   %ebp
  105e1a:	89 e5                	mov    %esp,%ebp
  105e1c:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  105e1f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  105e26:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105e2d:	eb 03                	jmp    105e32 <strtol+0x19>
        s ++;
  105e2f:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  105e32:	8b 45 08             	mov    0x8(%ebp),%eax
  105e35:	0f b6 00             	movzbl (%eax),%eax
  105e38:	3c 20                	cmp    $0x20,%al
  105e3a:	74 f3                	je     105e2f <strtol+0x16>
  105e3c:	8b 45 08             	mov    0x8(%ebp),%eax
  105e3f:	0f b6 00             	movzbl (%eax),%eax
  105e42:	3c 09                	cmp    $0x9,%al
  105e44:	74 e9                	je     105e2f <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
  105e46:	8b 45 08             	mov    0x8(%ebp),%eax
  105e49:	0f b6 00             	movzbl (%eax),%eax
  105e4c:	3c 2b                	cmp    $0x2b,%al
  105e4e:	75 05                	jne    105e55 <strtol+0x3c>
        s ++;
  105e50:	ff 45 08             	incl   0x8(%ebp)
  105e53:	eb 14                	jmp    105e69 <strtol+0x50>
    }
    else if (*s == '-') {
  105e55:	8b 45 08             	mov    0x8(%ebp),%eax
  105e58:	0f b6 00             	movzbl (%eax),%eax
  105e5b:	3c 2d                	cmp    $0x2d,%al
  105e5d:	75 0a                	jne    105e69 <strtol+0x50>
        s ++, neg = 1;
  105e5f:	ff 45 08             	incl   0x8(%ebp)
  105e62:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  105e69:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105e6d:	74 06                	je     105e75 <strtol+0x5c>
  105e6f:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  105e73:	75 22                	jne    105e97 <strtol+0x7e>
  105e75:	8b 45 08             	mov    0x8(%ebp),%eax
  105e78:	0f b6 00             	movzbl (%eax),%eax
  105e7b:	3c 30                	cmp    $0x30,%al
  105e7d:	75 18                	jne    105e97 <strtol+0x7e>
  105e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  105e82:	40                   	inc    %eax
  105e83:	0f b6 00             	movzbl (%eax),%eax
  105e86:	3c 78                	cmp    $0x78,%al
  105e88:	75 0d                	jne    105e97 <strtol+0x7e>
        s += 2, base = 16;
  105e8a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  105e8e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  105e95:	eb 29                	jmp    105ec0 <strtol+0xa7>
    }
    else if (base == 0 && s[0] == '0') {
  105e97:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105e9b:	75 16                	jne    105eb3 <strtol+0x9a>
  105e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  105ea0:	0f b6 00             	movzbl (%eax),%eax
  105ea3:	3c 30                	cmp    $0x30,%al
  105ea5:	75 0c                	jne    105eb3 <strtol+0x9a>
        s ++, base = 8;
  105ea7:	ff 45 08             	incl   0x8(%ebp)
  105eaa:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  105eb1:	eb 0d                	jmp    105ec0 <strtol+0xa7>
    }
    else if (base == 0) {
  105eb3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105eb7:	75 07                	jne    105ec0 <strtol+0xa7>
        base = 10;
  105eb9:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  105ec0:	8b 45 08             	mov    0x8(%ebp),%eax
  105ec3:	0f b6 00             	movzbl (%eax),%eax
  105ec6:	3c 2f                	cmp    $0x2f,%al
  105ec8:	7e 1b                	jle    105ee5 <strtol+0xcc>
  105eca:	8b 45 08             	mov    0x8(%ebp),%eax
  105ecd:	0f b6 00             	movzbl (%eax),%eax
  105ed0:	3c 39                	cmp    $0x39,%al
  105ed2:	7f 11                	jg     105ee5 <strtol+0xcc>
            dig = *s - '0';
  105ed4:	8b 45 08             	mov    0x8(%ebp),%eax
  105ed7:	0f b6 00             	movzbl (%eax),%eax
  105eda:	0f be c0             	movsbl %al,%eax
  105edd:	83 e8 30             	sub    $0x30,%eax
  105ee0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105ee3:	eb 48                	jmp    105f2d <strtol+0x114>
        }
        else if (*s >= 'a' && *s <= 'z') {
  105ee5:	8b 45 08             	mov    0x8(%ebp),%eax
  105ee8:	0f b6 00             	movzbl (%eax),%eax
  105eeb:	3c 60                	cmp    $0x60,%al
  105eed:	7e 1b                	jle    105f0a <strtol+0xf1>
  105eef:	8b 45 08             	mov    0x8(%ebp),%eax
  105ef2:	0f b6 00             	movzbl (%eax),%eax
  105ef5:	3c 7a                	cmp    $0x7a,%al
  105ef7:	7f 11                	jg     105f0a <strtol+0xf1>
            dig = *s - 'a' + 10;
  105ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  105efc:	0f b6 00             	movzbl (%eax),%eax
  105eff:	0f be c0             	movsbl %al,%eax
  105f02:	83 e8 57             	sub    $0x57,%eax
  105f05:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105f08:	eb 23                	jmp    105f2d <strtol+0x114>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  105f0a:	8b 45 08             	mov    0x8(%ebp),%eax
  105f0d:	0f b6 00             	movzbl (%eax),%eax
  105f10:	3c 40                	cmp    $0x40,%al
  105f12:	7e 3b                	jle    105f4f <strtol+0x136>
  105f14:	8b 45 08             	mov    0x8(%ebp),%eax
  105f17:	0f b6 00             	movzbl (%eax),%eax
  105f1a:	3c 5a                	cmp    $0x5a,%al
  105f1c:	7f 31                	jg     105f4f <strtol+0x136>
            dig = *s - 'A' + 10;
  105f1e:	8b 45 08             	mov    0x8(%ebp),%eax
  105f21:	0f b6 00             	movzbl (%eax),%eax
  105f24:	0f be c0             	movsbl %al,%eax
  105f27:	83 e8 37             	sub    $0x37,%eax
  105f2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  105f2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105f30:	3b 45 10             	cmp    0x10(%ebp),%eax
  105f33:	7d 19                	jge    105f4e <strtol+0x135>
            break;
        }
        s ++, val = (val * base) + dig;
  105f35:	ff 45 08             	incl   0x8(%ebp)
  105f38:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105f3b:	0f af 45 10          	imul   0x10(%ebp),%eax
  105f3f:	89 c2                	mov    %eax,%edx
  105f41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105f44:	01 d0                	add    %edx,%eax
  105f46:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
  105f49:	e9 72 ff ff ff       	jmp    105ec0 <strtol+0xa7>
            break;
  105f4e:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
  105f4f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105f53:	74 08                	je     105f5d <strtol+0x144>
        *endptr = (char *) s;
  105f55:	8b 45 0c             	mov    0xc(%ebp),%eax
  105f58:	8b 55 08             	mov    0x8(%ebp),%edx
  105f5b:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  105f5d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  105f61:	74 07                	je     105f6a <strtol+0x151>
  105f63:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105f66:	f7 d8                	neg    %eax
  105f68:	eb 03                	jmp    105f6d <strtol+0x154>
  105f6a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  105f6d:	89 ec                	mov    %ebp,%esp
  105f6f:	5d                   	pop    %ebp
  105f70:	c3                   	ret    

00105f71 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  105f71:	55                   	push   %ebp
  105f72:	89 e5                	mov    %esp,%ebp
  105f74:	83 ec 28             	sub    $0x28,%esp
  105f77:	89 7d fc             	mov    %edi,-0x4(%ebp)
  105f7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  105f7d:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  105f80:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  105f84:	8b 45 08             	mov    0x8(%ebp),%eax
  105f87:	89 45 f8             	mov    %eax,-0x8(%ebp)
  105f8a:	88 55 f7             	mov    %dl,-0x9(%ebp)
  105f8d:	8b 45 10             	mov    0x10(%ebp),%eax
  105f90:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  105f93:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  105f96:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  105f9a:	8b 55 f8             	mov    -0x8(%ebp),%edx
  105f9d:	89 d7                	mov    %edx,%edi
  105f9f:	f3 aa                	rep stos %al,%es:(%edi)
  105fa1:	89 fa                	mov    %edi,%edx
  105fa3:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105fa6:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  105fa9:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  105fac:	8b 7d fc             	mov    -0x4(%ebp),%edi
  105faf:	89 ec                	mov    %ebp,%esp
  105fb1:	5d                   	pop    %ebp
  105fb2:	c3                   	ret    

00105fb3 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  105fb3:	55                   	push   %ebp
  105fb4:	89 e5                	mov    %esp,%ebp
  105fb6:	57                   	push   %edi
  105fb7:	56                   	push   %esi
  105fb8:	53                   	push   %ebx
  105fb9:	83 ec 30             	sub    $0x30,%esp
  105fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  105fbf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105fc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  105fc5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105fc8:	8b 45 10             	mov    0x10(%ebp),%eax
  105fcb:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  105fce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105fd1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  105fd4:	73 42                	jae    106018 <memmove+0x65>
  105fd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105fd9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105fdc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105fdf:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105fe2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105fe5:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105fe8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105feb:	c1 e8 02             	shr    $0x2,%eax
  105fee:	89 c1                	mov    %eax,%ecx
    asm volatile (
  105ff0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105ff3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105ff6:	89 d7                	mov    %edx,%edi
  105ff8:	89 c6                	mov    %eax,%esi
  105ffa:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105ffc:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  105fff:	83 e1 03             	and    $0x3,%ecx
  106002:	74 02                	je     106006 <memmove+0x53>
  106004:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  106006:	89 f0                	mov    %esi,%eax
  106008:	89 fa                	mov    %edi,%edx
  10600a:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  10600d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  106010:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
  106013:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        return __memcpy(dst, src, n);
  106016:	eb 36                	jmp    10604e <memmove+0x9b>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  106018:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10601b:	8d 50 ff             	lea    -0x1(%eax),%edx
  10601e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  106021:	01 c2                	add    %eax,%edx
  106023:	8b 45 e8             	mov    -0x18(%ebp),%eax
  106026:	8d 48 ff             	lea    -0x1(%eax),%ecx
  106029:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10602c:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  10602f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  106032:	89 c1                	mov    %eax,%ecx
  106034:	89 d8                	mov    %ebx,%eax
  106036:	89 d6                	mov    %edx,%esi
  106038:	89 c7                	mov    %eax,%edi
  10603a:	fd                   	std    
  10603b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  10603d:	fc                   	cld    
  10603e:	89 f8                	mov    %edi,%eax
  106040:	89 f2                	mov    %esi,%edx
  106042:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  106045:	89 55 c8             	mov    %edx,-0x38(%ebp)
  106048:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  10604b:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  10604e:	83 c4 30             	add    $0x30,%esp
  106051:	5b                   	pop    %ebx
  106052:	5e                   	pop    %esi
  106053:	5f                   	pop    %edi
  106054:	5d                   	pop    %ebp
  106055:	c3                   	ret    

00106056 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  106056:	55                   	push   %ebp
  106057:	89 e5                	mov    %esp,%ebp
  106059:	57                   	push   %edi
  10605a:	56                   	push   %esi
  10605b:	83 ec 20             	sub    $0x20,%esp
  10605e:	8b 45 08             	mov    0x8(%ebp),%eax
  106061:	89 45 f4             	mov    %eax,-0xc(%ebp)
  106064:	8b 45 0c             	mov    0xc(%ebp),%eax
  106067:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10606a:	8b 45 10             	mov    0x10(%ebp),%eax
  10606d:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  106070:	8b 45 ec             	mov    -0x14(%ebp),%eax
  106073:	c1 e8 02             	shr    $0x2,%eax
  106076:	89 c1                	mov    %eax,%ecx
    asm volatile (
  106078:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10607b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10607e:	89 d7                	mov    %edx,%edi
  106080:	89 c6                	mov    %eax,%esi
  106082:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  106084:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  106087:	83 e1 03             	and    $0x3,%ecx
  10608a:	74 02                	je     10608e <memcpy+0x38>
  10608c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  10608e:	89 f0                	mov    %esi,%eax
  106090:	89 fa                	mov    %edi,%edx
  106092:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  106095:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  106098:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  10609b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  10609e:	83 c4 20             	add    $0x20,%esp
  1060a1:	5e                   	pop    %esi
  1060a2:	5f                   	pop    %edi
  1060a3:	5d                   	pop    %ebp
  1060a4:	c3                   	ret    

001060a5 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  1060a5:	55                   	push   %ebp
  1060a6:	89 e5                	mov    %esp,%ebp
  1060a8:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  1060ab:	8b 45 08             	mov    0x8(%ebp),%eax
  1060ae:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  1060b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1060b4:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  1060b7:	eb 2e                	jmp    1060e7 <memcmp+0x42>
        if (*s1 != *s2) {
  1060b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1060bc:	0f b6 10             	movzbl (%eax),%edx
  1060bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1060c2:	0f b6 00             	movzbl (%eax),%eax
  1060c5:	38 c2                	cmp    %al,%dl
  1060c7:	74 18                	je     1060e1 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  1060c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1060cc:	0f b6 00             	movzbl (%eax),%eax
  1060cf:	0f b6 d0             	movzbl %al,%edx
  1060d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1060d5:	0f b6 00             	movzbl (%eax),%eax
  1060d8:	0f b6 c8             	movzbl %al,%ecx
  1060db:	89 d0                	mov    %edx,%eax
  1060dd:	29 c8                	sub    %ecx,%eax
  1060df:	eb 18                	jmp    1060f9 <memcmp+0x54>
        }
        s1 ++, s2 ++;
  1060e1:	ff 45 fc             	incl   -0x4(%ebp)
  1060e4:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
  1060e7:	8b 45 10             	mov    0x10(%ebp),%eax
  1060ea:	8d 50 ff             	lea    -0x1(%eax),%edx
  1060ed:	89 55 10             	mov    %edx,0x10(%ebp)
  1060f0:	85 c0                	test   %eax,%eax
  1060f2:	75 c5                	jne    1060b9 <memcmp+0x14>
    }
    return 0;
  1060f4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1060f9:	89 ec                	mov    %ebp,%esp
  1060fb:	5d                   	pop    %ebp
  1060fc:	c3                   	ret    
