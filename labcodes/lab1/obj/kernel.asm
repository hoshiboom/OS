
bin/kernel:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  100000:	55                   	push   %ebp
  100001:	89 e5                	mov    %esp,%ebp
  100003:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100006:	b8 68 0d 11 00       	mov    $0x110d68,%eax
  10000b:	2d 16 fa 10 00       	sub    $0x10fa16,%eax
  100010:	89 44 24 08          	mov    %eax,0x8(%esp)
  100014:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10001b:	00 
  10001c:	c7 04 24 16 fa 10 00 	movl   $0x10fa16,(%esp)
  100023:	e8 cd 34 00 00       	call   1034f5 <memset>

    cons_init();                // init the console
  100028:	e8 d4 15 00 00       	call   101601 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  10002d:	c7 45 f4 a0 36 10 00 	movl   $0x1036a0,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100034:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100037:	89 44 24 04          	mov    %eax,0x4(%esp)
  10003b:	c7 04 24 bc 36 10 00 	movl   $0x1036bc,(%esp)
  100042:	e8 e9 02 00 00       	call   100330 <cprintf>

    print_kerninfo();
  100047:	e8 07 08 00 00       	call   100853 <print_kerninfo>

    grade_backtrace();
  10004c:	e8 95 00 00 00       	call   1000e6 <grade_backtrace>

    pmm_init();                 // init physical memory management
  100051:	e8 f6 2a 00 00       	call   102b4c <pmm_init>

    pic_init();                 // init interrupt controller
  100056:	e8 01 17 00 00       	call   10175c <pic_init>
    idt_init();                 // init interrupt descriptor table
  10005b:	e8 88 18 00 00       	call   1018e8 <idt_init>

    clock_init();               // init clock interrupt
  100060:	e8 3d 0d 00 00       	call   100da2 <clock_init>
    intr_enable();              // enable irq interrupt
  100065:	e8 50 16 00 00       	call   1016ba <intr_enable>

    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    lab1_switch_test();
  10006a:	e8 76 01 00 00       	call   1001e5 <lab1_switch_test>

    /* do nothing */
    while (1);
  10006f:	eb fe                	jmp    10006f <kern_init+0x6f>

00100071 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  100071:	55                   	push   %ebp
  100072:	89 e5                	mov    %esp,%ebp
  100074:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  100077:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10007e:	00 
  10007f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100086:	00 
  100087:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10008e:	e8 2a 0c 00 00       	call   100cbd <mon_backtrace>
}
  100093:	90                   	nop
  100094:	89 ec                	mov    %ebp,%esp
  100096:	5d                   	pop    %ebp
  100097:	c3                   	ret    

00100098 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  100098:	55                   	push   %ebp
  100099:	89 e5                	mov    %esp,%ebp
  10009b:	83 ec 18             	sub    $0x18,%esp
  10009e:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000a1:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  1000a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  1000a7:	8d 5d 08             	lea    0x8(%ebp),%ebx
  1000aa:	8b 45 08             	mov    0x8(%ebp),%eax
  1000ad:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  1000b1:	89 54 24 08          	mov    %edx,0x8(%esp)
  1000b5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1000b9:	89 04 24             	mov    %eax,(%esp)
  1000bc:	e8 b0 ff ff ff       	call   100071 <grade_backtrace2>
}
  1000c1:	90                   	nop
  1000c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1000c5:	89 ec                	mov    %ebp,%esp
  1000c7:	5d                   	pop    %ebp
  1000c8:	c3                   	ret    

001000c9 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000c9:	55                   	push   %ebp
  1000ca:	89 e5                	mov    %esp,%ebp
  1000cc:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000cf:	8b 45 10             	mov    0x10(%ebp),%eax
  1000d2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000d6:	8b 45 08             	mov    0x8(%ebp),%eax
  1000d9:	89 04 24             	mov    %eax,(%esp)
  1000dc:	e8 b7 ff ff ff       	call   100098 <grade_backtrace1>
}
  1000e1:	90                   	nop
  1000e2:	89 ec                	mov    %ebp,%esp
  1000e4:	5d                   	pop    %ebp
  1000e5:	c3                   	ret    

001000e6 <grade_backtrace>:

void
grade_backtrace(void) {
  1000e6:	55                   	push   %ebp
  1000e7:	89 e5                	mov    %esp,%ebp
  1000e9:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  1000ec:	b8 00 00 10 00       	mov    $0x100000,%eax
  1000f1:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  1000f8:	ff 
  1000f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000fd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100104:	e8 c0 ff ff ff       	call   1000c9 <grade_backtrace0>
}
  100109:	90                   	nop
  10010a:	89 ec                	mov    %ebp,%esp
  10010c:	5d                   	pop    %ebp
  10010d:	c3                   	ret    

0010010e <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  10010e:	55                   	push   %ebp
  10010f:	89 e5                	mov    %esp,%ebp
  100111:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100114:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100117:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  10011a:	8c 45 f2             	mov    %es,-0xe(%ebp)
  10011d:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  100120:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100124:	83 e0 03             	and    $0x3,%eax
  100127:	89 c2                	mov    %eax,%edx
  100129:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  10012e:	89 54 24 08          	mov    %edx,0x8(%esp)
  100132:	89 44 24 04          	mov    %eax,0x4(%esp)
  100136:	c7 04 24 c1 36 10 00 	movl   $0x1036c1,(%esp)
  10013d:	e8 ee 01 00 00       	call   100330 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100142:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100146:	89 c2                	mov    %eax,%edx
  100148:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  10014d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100151:	89 44 24 04          	mov    %eax,0x4(%esp)
  100155:	c7 04 24 cf 36 10 00 	movl   $0x1036cf,(%esp)
  10015c:	e8 cf 01 00 00       	call   100330 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100161:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100165:	89 c2                	mov    %eax,%edx
  100167:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  10016c:	89 54 24 08          	mov    %edx,0x8(%esp)
  100170:	89 44 24 04          	mov    %eax,0x4(%esp)
  100174:	c7 04 24 dd 36 10 00 	movl   $0x1036dd,(%esp)
  10017b:	e8 b0 01 00 00       	call   100330 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  100180:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100184:	89 c2                	mov    %eax,%edx
  100186:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  10018b:	89 54 24 08          	mov    %edx,0x8(%esp)
  10018f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100193:	c7 04 24 eb 36 10 00 	movl   $0x1036eb,(%esp)
  10019a:	e8 91 01 00 00       	call   100330 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  10019f:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001a3:	89 c2                	mov    %eax,%edx
  1001a5:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  1001aa:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001b2:	c7 04 24 f9 36 10 00 	movl   $0x1036f9,(%esp)
  1001b9:	e8 72 01 00 00       	call   100330 <cprintf>
    round ++;
  1001be:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  1001c3:	40                   	inc    %eax
  1001c4:	a3 20 fa 10 00       	mov    %eax,0x10fa20
}
  1001c9:	90                   	nop
  1001ca:	89 ec                	mov    %ebp,%esp
  1001cc:	5d                   	pop    %ebp
  1001cd:	c3                   	ret    

001001ce <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001ce:	55                   	push   %ebp
  1001cf:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
	asm volatile (
  1001d1:	83 ec 08             	sub    $0x8,%esp
  1001d4:	cd 78                	int    $0x78
  1001d6:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp"
	    : 
	    : "i"(T_SWITCH_TOU)
	);
}
  1001d8:	90                   	nop
  1001d9:	5d                   	pop    %ebp
  1001da:	c3                   	ret    

001001db <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001db:	55                   	push   %ebp
  1001dc:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
	asm volatile (
  1001de:	cd 79                	int    $0x79
  1001e0:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp \n"
	    : 
	    : "i"(T_SWITCH_TOK)
	);
}
  1001e2:	90                   	nop
  1001e3:	5d                   	pop    %ebp
  1001e4:	c3                   	ret    

001001e5 <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001e5:	55                   	push   %ebp
  1001e6:	89 e5                	mov    %esp,%ebp
  1001e8:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  1001eb:	e8 1e ff ff ff       	call   10010e <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  1001f0:	c7 04 24 08 37 10 00 	movl   $0x103708,(%esp)
  1001f7:	e8 34 01 00 00       	call   100330 <cprintf>
    lab1_switch_to_user();
  1001fc:	e8 cd ff ff ff       	call   1001ce <lab1_switch_to_user>
    lab1_print_cur_status();
  100201:	e8 08 ff ff ff       	call   10010e <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  100206:	c7 04 24 28 37 10 00 	movl   $0x103728,(%esp)
  10020d:	e8 1e 01 00 00       	call   100330 <cprintf>
    lab1_switch_to_kernel();
  100212:	e8 c4 ff ff ff       	call   1001db <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100217:	e8 f2 fe ff ff       	call   10010e <lab1_print_cur_status>
}
  10021c:	90                   	nop
  10021d:	89 ec                	mov    %ebp,%esp
  10021f:	5d                   	pop    %ebp
  100220:	c3                   	ret    

00100221 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100221:	55                   	push   %ebp
  100222:	89 e5                	mov    %esp,%ebp
  100224:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100227:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10022b:	74 13                	je     100240 <readline+0x1f>
        cprintf("%s", prompt);
  10022d:	8b 45 08             	mov    0x8(%ebp),%eax
  100230:	89 44 24 04          	mov    %eax,0x4(%esp)
  100234:	c7 04 24 47 37 10 00 	movl   $0x103747,(%esp)
  10023b:	e8 f0 00 00 00       	call   100330 <cprintf>
    }
    int i = 0, c;
  100240:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100247:	e8 73 01 00 00       	call   1003bf <getchar>
  10024c:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  10024f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100253:	79 07                	jns    10025c <readline+0x3b>
            return NULL;
  100255:	b8 00 00 00 00       	mov    $0x0,%eax
  10025a:	eb 78                	jmp    1002d4 <readline+0xb3>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  10025c:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100260:	7e 28                	jle    10028a <readline+0x69>
  100262:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100269:	7f 1f                	jg     10028a <readline+0x69>
            cputchar(c);
  10026b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10026e:	89 04 24             	mov    %eax,(%esp)
  100271:	e8 e2 00 00 00       	call   100358 <cputchar>
            buf[i ++] = c;
  100276:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100279:	8d 50 01             	lea    0x1(%eax),%edx
  10027c:	89 55 f4             	mov    %edx,-0xc(%ebp)
  10027f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100282:	88 90 40 fa 10 00    	mov    %dl,0x10fa40(%eax)
  100288:	eb 45                	jmp    1002cf <readline+0xae>
        }
        else if (c == '\b' && i > 0) {
  10028a:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  10028e:	75 16                	jne    1002a6 <readline+0x85>
  100290:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100294:	7e 10                	jle    1002a6 <readline+0x85>
            cputchar(c);
  100296:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100299:	89 04 24             	mov    %eax,(%esp)
  10029c:	e8 b7 00 00 00       	call   100358 <cputchar>
            i --;
  1002a1:	ff 4d f4             	decl   -0xc(%ebp)
  1002a4:	eb 29                	jmp    1002cf <readline+0xae>
        }
        else if (c == '\n' || c == '\r') {
  1002a6:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1002aa:	74 06                	je     1002b2 <readline+0x91>
  1002ac:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1002b0:	75 95                	jne    100247 <readline+0x26>
            cputchar(c);
  1002b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002b5:	89 04 24             	mov    %eax,(%esp)
  1002b8:	e8 9b 00 00 00       	call   100358 <cputchar>
            buf[i] = '\0';
  1002bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1002c0:	05 40 fa 10 00       	add    $0x10fa40,%eax
  1002c5:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1002c8:	b8 40 fa 10 00       	mov    $0x10fa40,%eax
  1002cd:	eb 05                	jmp    1002d4 <readline+0xb3>
        c = getchar();
  1002cf:	e9 73 ff ff ff       	jmp    100247 <readline+0x26>
        }
    }
}
  1002d4:	89 ec                	mov    %ebp,%esp
  1002d6:	5d                   	pop    %ebp
  1002d7:	c3                   	ret    

001002d8 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1002d8:	55                   	push   %ebp
  1002d9:	89 e5                	mov    %esp,%ebp
  1002db:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002de:	8b 45 08             	mov    0x8(%ebp),%eax
  1002e1:	89 04 24             	mov    %eax,(%esp)
  1002e4:	e8 47 13 00 00       	call   101630 <cons_putc>
    (*cnt) ++;
  1002e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002ec:	8b 00                	mov    (%eax),%eax
  1002ee:	8d 50 01             	lea    0x1(%eax),%edx
  1002f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002f4:	89 10                	mov    %edx,(%eax)
}
  1002f6:	90                   	nop
  1002f7:	89 ec                	mov    %ebp,%esp
  1002f9:	5d                   	pop    %ebp
  1002fa:	c3                   	ret    

001002fb <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  1002fb:	55                   	push   %ebp
  1002fc:	89 e5                	mov    %esp,%ebp
  1002fe:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100301:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  100308:	8b 45 0c             	mov    0xc(%ebp),%eax
  10030b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10030f:	8b 45 08             	mov    0x8(%ebp),%eax
  100312:	89 44 24 08          	mov    %eax,0x8(%esp)
  100316:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100319:	89 44 24 04          	mov    %eax,0x4(%esp)
  10031d:	c7 04 24 d8 02 10 00 	movl   $0x1002d8,(%esp)
  100324:	e8 f7 29 00 00       	call   102d20 <vprintfmt>
    return cnt;
  100329:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10032c:	89 ec                	mov    %ebp,%esp
  10032e:	5d                   	pop    %ebp
  10032f:	c3                   	ret    

00100330 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  100330:	55                   	push   %ebp
  100331:	89 e5                	mov    %esp,%ebp
  100333:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100336:	8d 45 0c             	lea    0xc(%ebp),%eax
  100339:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  10033c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10033f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100343:	8b 45 08             	mov    0x8(%ebp),%eax
  100346:	89 04 24             	mov    %eax,(%esp)
  100349:	e8 ad ff ff ff       	call   1002fb <vcprintf>
  10034e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  100351:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100354:	89 ec                	mov    %ebp,%esp
  100356:	5d                   	pop    %ebp
  100357:	c3                   	ret    

00100358 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100358:	55                   	push   %ebp
  100359:	89 e5                	mov    %esp,%ebp
  10035b:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  10035e:	8b 45 08             	mov    0x8(%ebp),%eax
  100361:	89 04 24             	mov    %eax,(%esp)
  100364:	e8 c7 12 00 00       	call   101630 <cons_putc>
}
  100369:	90                   	nop
  10036a:	89 ec                	mov    %ebp,%esp
  10036c:	5d                   	pop    %ebp
  10036d:	c3                   	ret    

0010036e <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  10036e:	55                   	push   %ebp
  10036f:	89 e5                	mov    %esp,%ebp
  100371:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100374:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  10037b:	eb 13                	jmp    100390 <cputs+0x22>
        cputch(c, &cnt);
  10037d:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  100381:	8d 55 f0             	lea    -0x10(%ebp),%edx
  100384:	89 54 24 04          	mov    %edx,0x4(%esp)
  100388:	89 04 24             	mov    %eax,(%esp)
  10038b:	e8 48 ff ff ff       	call   1002d8 <cputch>
    while ((c = *str ++) != '\0') {
  100390:	8b 45 08             	mov    0x8(%ebp),%eax
  100393:	8d 50 01             	lea    0x1(%eax),%edx
  100396:	89 55 08             	mov    %edx,0x8(%ebp)
  100399:	0f b6 00             	movzbl (%eax),%eax
  10039c:	88 45 f7             	mov    %al,-0x9(%ebp)
  10039f:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1003a3:	75 d8                	jne    10037d <cputs+0xf>
    }
    cputch('\n', &cnt);
  1003a5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1003a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1003ac:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  1003b3:	e8 20 ff ff ff       	call   1002d8 <cputch>
    return cnt;
  1003b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1003bb:	89 ec                	mov    %ebp,%esp
  1003bd:	5d                   	pop    %ebp
  1003be:	c3                   	ret    

001003bf <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1003bf:	55                   	push   %ebp
  1003c0:	89 e5                	mov    %esp,%ebp
  1003c2:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1003c5:	90                   	nop
  1003c6:	e8 91 12 00 00       	call   10165c <cons_getc>
  1003cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1003ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003d2:	74 f2                	je     1003c6 <getchar+0x7>
        /* do nothing */;
    return c;
  1003d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1003d7:	89 ec                	mov    %ebp,%esp
  1003d9:	5d                   	pop    %ebp
  1003da:	c3                   	ret    

001003db <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1003db:	55                   	push   %ebp
  1003dc:	89 e5                	mov    %esp,%ebp
  1003de:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1003e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003e4:	8b 00                	mov    (%eax),%eax
  1003e6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1003e9:	8b 45 10             	mov    0x10(%ebp),%eax
  1003ec:	8b 00                	mov    (%eax),%eax
  1003ee:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1003f1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1003f8:	e9 ca 00 00 00       	jmp    1004c7 <stab_binsearch+0xec>
        int true_m = (l + r) / 2, m = true_m;
  1003fd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100400:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100403:	01 d0                	add    %edx,%eax
  100405:	89 c2                	mov    %eax,%edx
  100407:	c1 ea 1f             	shr    $0x1f,%edx
  10040a:	01 d0                	add    %edx,%eax
  10040c:	d1 f8                	sar    %eax
  10040e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  100411:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100414:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  100417:	eb 03                	jmp    10041c <stab_binsearch+0x41>
            m --;
  100419:	ff 4d f0             	decl   -0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
  10041c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10041f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100422:	7c 1f                	jl     100443 <stab_binsearch+0x68>
  100424:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100427:	89 d0                	mov    %edx,%eax
  100429:	01 c0                	add    %eax,%eax
  10042b:	01 d0                	add    %edx,%eax
  10042d:	c1 e0 02             	shl    $0x2,%eax
  100430:	89 c2                	mov    %eax,%edx
  100432:	8b 45 08             	mov    0x8(%ebp),%eax
  100435:	01 d0                	add    %edx,%eax
  100437:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10043b:	0f b6 c0             	movzbl %al,%eax
  10043e:	39 45 14             	cmp    %eax,0x14(%ebp)
  100441:	75 d6                	jne    100419 <stab_binsearch+0x3e>
        }
        if (m < l) {    // no match in [l, m]
  100443:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100446:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100449:	7d 09                	jge    100454 <stab_binsearch+0x79>
            l = true_m + 1;
  10044b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10044e:	40                   	inc    %eax
  10044f:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100452:	eb 73                	jmp    1004c7 <stab_binsearch+0xec>
        }

        // actual binary search
        any_matches = 1;
  100454:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  10045b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10045e:	89 d0                	mov    %edx,%eax
  100460:	01 c0                	add    %eax,%eax
  100462:	01 d0                	add    %edx,%eax
  100464:	c1 e0 02             	shl    $0x2,%eax
  100467:	89 c2                	mov    %eax,%edx
  100469:	8b 45 08             	mov    0x8(%ebp),%eax
  10046c:	01 d0                	add    %edx,%eax
  10046e:	8b 40 08             	mov    0x8(%eax),%eax
  100471:	39 45 18             	cmp    %eax,0x18(%ebp)
  100474:	76 11                	jbe    100487 <stab_binsearch+0xac>
            *region_left = m;
  100476:	8b 45 0c             	mov    0xc(%ebp),%eax
  100479:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10047c:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  10047e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100481:	40                   	inc    %eax
  100482:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100485:	eb 40                	jmp    1004c7 <stab_binsearch+0xec>
        } else if (stabs[m].n_value > addr) {
  100487:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10048a:	89 d0                	mov    %edx,%eax
  10048c:	01 c0                	add    %eax,%eax
  10048e:	01 d0                	add    %edx,%eax
  100490:	c1 e0 02             	shl    $0x2,%eax
  100493:	89 c2                	mov    %eax,%edx
  100495:	8b 45 08             	mov    0x8(%ebp),%eax
  100498:	01 d0                	add    %edx,%eax
  10049a:	8b 40 08             	mov    0x8(%eax),%eax
  10049d:	39 45 18             	cmp    %eax,0x18(%ebp)
  1004a0:	73 14                	jae    1004b6 <stab_binsearch+0xdb>
            *region_right = m - 1;
  1004a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004a5:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004a8:	8b 45 10             	mov    0x10(%ebp),%eax
  1004ab:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  1004ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004b0:	48                   	dec    %eax
  1004b1:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004b4:	eb 11                	jmp    1004c7 <stab_binsearch+0xec>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1004b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004b9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004bc:	89 10                	mov    %edx,(%eax)
            l = m;
  1004be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004c1:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1004c4:	ff 45 18             	incl   0x18(%ebp)
    while (l <= r) {
  1004c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1004ca:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1004cd:	0f 8e 2a ff ff ff    	jle    1003fd <stab_binsearch+0x22>
        }
    }

    if (!any_matches) {
  1004d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1004d7:	75 0f                	jne    1004e8 <stab_binsearch+0x10d>
        *region_right = *region_left - 1;
  1004d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004dc:	8b 00                	mov    (%eax),%eax
  1004de:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004e1:	8b 45 10             	mov    0x10(%ebp),%eax
  1004e4:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
  1004e6:	eb 3e                	jmp    100526 <stab_binsearch+0x14b>
        l = *region_right;
  1004e8:	8b 45 10             	mov    0x10(%ebp),%eax
  1004eb:	8b 00                	mov    (%eax),%eax
  1004ed:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1004f0:	eb 03                	jmp    1004f5 <stab_binsearch+0x11a>
  1004f2:	ff 4d fc             	decl   -0x4(%ebp)
  1004f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004f8:	8b 00                	mov    (%eax),%eax
  1004fa:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  1004fd:	7e 1f                	jle    10051e <stab_binsearch+0x143>
  1004ff:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100502:	89 d0                	mov    %edx,%eax
  100504:	01 c0                	add    %eax,%eax
  100506:	01 d0                	add    %edx,%eax
  100508:	c1 e0 02             	shl    $0x2,%eax
  10050b:	89 c2                	mov    %eax,%edx
  10050d:	8b 45 08             	mov    0x8(%ebp),%eax
  100510:	01 d0                	add    %edx,%eax
  100512:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100516:	0f b6 c0             	movzbl %al,%eax
  100519:	39 45 14             	cmp    %eax,0x14(%ebp)
  10051c:	75 d4                	jne    1004f2 <stab_binsearch+0x117>
        *region_left = l;
  10051e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100521:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100524:	89 10                	mov    %edx,(%eax)
}
  100526:	90                   	nop
  100527:	89 ec                	mov    %ebp,%esp
  100529:	5d                   	pop    %ebp
  10052a:	c3                   	ret    

0010052b <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  10052b:	55                   	push   %ebp
  10052c:	89 e5                	mov    %esp,%ebp
  10052e:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  100531:	8b 45 0c             	mov    0xc(%ebp),%eax
  100534:	c7 00 4c 37 10 00    	movl   $0x10374c,(%eax)
    info->eip_line = 0;
  10053a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10053d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  100544:	8b 45 0c             	mov    0xc(%ebp),%eax
  100547:	c7 40 08 4c 37 10 00 	movl   $0x10374c,0x8(%eax)
    info->eip_fn_namelen = 9;
  10054e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100551:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100558:	8b 45 0c             	mov    0xc(%ebp),%eax
  10055b:	8b 55 08             	mov    0x8(%ebp),%edx
  10055e:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100561:	8b 45 0c             	mov    0xc(%ebp),%eax
  100564:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  10056b:	c7 45 f4 cc 3f 10 00 	movl   $0x103fcc,-0xc(%ebp)
    stab_end = __STAB_END__;
  100572:	c7 45 f0 34 bf 10 00 	movl   $0x10bf34,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100579:	c7 45 ec 35 bf 10 00 	movl   $0x10bf35,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100580:	c7 45 e8 b8 e8 10 00 	movl   $0x10e8b8,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  100587:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10058a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  10058d:	76 0b                	jbe    10059a <debuginfo_eip+0x6f>
  10058f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100592:	48                   	dec    %eax
  100593:	0f b6 00             	movzbl (%eax),%eax
  100596:	84 c0                	test   %al,%al
  100598:	74 0a                	je     1005a4 <debuginfo_eip+0x79>
        return -1;
  10059a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10059f:	e9 ab 02 00 00       	jmp    10084f <debuginfo_eip+0x324>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  1005a4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  1005ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1005ae:	2b 45 f4             	sub    -0xc(%ebp),%eax
  1005b1:	c1 f8 02             	sar    $0x2,%eax
  1005b4:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1005ba:	48                   	dec    %eax
  1005bb:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1005be:	8b 45 08             	mov    0x8(%ebp),%eax
  1005c1:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005c5:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1005cc:	00 
  1005cd:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1005d0:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005d4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1005d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1005db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005de:	89 04 24             	mov    %eax,(%esp)
  1005e1:	e8 f5 fd ff ff       	call   1003db <stab_binsearch>
    if (lfile == 0)
  1005e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005e9:	85 c0                	test   %eax,%eax
  1005eb:	75 0a                	jne    1005f7 <debuginfo_eip+0xcc>
        return -1;
  1005ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1005f2:	e9 58 02 00 00       	jmp    10084f <debuginfo_eip+0x324>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1005f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005fa:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1005fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100600:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  100603:	8b 45 08             	mov    0x8(%ebp),%eax
  100606:	89 44 24 10          	mov    %eax,0x10(%esp)
  10060a:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  100611:	00 
  100612:	8d 45 d8             	lea    -0x28(%ebp),%eax
  100615:	89 44 24 08          	mov    %eax,0x8(%esp)
  100619:	8d 45 dc             	lea    -0x24(%ebp),%eax
  10061c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100620:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100623:	89 04 24             	mov    %eax,(%esp)
  100626:	e8 b0 fd ff ff       	call   1003db <stab_binsearch>

    if (lfun <= rfun) {
  10062b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10062e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100631:	39 c2                	cmp    %eax,%edx
  100633:	7f 78                	jg     1006ad <debuginfo_eip+0x182>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  100635:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100638:	89 c2                	mov    %eax,%edx
  10063a:	89 d0                	mov    %edx,%eax
  10063c:	01 c0                	add    %eax,%eax
  10063e:	01 d0                	add    %edx,%eax
  100640:	c1 e0 02             	shl    $0x2,%eax
  100643:	89 c2                	mov    %eax,%edx
  100645:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100648:	01 d0                	add    %edx,%eax
  10064a:	8b 10                	mov    (%eax),%edx
  10064c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10064f:	2b 45 ec             	sub    -0x14(%ebp),%eax
  100652:	39 c2                	cmp    %eax,%edx
  100654:	73 22                	jae    100678 <debuginfo_eip+0x14d>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  100656:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100659:	89 c2                	mov    %eax,%edx
  10065b:	89 d0                	mov    %edx,%eax
  10065d:	01 c0                	add    %eax,%eax
  10065f:	01 d0                	add    %edx,%eax
  100661:	c1 e0 02             	shl    $0x2,%eax
  100664:	89 c2                	mov    %eax,%edx
  100666:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100669:	01 d0                	add    %edx,%eax
  10066b:	8b 10                	mov    (%eax),%edx
  10066d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100670:	01 c2                	add    %eax,%edx
  100672:	8b 45 0c             	mov    0xc(%ebp),%eax
  100675:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  100678:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10067b:	89 c2                	mov    %eax,%edx
  10067d:	89 d0                	mov    %edx,%eax
  10067f:	01 c0                	add    %eax,%eax
  100681:	01 d0                	add    %edx,%eax
  100683:	c1 e0 02             	shl    $0x2,%eax
  100686:	89 c2                	mov    %eax,%edx
  100688:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10068b:	01 d0                	add    %edx,%eax
  10068d:	8b 50 08             	mov    0x8(%eax),%edx
  100690:	8b 45 0c             	mov    0xc(%ebp),%eax
  100693:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  100696:	8b 45 0c             	mov    0xc(%ebp),%eax
  100699:	8b 40 10             	mov    0x10(%eax),%eax
  10069c:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  10069f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006a2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  1006a5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006a8:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1006ab:	eb 15                	jmp    1006c2 <debuginfo_eip+0x197>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  1006ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006b0:	8b 55 08             	mov    0x8(%ebp),%edx
  1006b3:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1006b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006b9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1006bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006bf:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1006c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006c5:	8b 40 08             	mov    0x8(%eax),%eax
  1006c8:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1006cf:	00 
  1006d0:	89 04 24             	mov    %eax,(%esp)
  1006d3:	e8 95 2c 00 00       	call   10336d <strfind>
  1006d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  1006db:	8b 4a 08             	mov    0x8(%edx),%ecx
  1006de:	29 c8                	sub    %ecx,%eax
  1006e0:	89 c2                	mov    %eax,%edx
  1006e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006e5:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1006e8:	8b 45 08             	mov    0x8(%ebp),%eax
  1006eb:	89 44 24 10          	mov    %eax,0x10(%esp)
  1006ef:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  1006f6:	00 
  1006f7:	8d 45 d0             	lea    -0x30(%ebp),%eax
  1006fa:	89 44 24 08          	mov    %eax,0x8(%esp)
  1006fe:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  100701:	89 44 24 04          	mov    %eax,0x4(%esp)
  100705:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100708:	89 04 24             	mov    %eax,(%esp)
  10070b:	e8 cb fc ff ff       	call   1003db <stab_binsearch>
    if (lline <= rline) {
  100710:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100713:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100716:	39 c2                	cmp    %eax,%edx
  100718:	7f 23                	jg     10073d <debuginfo_eip+0x212>
        info->eip_line = stabs[rline].n_desc;
  10071a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10071d:	89 c2                	mov    %eax,%edx
  10071f:	89 d0                	mov    %edx,%eax
  100721:	01 c0                	add    %eax,%eax
  100723:	01 d0                	add    %edx,%eax
  100725:	c1 e0 02             	shl    $0x2,%eax
  100728:	89 c2                	mov    %eax,%edx
  10072a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10072d:	01 d0                	add    %edx,%eax
  10072f:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  100733:	89 c2                	mov    %eax,%edx
  100735:	8b 45 0c             	mov    0xc(%ebp),%eax
  100738:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  10073b:	eb 11                	jmp    10074e <debuginfo_eip+0x223>
        return -1;
  10073d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100742:	e9 08 01 00 00       	jmp    10084f <debuginfo_eip+0x324>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  100747:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10074a:	48                   	dec    %eax
  10074b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
  10074e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100751:	8b 45 e4             	mov    -0x1c(%ebp),%eax
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100754:	39 c2                	cmp    %eax,%edx
  100756:	7c 56                	jl     1007ae <debuginfo_eip+0x283>
           && stabs[lline].n_type != N_SOL
  100758:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10075b:	89 c2                	mov    %eax,%edx
  10075d:	89 d0                	mov    %edx,%eax
  10075f:	01 c0                	add    %eax,%eax
  100761:	01 d0                	add    %edx,%eax
  100763:	c1 e0 02             	shl    $0x2,%eax
  100766:	89 c2                	mov    %eax,%edx
  100768:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10076b:	01 d0                	add    %edx,%eax
  10076d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100771:	3c 84                	cmp    $0x84,%al
  100773:	74 39                	je     1007ae <debuginfo_eip+0x283>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100775:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100778:	89 c2                	mov    %eax,%edx
  10077a:	89 d0                	mov    %edx,%eax
  10077c:	01 c0                	add    %eax,%eax
  10077e:	01 d0                	add    %edx,%eax
  100780:	c1 e0 02             	shl    $0x2,%eax
  100783:	89 c2                	mov    %eax,%edx
  100785:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100788:	01 d0                	add    %edx,%eax
  10078a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10078e:	3c 64                	cmp    $0x64,%al
  100790:	75 b5                	jne    100747 <debuginfo_eip+0x21c>
  100792:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100795:	89 c2                	mov    %eax,%edx
  100797:	89 d0                	mov    %edx,%eax
  100799:	01 c0                	add    %eax,%eax
  10079b:	01 d0                	add    %edx,%eax
  10079d:	c1 e0 02             	shl    $0x2,%eax
  1007a0:	89 c2                	mov    %eax,%edx
  1007a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007a5:	01 d0                	add    %edx,%eax
  1007a7:	8b 40 08             	mov    0x8(%eax),%eax
  1007aa:	85 c0                	test   %eax,%eax
  1007ac:	74 99                	je     100747 <debuginfo_eip+0x21c>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  1007ae:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007b4:	39 c2                	cmp    %eax,%edx
  1007b6:	7c 42                	jl     1007fa <debuginfo_eip+0x2cf>
  1007b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007bb:	89 c2                	mov    %eax,%edx
  1007bd:	89 d0                	mov    %edx,%eax
  1007bf:	01 c0                	add    %eax,%eax
  1007c1:	01 d0                	add    %edx,%eax
  1007c3:	c1 e0 02             	shl    $0x2,%eax
  1007c6:	89 c2                	mov    %eax,%edx
  1007c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007cb:	01 d0                	add    %edx,%eax
  1007cd:	8b 10                	mov    (%eax),%edx
  1007cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1007d2:	2b 45 ec             	sub    -0x14(%ebp),%eax
  1007d5:	39 c2                	cmp    %eax,%edx
  1007d7:	73 21                	jae    1007fa <debuginfo_eip+0x2cf>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1007d9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007dc:	89 c2                	mov    %eax,%edx
  1007de:	89 d0                	mov    %edx,%eax
  1007e0:	01 c0                	add    %eax,%eax
  1007e2:	01 d0                	add    %edx,%eax
  1007e4:	c1 e0 02             	shl    $0x2,%eax
  1007e7:	89 c2                	mov    %eax,%edx
  1007e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007ec:	01 d0                	add    %edx,%eax
  1007ee:	8b 10                	mov    (%eax),%edx
  1007f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007f3:	01 c2                	add    %eax,%edx
  1007f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007f8:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  1007fa:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1007fd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100800:	39 c2                	cmp    %eax,%edx
  100802:	7d 46                	jge    10084a <debuginfo_eip+0x31f>
        for (lline = lfun + 1;
  100804:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100807:	40                   	inc    %eax
  100808:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  10080b:	eb 16                	jmp    100823 <debuginfo_eip+0x2f8>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  10080d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100810:	8b 40 14             	mov    0x14(%eax),%eax
  100813:	8d 50 01             	lea    0x1(%eax),%edx
  100816:	8b 45 0c             	mov    0xc(%ebp),%eax
  100819:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
  10081c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10081f:	40                   	inc    %eax
  100820:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100823:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100826:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100829:	39 c2                	cmp    %eax,%edx
  10082b:	7d 1d                	jge    10084a <debuginfo_eip+0x31f>
  10082d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100830:	89 c2                	mov    %eax,%edx
  100832:	89 d0                	mov    %edx,%eax
  100834:	01 c0                	add    %eax,%eax
  100836:	01 d0                	add    %edx,%eax
  100838:	c1 e0 02             	shl    $0x2,%eax
  10083b:	89 c2                	mov    %eax,%edx
  10083d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100840:	01 d0                	add    %edx,%eax
  100842:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100846:	3c a0                	cmp    $0xa0,%al
  100848:	74 c3                	je     10080d <debuginfo_eip+0x2e2>
        }
    }
    return 0;
  10084a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10084f:	89 ec                	mov    %ebp,%esp
  100851:	5d                   	pop    %ebp
  100852:	c3                   	ret    

00100853 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100853:	55                   	push   %ebp
  100854:	89 e5                	mov    %esp,%ebp
  100856:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  100859:	c7 04 24 56 37 10 00 	movl   $0x103756,(%esp)
  100860:	e8 cb fa ff ff       	call   100330 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100865:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  10086c:	00 
  10086d:	c7 04 24 6f 37 10 00 	movl   $0x10376f,(%esp)
  100874:	e8 b7 fa ff ff       	call   100330 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  100879:	c7 44 24 04 81 36 10 	movl   $0x103681,0x4(%esp)
  100880:	00 
  100881:	c7 04 24 87 37 10 00 	movl   $0x103787,(%esp)
  100888:	e8 a3 fa ff ff       	call   100330 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  10088d:	c7 44 24 04 16 fa 10 	movl   $0x10fa16,0x4(%esp)
  100894:	00 
  100895:	c7 04 24 9f 37 10 00 	movl   $0x10379f,(%esp)
  10089c:	e8 8f fa ff ff       	call   100330 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  1008a1:	c7 44 24 04 68 0d 11 	movl   $0x110d68,0x4(%esp)
  1008a8:	00 
  1008a9:	c7 04 24 b7 37 10 00 	movl   $0x1037b7,(%esp)
  1008b0:	e8 7b fa ff ff       	call   100330 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1008b5:	b8 68 0d 11 00       	mov    $0x110d68,%eax
  1008ba:	2d 00 00 10 00       	sub    $0x100000,%eax
  1008bf:	05 ff 03 00 00       	add    $0x3ff,%eax
  1008c4:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008ca:	85 c0                	test   %eax,%eax
  1008cc:	0f 48 c2             	cmovs  %edx,%eax
  1008cf:	c1 f8 0a             	sar    $0xa,%eax
  1008d2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008d6:	c7 04 24 d0 37 10 00 	movl   $0x1037d0,(%esp)
  1008dd:	e8 4e fa ff ff       	call   100330 <cprintf>
}
  1008e2:	90                   	nop
  1008e3:	89 ec                	mov    %ebp,%esp
  1008e5:	5d                   	pop    %ebp
  1008e6:	c3                   	ret    

001008e7 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  1008e7:	55                   	push   %ebp
  1008e8:	89 e5                	mov    %esp,%ebp
  1008ea:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  1008f0:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1008f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008f7:	8b 45 08             	mov    0x8(%ebp),%eax
  1008fa:	89 04 24             	mov    %eax,(%esp)
  1008fd:	e8 29 fc ff ff       	call   10052b <debuginfo_eip>
  100902:	85 c0                	test   %eax,%eax
  100904:	74 15                	je     10091b <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  100906:	8b 45 08             	mov    0x8(%ebp),%eax
  100909:	89 44 24 04          	mov    %eax,0x4(%esp)
  10090d:	c7 04 24 fa 37 10 00 	movl   $0x1037fa,(%esp)
  100914:	e8 17 fa ff ff       	call   100330 <cprintf>
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
  100919:	eb 6c                	jmp    100987 <print_debuginfo+0xa0>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  10091b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100922:	eb 1b                	jmp    10093f <print_debuginfo+0x58>
            fnname[j] = info.eip_fn_name[j];
  100924:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100927:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10092a:	01 d0                	add    %edx,%eax
  10092c:	0f b6 10             	movzbl (%eax),%edx
  10092f:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100935:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100938:	01 c8                	add    %ecx,%eax
  10093a:	88 10                	mov    %dl,(%eax)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  10093c:	ff 45 f4             	incl   -0xc(%ebp)
  10093f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100942:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  100945:	7c dd                	jl     100924 <print_debuginfo+0x3d>
        fnname[j] = '\0';
  100947:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  10094d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100950:	01 d0                	add    %edx,%eax
  100952:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
  100955:	8b 55 ec             	mov    -0x14(%ebp),%edx
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100958:	8b 45 08             	mov    0x8(%ebp),%eax
  10095b:	29 d0                	sub    %edx,%eax
  10095d:	89 c1                	mov    %eax,%ecx
  10095f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100962:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100965:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100969:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  10096f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100973:	89 54 24 08          	mov    %edx,0x8(%esp)
  100977:	89 44 24 04          	mov    %eax,0x4(%esp)
  10097b:	c7 04 24 16 38 10 00 	movl   $0x103816,(%esp)
  100982:	e8 a9 f9 ff ff       	call   100330 <cprintf>
}
  100987:	90                   	nop
  100988:	89 ec                	mov    %ebp,%esp
  10098a:	5d                   	pop    %ebp
  10098b:	c3                   	ret    

0010098c <read_eip>:

static __noinline uint32_t
read_eip(void) {
  10098c:	55                   	push   %ebp
  10098d:	89 e5                	mov    %esp,%ebp
  10098f:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100992:	8b 45 04             	mov    0x4(%ebp),%eax
  100995:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100998:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10099b:	89 ec                	mov    %ebp,%esp
  10099d:	5d                   	pop    %ebp
  10099e:	c3                   	ret    

0010099f <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  10099f:	55                   	push   %ebp
  1009a0:	89 e5                	mov    %esp,%ebp
  1009a2:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  1009a5:	89 e8                	mov    %ebp,%eax
  1009a7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return ebp;
  1009aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
     uint32_t ebp=read_ebp();
  1009ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
     uint32_t eip=read_eip();
  1009b0:	e8 d7 ff ff ff       	call   10098c <read_eip>
  1009b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
     for(int i=0;i<STACKFRAME_DEPTH && ebp!=0;i++){
  1009b8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1009bf:	e9 a0 00 00 00       	jmp    100a64 <print_stackframe+0xc5>
        cprintf("ebp:0x%08x",ebp);
  1009c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009cb:	c7 04 24 28 38 10 00 	movl   $0x103828,(%esp)
  1009d2:	e8 59 f9 ff ff       	call   100330 <cprintf>
        cprintf(" eip:0x%08x",eip);
  1009d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1009da:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009de:	c7 04 24 33 38 10 00 	movl   $0x103833,(%esp)
  1009e5:	e8 46 f9 ff ff       	call   100330 <cprintf>
        cprintf(" args:");
  1009ea:	c7 04 24 3f 38 10 00 	movl   $0x10383f,(%esp)
  1009f1:	e8 3a f9 ff ff       	call   100330 <cprintf>
        for(int j=1;j<5;j++){
  1009f6:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
  1009fd:	eb 31                	jmp    100a30 <print_stackframe+0x91>
            cprintf("0x%08x",*(uint32_t*)(ebp + 4*j + 4));
  1009ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a02:	c1 e0 02             	shl    $0x2,%eax
  100a05:	89 c2                	mov    %eax,%edx
  100a07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a0a:	01 d0                	add    %edx,%eax
  100a0c:	83 c0 04             	add    $0x4,%eax
  100a0f:	8b 00                	mov    (%eax),%eax
  100a11:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a15:	c7 04 24 46 38 10 00 	movl   $0x103846,(%esp)
  100a1c:	e8 0f f9 ff ff       	call   100330 <cprintf>
            cprintf(" ");
  100a21:	c7 04 24 4d 38 10 00 	movl   $0x10384d,(%esp)
  100a28:	e8 03 f9 ff ff       	call   100330 <cprintf>
        for(int j=1;j<5;j++){
  100a2d:	ff 45 e8             	incl   -0x18(%ebp)
  100a30:	83 7d e8 04          	cmpl   $0x4,-0x18(%ebp)
  100a34:	7e c9                	jle    1009ff <print_stackframe+0x60>
        }
        cprintf("\n");
  100a36:	c7 04 24 4f 38 10 00 	movl   $0x10384f,(%esp)
  100a3d:	e8 ee f8 ff ff       	call   100330 <cprintf>
        print_debuginfo(eip-1);
  100a42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a45:	48                   	dec    %eax
  100a46:	89 04 24             	mov    %eax,(%esp)
  100a49:	e8 99 fe ff ff       	call   1008e7 <print_debuginfo>
        eip=*(uint32_t*)(ebp+4);
  100a4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a51:	83 c0 04             	add    $0x4,%eax
  100a54:	8b 00                	mov    (%eax),%eax
  100a56:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp=*(uint32_t*)(ebp);
  100a59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a5c:	8b 00                	mov    (%eax),%eax
  100a5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
     for(int i=0;i<STACKFRAME_DEPTH && ebp!=0;i++){
  100a61:	ff 45 ec             	incl   -0x14(%ebp)
  100a64:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100a68:	7f 0a                	jg     100a74 <print_stackframe+0xd5>
  100a6a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100a6e:	0f 85 50 ff ff ff    	jne    1009c4 <print_stackframe+0x25>
     }

}
  100a74:	90                   	nop
  100a75:	89 ec                	mov    %ebp,%esp
  100a77:	5d                   	pop    %ebp
  100a78:	c3                   	ret    

00100a79 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100a79:	55                   	push   %ebp
  100a7a:	89 e5                	mov    %esp,%ebp
  100a7c:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100a7f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a86:	eb 0c                	jmp    100a94 <parse+0x1b>
            *buf ++ = '\0';
  100a88:	8b 45 08             	mov    0x8(%ebp),%eax
  100a8b:	8d 50 01             	lea    0x1(%eax),%edx
  100a8e:	89 55 08             	mov    %edx,0x8(%ebp)
  100a91:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a94:	8b 45 08             	mov    0x8(%ebp),%eax
  100a97:	0f b6 00             	movzbl (%eax),%eax
  100a9a:	84 c0                	test   %al,%al
  100a9c:	74 1d                	je     100abb <parse+0x42>
  100a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  100aa1:	0f b6 00             	movzbl (%eax),%eax
  100aa4:	0f be c0             	movsbl %al,%eax
  100aa7:	89 44 24 04          	mov    %eax,0x4(%esp)
  100aab:	c7 04 24 d4 38 10 00 	movl   $0x1038d4,(%esp)
  100ab2:	e8 82 28 00 00       	call   103339 <strchr>
  100ab7:	85 c0                	test   %eax,%eax
  100ab9:	75 cd                	jne    100a88 <parse+0xf>
        }
        if (*buf == '\0') {
  100abb:	8b 45 08             	mov    0x8(%ebp),%eax
  100abe:	0f b6 00             	movzbl (%eax),%eax
  100ac1:	84 c0                	test   %al,%al
  100ac3:	74 65                	je     100b2a <parse+0xb1>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100ac5:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100ac9:	75 14                	jne    100adf <parse+0x66>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100acb:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100ad2:	00 
  100ad3:	c7 04 24 d9 38 10 00 	movl   $0x1038d9,(%esp)
  100ada:	e8 51 f8 ff ff       	call   100330 <cprintf>
        }
        argv[argc ++] = buf;
  100adf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ae2:	8d 50 01             	lea    0x1(%eax),%edx
  100ae5:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100ae8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100aef:	8b 45 0c             	mov    0xc(%ebp),%eax
  100af2:	01 c2                	add    %eax,%edx
  100af4:	8b 45 08             	mov    0x8(%ebp),%eax
  100af7:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100af9:	eb 03                	jmp    100afe <parse+0x85>
            buf ++;
  100afb:	ff 45 08             	incl   0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100afe:	8b 45 08             	mov    0x8(%ebp),%eax
  100b01:	0f b6 00             	movzbl (%eax),%eax
  100b04:	84 c0                	test   %al,%al
  100b06:	74 8c                	je     100a94 <parse+0x1b>
  100b08:	8b 45 08             	mov    0x8(%ebp),%eax
  100b0b:	0f b6 00             	movzbl (%eax),%eax
  100b0e:	0f be c0             	movsbl %al,%eax
  100b11:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b15:	c7 04 24 d4 38 10 00 	movl   $0x1038d4,(%esp)
  100b1c:	e8 18 28 00 00       	call   103339 <strchr>
  100b21:	85 c0                	test   %eax,%eax
  100b23:	74 d6                	je     100afb <parse+0x82>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b25:	e9 6a ff ff ff       	jmp    100a94 <parse+0x1b>
            break;
  100b2a:	90                   	nop
        }
    }
    return argc;
  100b2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100b2e:	89 ec                	mov    %ebp,%esp
  100b30:	5d                   	pop    %ebp
  100b31:	c3                   	ret    

00100b32 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100b32:	55                   	push   %ebp
  100b33:	89 e5                	mov    %esp,%ebp
  100b35:	83 ec 68             	sub    $0x68,%esp
  100b38:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100b3b:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b3e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b42:	8b 45 08             	mov    0x8(%ebp),%eax
  100b45:	89 04 24             	mov    %eax,(%esp)
  100b48:	e8 2c ff ff ff       	call   100a79 <parse>
  100b4d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100b50:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100b54:	75 0a                	jne    100b60 <runcmd+0x2e>
        return 0;
  100b56:	b8 00 00 00 00       	mov    $0x0,%eax
  100b5b:	e9 83 00 00 00       	jmp    100be3 <runcmd+0xb1>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b60:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b67:	eb 5a                	jmp    100bc3 <runcmd+0x91>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100b69:	8b 55 b0             	mov    -0x50(%ebp),%edx
  100b6c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  100b6f:	89 c8                	mov    %ecx,%eax
  100b71:	01 c0                	add    %eax,%eax
  100b73:	01 c8                	add    %ecx,%eax
  100b75:	c1 e0 02             	shl    $0x2,%eax
  100b78:	05 00 f0 10 00       	add    $0x10f000,%eax
  100b7d:	8b 00                	mov    (%eax),%eax
  100b7f:	89 54 24 04          	mov    %edx,0x4(%esp)
  100b83:	89 04 24             	mov    %eax,(%esp)
  100b86:	e8 12 27 00 00       	call   10329d <strcmp>
  100b8b:	85 c0                	test   %eax,%eax
  100b8d:	75 31                	jne    100bc0 <runcmd+0x8e>
            return commands[i].func(argc - 1, argv + 1, tf);
  100b8f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b92:	89 d0                	mov    %edx,%eax
  100b94:	01 c0                	add    %eax,%eax
  100b96:	01 d0                	add    %edx,%eax
  100b98:	c1 e0 02             	shl    $0x2,%eax
  100b9b:	05 08 f0 10 00       	add    $0x10f008,%eax
  100ba0:	8b 10                	mov    (%eax),%edx
  100ba2:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100ba5:	83 c0 04             	add    $0x4,%eax
  100ba8:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100bab:	8d 59 ff             	lea    -0x1(%ecx),%ebx
  100bae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  100bb1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100bb5:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bb9:	89 1c 24             	mov    %ebx,(%esp)
  100bbc:	ff d2                	call   *%edx
  100bbe:	eb 23                	jmp    100be3 <runcmd+0xb1>
    for (i = 0; i < NCOMMANDS; i ++) {
  100bc0:	ff 45 f4             	incl   -0xc(%ebp)
  100bc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bc6:	83 f8 02             	cmp    $0x2,%eax
  100bc9:	76 9e                	jbe    100b69 <runcmd+0x37>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100bcb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100bce:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bd2:	c7 04 24 f7 38 10 00 	movl   $0x1038f7,(%esp)
  100bd9:	e8 52 f7 ff ff       	call   100330 <cprintf>
    return 0;
  100bde:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100be3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  100be6:	89 ec                	mov    %ebp,%esp
  100be8:	5d                   	pop    %ebp
  100be9:	c3                   	ret    

00100bea <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100bea:	55                   	push   %ebp
  100beb:	89 e5                	mov    %esp,%ebp
  100bed:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100bf0:	c7 04 24 10 39 10 00 	movl   $0x103910,(%esp)
  100bf7:	e8 34 f7 ff ff       	call   100330 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100bfc:	c7 04 24 38 39 10 00 	movl   $0x103938,(%esp)
  100c03:	e8 28 f7 ff ff       	call   100330 <cprintf>

    if (tf != NULL) {
  100c08:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100c0c:	74 0b                	je     100c19 <kmonitor+0x2f>
        print_trapframe(tf);
  100c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  100c11:	89 04 24             	mov    %eax,(%esp)
  100c14:	e8 86 0e 00 00       	call   101a9f <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100c19:	c7 04 24 5d 39 10 00 	movl   $0x10395d,(%esp)
  100c20:	e8 fc f5 ff ff       	call   100221 <readline>
  100c25:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100c28:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100c2c:	74 eb                	je     100c19 <kmonitor+0x2f>
            if (runcmd(buf, tf) < 0) {
  100c2e:	8b 45 08             	mov    0x8(%ebp),%eax
  100c31:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c38:	89 04 24             	mov    %eax,(%esp)
  100c3b:	e8 f2 fe ff ff       	call   100b32 <runcmd>
  100c40:	85 c0                	test   %eax,%eax
  100c42:	78 02                	js     100c46 <kmonitor+0x5c>
        if ((buf = readline("K> ")) != NULL) {
  100c44:	eb d3                	jmp    100c19 <kmonitor+0x2f>
                break;
  100c46:	90                   	nop
            }
        }
    }
}
  100c47:	90                   	nop
  100c48:	89 ec                	mov    %ebp,%esp
  100c4a:	5d                   	pop    %ebp
  100c4b:	c3                   	ret    

00100c4c <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100c4c:	55                   	push   %ebp
  100c4d:	89 e5                	mov    %esp,%ebp
  100c4f:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c52:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c59:	eb 3d                	jmp    100c98 <mon_help+0x4c>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100c5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c5e:	89 d0                	mov    %edx,%eax
  100c60:	01 c0                	add    %eax,%eax
  100c62:	01 d0                	add    %edx,%eax
  100c64:	c1 e0 02             	shl    $0x2,%eax
  100c67:	05 04 f0 10 00       	add    $0x10f004,%eax
  100c6c:	8b 10                	mov    (%eax),%edx
  100c6e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  100c71:	89 c8                	mov    %ecx,%eax
  100c73:	01 c0                	add    %eax,%eax
  100c75:	01 c8                	add    %ecx,%eax
  100c77:	c1 e0 02             	shl    $0x2,%eax
  100c7a:	05 00 f0 10 00       	add    $0x10f000,%eax
  100c7f:	8b 00                	mov    (%eax),%eax
  100c81:	89 54 24 08          	mov    %edx,0x8(%esp)
  100c85:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c89:	c7 04 24 61 39 10 00 	movl   $0x103961,(%esp)
  100c90:	e8 9b f6 ff ff       	call   100330 <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
  100c95:	ff 45 f4             	incl   -0xc(%ebp)
  100c98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c9b:	83 f8 02             	cmp    $0x2,%eax
  100c9e:	76 bb                	jbe    100c5b <mon_help+0xf>
    }
    return 0;
  100ca0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100ca5:	89 ec                	mov    %ebp,%esp
  100ca7:	5d                   	pop    %ebp
  100ca8:	c3                   	ret    

00100ca9 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100ca9:	55                   	push   %ebp
  100caa:	89 e5                	mov    %esp,%ebp
  100cac:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100caf:	e8 9f fb ff ff       	call   100853 <print_kerninfo>
    return 0;
  100cb4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cb9:	89 ec                	mov    %ebp,%esp
  100cbb:	5d                   	pop    %ebp
  100cbc:	c3                   	ret    

00100cbd <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100cbd:	55                   	push   %ebp
  100cbe:	89 e5                	mov    %esp,%ebp
  100cc0:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100cc3:	e8 d7 fc ff ff       	call   10099f <print_stackframe>
    return 0;
  100cc8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100ccd:	89 ec                	mov    %ebp,%esp
  100ccf:	5d                   	pop    %ebp
  100cd0:	c3                   	ret    

00100cd1 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100cd1:	55                   	push   %ebp
  100cd2:	89 e5                	mov    %esp,%ebp
  100cd4:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100cd7:	a1 40 fe 10 00       	mov    0x10fe40,%eax
  100cdc:	85 c0                	test   %eax,%eax
  100cde:	75 5b                	jne    100d3b <__panic+0x6a>
        goto panic_dead;
    }
    is_panic = 1;
  100ce0:	c7 05 40 fe 10 00 01 	movl   $0x1,0x10fe40
  100ce7:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100cea:	8d 45 14             	lea    0x14(%ebp),%eax
  100ced:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100cf0:	8b 45 0c             	mov    0xc(%ebp),%eax
  100cf3:	89 44 24 08          	mov    %eax,0x8(%esp)
  100cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  100cfa:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cfe:	c7 04 24 6a 39 10 00 	movl   $0x10396a,(%esp)
  100d05:	e8 26 f6 ff ff       	call   100330 <cprintf>
    vcprintf(fmt, ap);
  100d0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d0d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d11:	8b 45 10             	mov    0x10(%ebp),%eax
  100d14:	89 04 24             	mov    %eax,(%esp)
  100d17:	e8 df f5 ff ff       	call   1002fb <vcprintf>
    cprintf("\n");
  100d1c:	c7 04 24 86 39 10 00 	movl   $0x103986,(%esp)
  100d23:	e8 08 f6 ff ff       	call   100330 <cprintf>
    
    cprintf("stack trackback:\n");
  100d28:	c7 04 24 88 39 10 00 	movl   $0x103988,(%esp)
  100d2f:	e8 fc f5 ff ff       	call   100330 <cprintf>
    print_stackframe();
  100d34:	e8 66 fc ff ff       	call   10099f <print_stackframe>
  100d39:	eb 01                	jmp    100d3c <__panic+0x6b>
        goto panic_dead;
  100d3b:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
  100d3c:	e8 81 09 00 00       	call   1016c2 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100d41:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100d48:	e8 9d fe ff ff       	call   100bea <kmonitor>
  100d4d:	eb f2                	jmp    100d41 <__panic+0x70>

00100d4f <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100d4f:	55                   	push   %ebp
  100d50:	89 e5                	mov    %esp,%ebp
  100d52:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100d55:	8d 45 14             	lea    0x14(%ebp),%eax
  100d58:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100d5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d5e:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d62:	8b 45 08             	mov    0x8(%ebp),%eax
  100d65:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d69:	c7 04 24 9a 39 10 00 	movl   $0x10399a,(%esp)
  100d70:	e8 bb f5 ff ff       	call   100330 <cprintf>
    vcprintf(fmt, ap);
  100d75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d78:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d7c:	8b 45 10             	mov    0x10(%ebp),%eax
  100d7f:	89 04 24             	mov    %eax,(%esp)
  100d82:	e8 74 f5 ff ff       	call   1002fb <vcprintf>
    cprintf("\n");
  100d87:	c7 04 24 86 39 10 00 	movl   $0x103986,(%esp)
  100d8e:	e8 9d f5 ff ff       	call   100330 <cprintf>
    va_end(ap);
}
  100d93:	90                   	nop
  100d94:	89 ec                	mov    %ebp,%esp
  100d96:	5d                   	pop    %ebp
  100d97:	c3                   	ret    

00100d98 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100d98:	55                   	push   %ebp
  100d99:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100d9b:	a1 40 fe 10 00       	mov    0x10fe40,%eax
}
  100da0:	5d                   	pop    %ebp
  100da1:	c3                   	ret    

00100da2 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100da2:	55                   	push   %ebp
  100da3:	89 e5                	mov    %esp,%ebp
  100da5:	83 ec 28             	sub    $0x28,%esp
  100da8:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
  100dae:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100db2:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100db6:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100dba:	ee                   	out    %al,(%dx)
}
  100dbb:	90                   	nop
  100dbc:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100dc2:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100dc6:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100dca:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100dce:	ee                   	out    %al,(%dx)
}
  100dcf:	90                   	nop
  100dd0:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
  100dd6:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100dda:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100dde:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100de2:	ee                   	out    %al,(%dx)
}
  100de3:	90                   	nop
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100de4:	c7 05 44 fe 10 00 00 	movl   $0x0,0x10fe44
  100deb:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100dee:	c7 04 24 b8 39 10 00 	movl   $0x1039b8,(%esp)
  100df5:	e8 36 f5 ff ff       	call   100330 <cprintf>
    pic_enable(IRQ_TIMER);
  100dfa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100e01:	e8 21 09 00 00       	call   101727 <pic_enable>
}
  100e06:	90                   	nop
  100e07:	89 ec                	mov    %ebp,%esp
  100e09:	5d                   	pop    %ebp
  100e0a:	c3                   	ret    

00100e0b <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100e0b:	55                   	push   %ebp
  100e0c:	89 e5                	mov    %esp,%ebp
  100e0e:	83 ec 10             	sub    $0x10,%esp
  100e11:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100e17:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e1b:	89 c2                	mov    %eax,%edx
  100e1d:	ec                   	in     (%dx),%al
  100e1e:	88 45 f1             	mov    %al,-0xf(%ebp)
  100e21:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100e27:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100e2b:	89 c2                	mov    %eax,%edx
  100e2d:	ec                   	in     (%dx),%al
  100e2e:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e31:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100e37:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100e3b:	89 c2                	mov    %eax,%edx
  100e3d:	ec                   	in     (%dx),%al
  100e3e:	88 45 f9             	mov    %al,-0x7(%ebp)
  100e41:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
  100e47:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100e4b:	89 c2                	mov    %eax,%edx
  100e4d:	ec                   	in     (%dx),%al
  100e4e:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e51:	90                   	nop
  100e52:	89 ec                	mov    %ebp,%esp
  100e54:	5d                   	pop    %ebp
  100e55:	c3                   	ret    

00100e56 <cga_init>:
//    -- 数据寄存器 映射 到 端口 0x3D5或0x3B5 
//    -- 索引寄存器 0x3D4或0x3B4,决定在数据寄存器中的数据表示什么。

/* TEXT-mode CGA/VGA display output */
static void
cga_init(void) {
  100e56:	55                   	push   %ebp
  100e57:	89 e5                	mov    %esp,%ebp
  100e59:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;   //CGA_BUF: 0xB8000 (彩色显示的显存物理基址)
  100e5c:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;                                            //保存当前显存0xB8000处的值
  100e63:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e66:	0f b7 00             	movzwl (%eax),%eax
  100e69:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;                                   // 给这个地址随便写个值，看看能否再读出同样的值
  100e6d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e70:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {                                            // 如果读不出来，说明没有这块显存，即是单显配置
  100e75:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e78:	0f b7 00             	movzwl (%eax),%eax
  100e7b:	0f b7 c0             	movzwl %ax,%eax
  100e7e:	3d 5a a5 00 00       	cmp    $0xa55a,%eax
  100e83:	74 12                	je     100e97 <cga_init+0x41>
        cp = (uint16_t*)MONO_BUF;                         //设置为单显的显存基址 MONO_BUF： 0xB0000
  100e85:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;                           //设置为单显控制的IO地址，MONO_BASE: 0x3B4
  100e8c:	66 c7 05 66 fe 10 00 	movw   $0x3b4,0x10fe66
  100e93:	b4 03 
  100e95:	eb 13                	jmp    100eaa <cga_init+0x54>
    } else {                                                                // 如果读出来了，有这块显存，即是彩显配置
        *cp = was;                                                      //还原原来显存位置的值
  100e97:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e9a:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100e9e:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;                               // 设置为彩显控制的IO地址，CGA_BASE: 0x3D4 
  100ea1:	66 c7 05 66 fe 10 00 	movw   $0x3d4,0x10fe66
  100ea8:	d4 03 
    // Extract cursor location
    // 6845索引寄存器的index 0x0E（及十进制的14）== 光标位置(高位)
    // 6845索引寄存器的index 0x0F（及十进制的15）== 光标位置(低位)
    // 6845 reg 15 : Cursor Address (Low Byte)
    uint32_t pos;
    outb(addr_6845, 14);                                        
  100eaa:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  100eb1:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  100eb5:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100eb9:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100ebd:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100ec1:	ee                   	out    %al,(%dx)
}
  100ec2:	90                   	nop
    pos = inb(addr_6845 + 1) << 8;                       //读出了光标位置(高位)
  100ec3:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  100eca:	40                   	inc    %eax
  100ecb:	0f b7 c0             	movzwl %ax,%eax
  100ece:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100ed2:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
  100ed6:	89 c2                	mov    %eax,%edx
  100ed8:	ec                   	in     (%dx),%al
  100ed9:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
  100edc:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100ee0:	0f b6 c0             	movzbl %al,%eax
  100ee3:	c1 e0 08             	shl    $0x8,%eax
  100ee6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100ee9:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  100ef0:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  100ef4:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100ef8:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100efc:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f00:	ee                   	out    %al,(%dx)
}
  100f01:	90                   	nop
    pos |= inb(addr_6845 + 1);                             //读出了光标位置(低位)
  100f02:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  100f09:	40                   	inc    %eax
  100f0a:	0f b7 c0             	movzwl %ax,%eax
  100f0d:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f11:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100f15:	89 c2                	mov    %eax,%edx
  100f17:	ec                   	in     (%dx),%al
  100f18:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
  100f1b:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f1f:	0f b6 c0             	movzbl %al,%eax
  100f22:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;                                  //crt_buf是CGA显存起始地址
  100f25:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f28:	a3 60 fe 10 00       	mov    %eax,0x10fe60
    crt_pos = pos;                                                  //crt_pos是CGA当前光标位置
  100f2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f30:	0f b7 c0             	movzwl %ax,%eax
  100f33:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
}
  100f39:	90                   	nop
  100f3a:	89 ec                	mov    %ebp,%esp
  100f3c:	5d                   	pop    %ebp
  100f3d:	c3                   	ret    

00100f3e <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f3e:	55                   	push   %ebp
  100f3f:	89 e5                	mov    %esp,%ebp
  100f41:	83 ec 48             	sub    $0x48,%esp
  100f44:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
  100f4a:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f4e:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  100f52:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  100f56:	ee                   	out    %al,(%dx)
}
  100f57:	90                   	nop
  100f58:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
  100f5e:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f62:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  100f66:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  100f6a:	ee                   	out    %al,(%dx)
}
  100f6b:	90                   	nop
  100f6c:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
  100f72:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f76:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  100f7a:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  100f7e:	ee                   	out    %al,(%dx)
}
  100f7f:	90                   	nop
  100f80:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100f86:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f8a:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100f8e:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100f92:	ee                   	out    %al,(%dx)
}
  100f93:	90                   	nop
  100f94:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
  100f9a:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f9e:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100fa2:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100fa6:	ee                   	out    %al,(%dx)
}
  100fa7:	90                   	nop
  100fa8:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
  100fae:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100fb2:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100fb6:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100fba:	ee                   	out    %al,(%dx)
}
  100fbb:	90                   	nop
  100fbc:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100fc2:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100fc6:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100fca:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100fce:	ee                   	out    %al,(%dx)
}
  100fcf:	90                   	nop
  100fd0:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100fd6:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100fda:	89 c2                	mov    %eax,%edx
  100fdc:	ec                   	in     (%dx),%al
  100fdd:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100fe0:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100fe4:	3c ff                	cmp    $0xff,%al
  100fe6:	0f 95 c0             	setne  %al
  100fe9:	0f b6 c0             	movzbl %al,%eax
  100fec:	a3 68 fe 10 00       	mov    %eax,0x10fe68
  100ff1:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100ff7:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100ffb:	89 c2                	mov    %eax,%edx
  100ffd:	ec                   	in     (%dx),%al
  100ffe:	88 45 f1             	mov    %al,-0xf(%ebp)
  101001:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  101007:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10100b:	89 c2                	mov    %eax,%edx
  10100d:	ec                   	in     (%dx),%al
  10100e:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  101011:	a1 68 fe 10 00       	mov    0x10fe68,%eax
  101016:	85 c0                	test   %eax,%eax
  101018:	74 0c                	je     101026 <serial_init+0xe8>
        pic_enable(IRQ_COM1);
  10101a:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  101021:	e8 01 07 00 00       	call   101727 <pic_enable>
    }
}
  101026:	90                   	nop
  101027:	89 ec                	mov    %ebp,%esp
  101029:	5d                   	pop    %ebp
  10102a:	c3                   	ret    

0010102b <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  10102b:	55                   	push   %ebp
  10102c:	89 e5                	mov    %esp,%ebp
  10102e:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101031:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101038:	eb 08                	jmp    101042 <lpt_putc_sub+0x17>
        delay();
  10103a:	e8 cc fd ff ff       	call   100e0b <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  10103f:	ff 45 fc             	incl   -0x4(%ebp)
  101042:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  101048:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10104c:	89 c2                	mov    %eax,%edx
  10104e:	ec                   	in     (%dx),%al
  10104f:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101052:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101056:	84 c0                	test   %al,%al
  101058:	78 09                	js     101063 <lpt_putc_sub+0x38>
  10105a:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101061:	7e d7                	jle    10103a <lpt_putc_sub+0xf>
    }
    outb(LPTPORT + 0, c);
  101063:	8b 45 08             	mov    0x8(%ebp),%eax
  101066:	0f b6 c0             	movzbl %al,%eax
  101069:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
  10106f:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101072:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101076:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10107a:	ee                   	out    %al,(%dx)
}
  10107b:	90                   	nop
  10107c:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  101082:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101086:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10108a:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10108e:	ee                   	out    %al,(%dx)
}
  10108f:	90                   	nop
  101090:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  101096:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10109a:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10109e:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1010a2:	ee                   	out    %al,(%dx)
}
  1010a3:	90                   	nop
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  1010a4:	90                   	nop
  1010a5:	89 ec                	mov    %ebp,%esp
  1010a7:	5d                   	pop    %ebp
  1010a8:	c3                   	ret    

001010a9 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  1010a9:	55                   	push   %ebp
  1010aa:	89 e5                	mov    %esp,%ebp
  1010ac:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1010af:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1010b3:	74 0d                	je     1010c2 <lpt_putc+0x19>
        lpt_putc_sub(c);
  1010b5:	8b 45 08             	mov    0x8(%ebp),%eax
  1010b8:	89 04 24             	mov    %eax,(%esp)
  1010bb:	e8 6b ff ff ff       	call   10102b <lpt_putc_sub>
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  1010c0:	eb 24                	jmp    1010e6 <lpt_putc+0x3d>
        lpt_putc_sub('\b');
  1010c2:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010c9:	e8 5d ff ff ff       	call   10102b <lpt_putc_sub>
        lpt_putc_sub(' ');
  1010ce:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1010d5:	e8 51 ff ff ff       	call   10102b <lpt_putc_sub>
        lpt_putc_sub('\b');
  1010da:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010e1:	e8 45 ff ff ff       	call   10102b <lpt_putc_sub>
}
  1010e6:	90                   	nop
  1010e7:	89 ec                	mov    %ebp,%esp
  1010e9:	5d                   	pop    %ebp
  1010ea:	c3                   	ret    

001010eb <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  1010eb:	55                   	push   %ebp
  1010ec:	89 e5                	mov    %esp,%ebp
  1010ee:	83 ec 38             	sub    $0x38,%esp
  1010f1:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    // set black on white
    if (!(c & ~0xFF)) {
  1010f4:	8b 45 08             	mov    0x8(%ebp),%eax
  1010f7:	25 00 ff ff ff       	and    $0xffffff00,%eax
  1010fc:	85 c0                	test   %eax,%eax
  1010fe:	75 07                	jne    101107 <cga_putc+0x1c>
        c |= 0x0700;
  101100:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  101107:	8b 45 08             	mov    0x8(%ebp),%eax
  10110a:	0f b6 c0             	movzbl %al,%eax
  10110d:	83 f8 0d             	cmp    $0xd,%eax
  101110:	74 72                	je     101184 <cga_putc+0x99>
  101112:	83 f8 0d             	cmp    $0xd,%eax
  101115:	0f 8f a3 00 00 00    	jg     1011be <cga_putc+0xd3>
  10111b:	83 f8 08             	cmp    $0x8,%eax
  10111e:	74 0a                	je     10112a <cga_putc+0x3f>
  101120:	83 f8 0a             	cmp    $0xa,%eax
  101123:	74 4c                	je     101171 <cga_putc+0x86>
  101125:	e9 94 00 00 00       	jmp    1011be <cga_putc+0xd3>
    case '\b':
        if (crt_pos > 0) {
  10112a:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  101131:	85 c0                	test   %eax,%eax
  101133:	0f 84 af 00 00 00    	je     1011e8 <cga_putc+0xfd>
            crt_pos --;
  101139:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  101140:	48                   	dec    %eax
  101141:	0f b7 c0             	movzwl %ax,%eax
  101144:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  10114a:	8b 45 08             	mov    0x8(%ebp),%eax
  10114d:	98                   	cwtl   
  10114e:	25 00 ff ff ff       	and    $0xffffff00,%eax
  101153:	98                   	cwtl   
  101154:	83 c8 20             	or     $0x20,%eax
  101157:	98                   	cwtl   
  101158:	8b 0d 60 fe 10 00    	mov    0x10fe60,%ecx
  10115e:	0f b7 15 64 fe 10 00 	movzwl 0x10fe64,%edx
  101165:	01 d2                	add    %edx,%edx
  101167:	01 ca                	add    %ecx,%edx
  101169:	0f b7 c0             	movzwl %ax,%eax
  10116c:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  10116f:	eb 77                	jmp    1011e8 <cga_putc+0xfd>
    case '\n':
        crt_pos += CRT_COLS;
  101171:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  101178:	83 c0 50             	add    $0x50,%eax
  10117b:	0f b7 c0             	movzwl %ax,%eax
  10117e:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  101184:	0f b7 1d 64 fe 10 00 	movzwl 0x10fe64,%ebx
  10118b:	0f b7 0d 64 fe 10 00 	movzwl 0x10fe64,%ecx
  101192:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
  101197:	89 c8                	mov    %ecx,%eax
  101199:	f7 e2                	mul    %edx
  10119b:	c1 ea 06             	shr    $0x6,%edx
  10119e:	89 d0                	mov    %edx,%eax
  1011a0:	c1 e0 02             	shl    $0x2,%eax
  1011a3:	01 d0                	add    %edx,%eax
  1011a5:	c1 e0 04             	shl    $0x4,%eax
  1011a8:	29 c1                	sub    %eax,%ecx
  1011aa:	89 ca                	mov    %ecx,%edx
  1011ac:	0f b7 d2             	movzwl %dx,%edx
  1011af:	89 d8                	mov    %ebx,%eax
  1011b1:	29 d0                	sub    %edx,%eax
  1011b3:	0f b7 c0             	movzwl %ax,%eax
  1011b6:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
        break;
  1011bc:	eb 2b                	jmp    1011e9 <cga_putc+0xfe>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  1011be:	8b 0d 60 fe 10 00    	mov    0x10fe60,%ecx
  1011c4:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  1011cb:	8d 50 01             	lea    0x1(%eax),%edx
  1011ce:	0f b7 d2             	movzwl %dx,%edx
  1011d1:	66 89 15 64 fe 10 00 	mov    %dx,0x10fe64
  1011d8:	01 c0                	add    %eax,%eax
  1011da:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  1011dd:	8b 45 08             	mov    0x8(%ebp),%eax
  1011e0:	0f b7 c0             	movzwl %ax,%eax
  1011e3:	66 89 02             	mov    %ax,(%edx)
        break;
  1011e6:	eb 01                	jmp    1011e9 <cga_putc+0xfe>
        break;
  1011e8:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  1011e9:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  1011f0:	3d cf 07 00 00       	cmp    $0x7cf,%eax
  1011f5:	76 5e                	jbe    101255 <cga_putc+0x16a>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  1011f7:	a1 60 fe 10 00       	mov    0x10fe60,%eax
  1011fc:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  101202:	a1 60 fe 10 00       	mov    0x10fe60,%eax
  101207:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  10120e:	00 
  10120f:	89 54 24 04          	mov    %edx,0x4(%esp)
  101213:	89 04 24             	mov    %eax,(%esp)
  101216:	e8 1c 23 00 00       	call   103537 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  10121b:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  101222:	eb 15                	jmp    101239 <cga_putc+0x14e>
            crt_buf[i] = 0x0700 | ' ';
  101224:	8b 15 60 fe 10 00    	mov    0x10fe60,%edx
  10122a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10122d:	01 c0                	add    %eax,%eax
  10122f:	01 d0                	add    %edx,%eax
  101231:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101236:	ff 45 f4             	incl   -0xc(%ebp)
  101239:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  101240:	7e e2                	jle    101224 <cga_putc+0x139>
        }
        crt_pos -= CRT_COLS;
  101242:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  101249:	83 e8 50             	sub    $0x50,%eax
  10124c:	0f b7 c0             	movzwl %ax,%eax
  10124f:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  101255:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  10125c:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  101260:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101264:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101268:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  10126c:	ee                   	out    %al,(%dx)
}
  10126d:	90                   	nop
    outb(addr_6845 + 1, crt_pos >> 8);
  10126e:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  101275:	c1 e8 08             	shr    $0x8,%eax
  101278:	0f b7 c0             	movzwl %ax,%eax
  10127b:	0f b6 c0             	movzbl %al,%eax
  10127e:	0f b7 15 66 fe 10 00 	movzwl 0x10fe66,%edx
  101285:	42                   	inc    %edx
  101286:	0f b7 d2             	movzwl %dx,%edx
  101289:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  10128d:	88 45 e9             	mov    %al,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101290:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101294:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101298:	ee                   	out    %al,(%dx)
}
  101299:	90                   	nop
    outb(addr_6845, 15);
  10129a:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  1012a1:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  1012a5:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1012a9:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1012ad:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1012b1:	ee                   	out    %al,(%dx)
}
  1012b2:	90                   	nop
    outb(addr_6845 + 1, crt_pos);
  1012b3:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  1012ba:	0f b6 c0             	movzbl %al,%eax
  1012bd:	0f b7 15 66 fe 10 00 	movzwl 0x10fe66,%edx
  1012c4:	42                   	inc    %edx
  1012c5:	0f b7 d2             	movzwl %dx,%edx
  1012c8:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  1012cc:	88 45 f1             	mov    %al,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1012cf:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1012d3:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1012d7:	ee                   	out    %al,(%dx)
}
  1012d8:	90                   	nop
}
  1012d9:	90                   	nop
  1012da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1012dd:	89 ec                	mov    %ebp,%esp
  1012df:	5d                   	pop    %ebp
  1012e0:	c3                   	ret    

001012e1 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  1012e1:	55                   	push   %ebp
  1012e2:	89 e5                	mov    %esp,%ebp
  1012e4:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012e7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1012ee:	eb 08                	jmp    1012f8 <serial_putc_sub+0x17>
        delay();
  1012f0:	e8 16 fb ff ff       	call   100e0b <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012f5:	ff 45 fc             	incl   -0x4(%ebp)
  1012f8:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1012fe:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101302:	89 c2                	mov    %eax,%edx
  101304:	ec                   	in     (%dx),%al
  101305:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101308:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10130c:	0f b6 c0             	movzbl %al,%eax
  10130f:	83 e0 20             	and    $0x20,%eax
  101312:	85 c0                	test   %eax,%eax
  101314:	75 09                	jne    10131f <serial_putc_sub+0x3e>
  101316:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  10131d:	7e d1                	jle    1012f0 <serial_putc_sub+0xf>
    }
    outb(COM1 + COM_TX, c);
  10131f:	8b 45 08             	mov    0x8(%ebp),%eax
  101322:	0f b6 c0             	movzbl %al,%eax
  101325:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  10132b:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10132e:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101332:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101336:	ee                   	out    %al,(%dx)
}
  101337:	90                   	nop
}
  101338:	90                   	nop
  101339:	89 ec                	mov    %ebp,%esp
  10133b:	5d                   	pop    %ebp
  10133c:	c3                   	ret    

0010133d <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  10133d:	55                   	push   %ebp
  10133e:	89 e5                	mov    %esp,%ebp
  101340:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  101343:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101347:	74 0d                	je     101356 <serial_putc+0x19>
        serial_putc_sub(c);
  101349:	8b 45 08             	mov    0x8(%ebp),%eax
  10134c:	89 04 24             	mov    %eax,(%esp)
  10134f:	e8 8d ff ff ff       	call   1012e1 <serial_putc_sub>
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  101354:	eb 24                	jmp    10137a <serial_putc+0x3d>
        serial_putc_sub('\b');
  101356:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10135d:	e8 7f ff ff ff       	call   1012e1 <serial_putc_sub>
        serial_putc_sub(' ');
  101362:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101369:	e8 73 ff ff ff       	call   1012e1 <serial_putc_sub>
        serial_putc_sub('\b');
  10136e:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101375:	e8 67 ff ff ff       	call   1012e1 <serial_putc_sub>
}
  10137a:	90                   	nop
  10137b:	89 ec                	mov    %ebp,%esp
  10137d:	5d                   	pop    %ebp
  10137e:	c3                   	ret    

0010137f <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  10137f:	55                   	push   %ebp
  101380:	89 e5                	mov    %esp,%ebp
  101382:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  101385:	eb 33                	jmp    1013ba <cons_intr+0x3b>
        if (c != 0) {
  101387:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10138b:	74 2d                	je     1013ba <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  10138d:	a1 84 00 11 00       	mov    0x110084,%eax
  101392:	8d 50 01             	lea    0x1(%eax),%edx
  101395:	89 15 84 00 11 00    	mov    %edx,0x110084
  10139b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10139e:	88 90 80 fe 10 00    	mov    %dl,0x10fe80(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  1013a4:	a1 84 00 11 00       	mov    0x110084,%eax
  1013a9:	3d 00 02 00 00       	cmp    $0x200,%eax
  1013ae:	75 0a                	jne    1013ba <cons_intr+0x3b>
                cons.wpos = 0;
  1013b0:	c7 05 84 00 11 00 00 	movl   $0x0,0x110084
  1013b7:	00 00 00 
    while ((c = (*proc)()) != -1) {
  1013ba:	8b 45 08             	mov    0x8(%ebp),%eax
  1013bd:	ff d0                	call   *%eax
  1013bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1013c2:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  1013c6:	75 bf                	jne    101387 <cons_intr+0x8>
            }
        }
    }
}
  1013c8:	90                   	nop
  1013c9:	90                   	nop
  1013ca:	89 ec                	mov    %ebp,%esp
  1013cc:	5d                   	pop    %ebp
  1013cd:	c3                   	ret    

001013ce <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  1013ce:	55                   	push   %ebp
  1013cf:	89 e5                	mov    %esp,%ebp
  1013d1:	83 ec 10             	sub    $0x10,%esp
  1013d4:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013da:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1013de:	89 c2                	mov    %eax,%edx
  1013e0:	ec                   	in     (%dx),%al
  1013e1:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1013e4:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  1013e8:	0f b6 c0             	movzbl %al,%eax
  1013eb:	83 e0 01             	and    $0x1,%eax
  1013ee:	85 c0                	test   %eax,%eax
  1013f0:	75 07                	jne    1013f9 <serial_proc_data+0x2b>
        return -1;
  1013f2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013f7:	eb 2a                	jmp    101423 <serial_proc_data+0x55>
  1013f9:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013ff:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  101403:	89 c2                	mov    %eax,%edx
  101405:	ec                   	in     (%dx),%al
  101406:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  101409:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  10140d:	0f b6 c0             	movzbl %al,%eax
  101410:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  101413:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  101417:	75 07                	jne    101420 <serial_proc_data+0x52>
        c = '\b';
  101419:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  101420:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  101423:	89 ec                	mov    %ebp,%esp
  101425:	5d                   	pop    %ebp
  101426:	c3                   	ret    

00101427 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  101427:	55                   	push   %ebp
  101428:	89 e5                	mov    %esp,%ebp
  10142a:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  10142d:	a1 68 fe 10 00       	mov    0x10fe68,%eax
  101432:	85 c0                	test   %eax,%eax
  101434:	74 0c                	je     101442 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  101436:	c7 04 24 ce 13 10 00 	movl   $0x1013ce,(%esp)
  10143d:	e8 3d ff ff ff       	call   10137f <cons_intr>
    }
}
  101442:	90                   	nop
  101443:	89 ec                	mov    %ebp,%esp
  101445:	5d                   	pop    %ebp
  101446:	c3                   	ret    

00101447 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  101447:	55                   	push   %ebp
  101448:	89 e5                	mov    %esp,%ebp
  10144a:	83 ec 38             	sub    $0x38,%esp
  10144d:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101453:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101456:	89 c2                	mov    %eax,%edx
  101458:	ec                   	in     (%dx),%al
  101459:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  10145c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  101460:	0f b6 c0             	movzbl %al,%eax
  101463:	83 e0 01             	and    $0x1,%eax
  101466:	85 c0                	test   %eax,%eax
  101468:	75 0a                	jne    101474 <kbd_proc_data+0x2d>
        return -1;
  10146a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10146f:	e9 56 01 00 00       	jmp    1015ca <kbd_proc_data+0x183>
  101474:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10147a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10147d:	89 c2                	mov    %eax,%edx
  10147f:	ec                   	in     (%dx),%al
  101480:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  101483:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  101487:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  10148a:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  10148e:	75 17                	jne    1014a7 <kbd_proc_data+0x60>
        // E0 escape character
        shift |= E0ESC;
  101490:	a1 88 00 11 00       	mov    0x110088,%eax
  101495:	83 c8 40             	or     $0x40,%eax
  101498:	a3 88 00 11 00       	mov    %eax,0x110088
        return 0;
  10149d:	b8 00 00 00 00       	mov    $0x0,%eax
  1014a2:	e9 23 01 00 00       	jmp    1015ca <kbd_proc_data+0x183>
    } else if (data & 0x80) {
  1014a7:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014ab:	84 c0                	test   %al,%al
  1014ad:	79 45                	jns    1014f4 <kbd_proc_data+0xad>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  1014af:	a1 88 00 11 00       	mov    0x110088,%eax
  1014b4:	83 e0 40             	and    $0x40,%eax
  1014b7:	85 c0                	test   %eax,%eax
  1014b9:	75 08                	jne    1014c3 <kbd_proc_data+0x7c>
  1014bb:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014bf:	24 7f                	and    $0x7f,%al
  1014c1:	eb 04                	jmp    1014c7 <kbd_proc_data+0x80>
  1014c3:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014c7:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  1014ca:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014ce:	0f b6 80 40 f0 10 00 	movzbl 0x10f040(%eax),%eax
  1014d5:	0c 40                	or     $0x40,%al
  1014d7:	0f b6 c0             	movzbl %al,%eax
  1014da:	f7 d0                	not    %eax
  1014dc:	89 c2                	mov    %eax,%edx
  1014de:	a1 88 00 11 00       	mov    0x110088,%eax
  1014e3:	21 d0                	and    %edx,%eax
  1014e5:	a3 88 00 11 00       	mov    %eax,0x110088
        return 0;
  1014ea:	b8 00 00 00 00       	mov    $0x0,%eax
  1014ef:	e9 d6 00 00 00       	jmp    1015ca <kbd_proc_data+0x183>
    } else if (shift & E0ESC) {
  1014f4:	a1 88 00 11 00       	mov    0x110088,%eax
  1014f9:	83 e0 40             	and    $0x40,%eax
  1014fc:	85 c0                	test   %eax,%eax
  1014fe:	74 11                	je     101511 <kbd_proc_data+0xca>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  101500:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  101504:	a1 88 00 11 00       	mov    0x110088,%eax
  101509:	83 e0 bf             	and    $0xffffffbf,%eax
  10150c:	a3 88 00 11 00       	mov    %eax,0x110088
    }

    shift |= shiftcode[data];
  101511:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101515:	0f b6 80 40 f0 10 00 	movzbl 0x10f040(%eax),%eax
  10151c:	0f b6 d0             	movzbl %al,%edx
  10151f:	a1 88 00 11 00       	mov    0x110088,%eax
  101524:	09 d0                	or     %edx,%eax
  101526:	a3 88 00 11 00       	mov    %eax,0x110088
    shift ^= togglecode[data];
  10152b:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10152f:	0f b6 80 40 f1 10 00 	movzbl 0x10f140(%eax),%eax
  101536:	0f b6 d0             	movzbl %al,%edx
  101539:	a1 88 00 11 00       	mov    0x110088,%eax
  10153e:	31 d0                	xor    %edx,%eax
  101540:	a3 88 00 11 00       	mov    %eax,0x110088

    c = charcode[shift & (CTL | SHIFT)][data];
  101545:	a1 88 00 11 00       	mov    0x110088,%eax
  10154a:	83 e0 03             	and    $0x3,%eax
  10154d:	8b 14 85 40 f5 10 00 	mov    0x10f540(,%eax,4),%edx
  101554:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101558:	01 d0                	add    %edx,%eax
  10155a:	0f b6 00             	movzbl (%eax),%eax
  10155d:	0f b6 c0             	movzbl %al,%eax
  101560:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  101563:	a1 88 00 11 00       	mov    0x110088,%eax
  101568:	83 e0 08             	and    $0x8,%eax
  10156b:	85 c0                	test   %eax,%eax
  10156d:	74 22                	je     101591 <kbd_proc_data+0x14a>
        if ('a' <= c && c <= 'z')
  10156f:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  101573:	7e 0c                	jle    101581 <kbd_proc_data+0x13a>
  101575:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  101579:	7f 06                	jg     101581 <kbd_proc_data+0x13a>
            c += 'A' - 'a';
  10157b:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  10157f:	eb 10                	jmp    101591 <kbd_proc_data+0x14a>
        else if ('A' <= c && c <= 'Z')
  101581:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  101585:	7e 0a                	jle    101591 <kbd_proc_data+0x14a>
  101587:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  10158b:	7f 04                	jg     101591 <kbd_proc_data+0x14a>
            c += 'a' - 'A';
  10158d:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  101591:	a1 88 00 11 00       	mov    0x110088,%eax
  101596:	f7 d0                	not    %eax
  101598:	83 e0 06             	and    $0x6,%eax
  10159b:	85 c0                	test   %eax,%eax
  10159d:	75 28                	jne    1015c7 <kbd_proc_data+0x180>
  10159f:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  1015a6:	75 1f                	jne    1015c7 <kbd_proc_data+0x180>
        cprintf("Rebooting!\n");
  1015a8:	c7 04 24 d3 39 10 00 	movl   $0x1039d3,(%esp)
  1015af:	e8 7c ed ff ff       	call   100330 <cprintf>
  1015b4:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  1015ba:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1015be:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  1015c2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  1015c5:	ee                   	out    %al,(%dx)
}
  1015c6:	90                   	nop
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  1015c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1015ca:	89 ec                	mov    %ebp,%esp
  1015cc:	5d                   	pop    %ebp
  1015cd:	c3                   	ret    

001015ce <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  1015ce:	55                   	push   %ebp
  1015cf:	89 e5                	mov    %esp,%ebp
  1015d1:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  1015d4:	c7 04 24 47 14 10 00 	movl   $0x101447,(%esp)
  1015db:	e8 9f fd ff ff       	call   10137f <cons_intr>
}
  1015e0:	90                   	nop
  1015e1:	89 ec                	mov    %ebp,%esp
  1015e3:	5d                   	pop    %ebp
  1015e4:	c3                   	ret    

001015e5 <kbd_init>:

static void
kbd_init(void) {
  1015e5:	55                   	push   %ebp
  1015e6:	89 e5                	mov    %esp,%ebp
  1015e8:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  1015eb:	e8 de ff ff ff       	call   1015ce <kbd_intr>
    pic_enable(IRQ_KBD);
  1015f0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1015f7:	e8 2b 01 00 00       	call   101727 <pic_enable>
}
  1015fc:	90                   	nop
  1015fd:	89 ec                	mov    %ebp,%esp
  1015ff:	5d                   	pop    %ebp
  101600:	c3                   	ret    

00101601 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  101601:	55                   	push   %ebp
  101602:	89 e5                	mov    %esp,%ebp
  101604:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  101607:	e8 4a f8 ff ff       	call   100e56 <cga_init>
    serial_init();
  10160c:	e8 2d f9 ff ff       	call   100f3e <serial_init>
    kbd_init();
  101611:	e8 cf ff ff ff       	call   1015e5 <kbd_init>
    if (!serial_exists) {
  101616:	a1 68 fe 10 00       	mov    0x10fe68,%eax
  10161b:	85 c0                	test   %eax,%eax
  10161d:	75 0c                	jne    10162b <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  10161f:	c7 04 24 df 39 10 00 	movl   $0x1039df,(%esp)
  101626:	e8 05 ed ff ff       	call   100330 <cprintf>
    }
}
  10162b:	90                   	nop
  10162c:	89 ec                	mov    %ebp,%esp
  10162e:	5d                   	pop    %ebp
  10162f:	c3                   	ret    

00101630 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  101630:	55                   	push   %ebp
  101631:	89 e5                	mov    %esp,%ebp
  101633:	83 ec 18             	sub    $0x18,%esp
    lpt_putc(c);
  101636:	8b 45 08             	mov    0x8(%ebp),%eax
  101639:	89 04 24             	mov    %eax,(%esp)
  10163c:	e8 68 fa ff ff       	call   1010a9 <lpt_putc>
    cga_putc(c);
  101641:	8b 45 08             	mov    0x8(%ebp),%eax
  101644:	89 04 24             	mov    %eax,(%esp)
  101647:	e8 9f fa ff ff       	call   1010eb <cga_putc>
    serial_putc(c);
  10164c:	8b 45 08             	mov    0x8(%ebp),%eax
  10164f:	89 04 24             	mov    %eax,(%esp)
  101652:	e8 e6 fc ff ff       	call   10133d <serial_putc>
}
  101657:	90                   	nop
  101658:	89 ec                	mov    %ebp,%esp
  10165a:	5d                   	pop    %ebp
  10165b:	c3                   	ret    

0010165c <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  10165c:	55                   	push   %ebp
  10165d:	89 e5                	mov    %esp,%ebp
  10165f:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  101662:	e8 c0 fd ff ff       	call   101427 <serial_intr>
    kbd_intr();
  101667:	e8 62 ff ff ff       	call   1015ce <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  10166c:	8b 15 80 00 11 00    	mov    0x110080,%edx
  101672:	a1 84 00 11 00       	mov    0x110084,%eax
  101677:	39 c2                	cmp    %eax,%edx
  101679:	74 36                	je     1016b1 <cons_getc+0x55>
        c = cons.buf[cons.rpos ++];
  10167b:	a1 80 00 11 00       	mov    0x110080,%eax
  101680:	8d 50 01             	lea    0x1(%eax),%edx
  101683:	89 15 80 00 11 00    	mov    %edx,0x110080
  101689:	0f b6 80 80 fe 10 00 	movzbl 0x10fe80(%eax),%eax
  101690:	0f b6 c0             	movzbl %al,%eax
  101693:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  101696:	a1 80 00 11 00       	mov    0x110080,%eax
  10169b:	3d 00 02 00 00       	cmp    $0x200,%eax
  1016a0:	75 0a                	jne    1016ac <cons_getc+0x50>
            cons.rpos = 0;
  1016a2:	c7 05 80 00 11 00 00 	movl   $0x0,0x110080
  1016a9:	00 00 00 
        }
        return c;
  1016ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1016af:	eb 05                	jmp    1016b6 <cons_getc+0x5a>
    }
    return 0;
  1016b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1016b6:	89 ec                	mov    %ebp,%esp
  1016b8:	5d                   	pop    %ebp
  1016b9:	c3                   	ret    

001016ba <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  1016ba:	55                   	push   %ebp
  1016bb:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  1016bd:	fb                   	sti    
}
  1016be:	90                   	nop
    sti();
}
  1016bf:	90                   	nop
  1016c0:	5d                   	pop    %ebp
  1016c1:	c3                   	ret    

001016c2 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  1016c2:	55                   	push   %ebp
  1016c3:	89 e5                	mov    %esp,%ebp

static inline void
cli(void) {
    asm volatile ("cli");
  1016c5:	fa                   	cli    
}
  1016c6:	90                   	nop
    cli();
}
  1016c7:	90                   	nop
  1016c8:	5d                   	pop    %ebp
  1016c9:	c3                   	ret    

001016ca <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  1016ca:	55                   	push   %ebp
  1016cb:	89 e5                	mov    %esp,%ebp
  1016cd:	83 ec 14             	sub    $0x14,%esp
  1016d0:	8b 45 08             	mov    0x8(%ebp),%eax
  1016d3:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  1016d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1016da:	66 a3 50 f5 10 00    	mov    %ax,0x10f550
    if (did_init) {
  1016e0:	a1 8c 00 11 00       	mov    0x11008c,%eax
  1016e5:	85 c0                	test   %eax,%eax
  1016e7:	74 39                	je     101722 <pic_setmask+0x58>
        outb(IO_PIC1 + 1, mask);
  1016e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1016ec:	0f b6 c0             	movzbl %al,%eax
  1016ef:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
  1016f5:	88 45 f9             	mov    %al,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1016f8:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1016fc:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101700:	ee                   	out    %al,(%dx)
}
  101701:	90                   	nop
        outb(IO_PIC2 + 1, mask >> 8);
  101702:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101706:	c1 e8 08             	shr    $0x8,%eax
  101709:	0f b7 c0             	movzwl %ax,%eax
  10170c:	0f b6 c0             	movzbl %al,%eax
  10170f:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
  101715:	88 45 fd             	mov    %al,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101718:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  10171c:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101720:	ee                   	out    %al,(%dx)
}
  101721:	90                   	nop
    }
}
  101722:	90                   	nop
  101723:	89 ec                	mov    %ebp,%esp
  101725:	5d                   	pop    %ebp
  101726:	c3                   	ret    

00101727 <pic_enable>:

void
pic_enable(unsigned int irq) {
  101727:	55                   	push   %ebp
  101728:	89 e5                	mov    %esp,%ebp
  10172a:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  10172d:	8b 45 08             	mov    0x8(%ebp),%eax
  101730:	ba 01 00 00 00       	mov    $0x1,%edx
  101735:	88 c1                	mov    %al,%cl
  101737:	d3 e2                	shl    %cl,%edx
  101739:	89 d0                	mov    %edx,%eax
  10173b:	98                   	cwtl   
  10173c:	f7 d0                	not    %eax
  10173e:	0f bf d0             	movswl %ax,%edx
  101741:	0f b7 05 50 f5 10 00 	movzwl 0x10f550,%eax
  101748:	98                   	cwtl   
  101749:	21 d0                	and    %edx,%eax
  10174b:	98                   	cwtl   
  10174c:	0f b7 c0             	movzwl %ax,%eax
  10174f:	89 04 24             	mov    %eax,(%esp)
  101752:	e8 73 ff ff ff       	call   1016ca <pic_setmask>
}
  101757:	90                   	nop
  101758:	89 ec                	mov    %ebp,%esp
  10175a:	5d                   	pop    %ebp
  10175b:	c3                   	ret    

0010175c <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  10175c:	55                   	push   %ebp
  10175d:	89 e5                	mov    %esp,%ebp
  10175f:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  101762:	c7 05 8c 00 11 00 01 	movl   $0x1,0x11008c
  101769:	00 00 00 
  10176c:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
  101772:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101776:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  10177a:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  10177e:	ee                   	out    %al,(%dx)
}
  10177f:	90                   	nop
  101780:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
  101786:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10178a:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  10178e:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  101792:	ee                   	out    %al,(%dx)
}
  101793:	90                   	nop
  101794:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  10179a:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10179e:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  1017a2:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  1017a6:	ee                   	out    %al,(%dx)
}
  1017a7:	90                   	nop
  1017a8:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
  1017ae:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017b2:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  1017b6:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  1017ba:	ee                   	out    %al,(%dx)
}
  1017bb:	90                   	nop
  1017bc:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
  1017c2:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017c6:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  1017ca:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  1017ce:	ee                   	out    %al,(%dx)
}
  1017cf:	90                   	nop
  1017d0:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
  1017d6:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017da:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  1017de:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  1017e2:	ee                   	out    %al,(%dx)
}
  1017e3:	90                   	nop
  1017e4:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
  1017ea:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017ee:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  1017f2:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  1017f6:	ee                   	out    %al,(%dx)
}
  1017f7:	90                   	nop
  1017f8:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
  1017fe:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101802:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101806:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  10180a:	ee                   	out    %al,(%dx)
}
  10180b:	90                   	nop
  10180c:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
  101812:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101816:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10181a:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10181e:	ee                   	out    %al,(%dx)
}
  10181f:	90                   	nop
  101820:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  101826:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10182a:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10182e:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101832:	ee                   	out    %al,(%dx)
}
  101833:	90                   	nop
  101834:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
  10183a:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10183e:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101842:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101846:	ee                   	out    %al,(%dx)
}
  101847:	90                   	nop
  101848:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  10184e:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101852:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101856:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10185a:	ee                   	out    %al,(%dx)
}
  10185b:	90                   	nop
  10185c:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
  101862:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101866:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10186a:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10186e:	ee                   	out    %al,(%dx)
}
  10186f:	90                   	nop
  101870:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
  101876:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10187a:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  10187e:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101882:	ee                   	out    %al,(%dx)
}
  101883:	90                   	nop
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  101884:	0f b7 05 50 f5 10 00 	movzwl 0x10f550,%eax
  10188b:	3d ff ff 00 00       	cmp    $0xffff,%eax
  101890:	74 0f                	je     1018a1 <pic_init+0x145>
        pic_setmask(irq_mask);
  101892:	0f b7 05 50 f5 10 00 	movzwl 0x10f550,%eax
  101899:	89 04 24             	mov    %eax,(%esp)
  10189c:	e8 29 fe ff ff       	call   1016ca <pic_setmask>
    }
}
  1018a1:	90                   	nop
  1018a2:	89 ec                	mov    %ebp,%esp
  1018a4:	5d                   	pop    %ebp
  1018a5:	c3                   	ret    

001018a6 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  1018a6:	55                   	push   %ebp
  1018a7:	89 e5                	mov    %esp,%ebp
  1018a9:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  1018ac:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  1018b3:	00 
  1018b4:	c7 04 24 00 3a 10 00 	movl   $0x103a00,(%esp)
  1018bb:	e8 70 ea ff ff       	call   100330 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
  1018c0:	c7 04 24 0a 3a 10 00 	movl   $0x103a0a,(%esp)
  1018c7:	e8 64 ea ff ff       	call   100330 <cprintf>
    panic("EOT: kernel seems ok.");
  1018cc:	c7 44 24 08 18 3a 10 	movl   $0x103a18,0x8(%esp)
  1018d3:	00 
  1018d4:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
  1018db:	00 
  1018dc:	c7 04 24 2e 3a 10 00 	movl   $0x103a2e,(%esp)
  1018e3:	e8 e9 f3 ff ff       	call   100cd1 <__panic>

001018e8 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  1018e8:	55                   	push   %ebp
  1018e9:	89 e5                	mov    %esp,%ebp
  1018eb:	83 ec 10             	sub    $0x10,%esp
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
     extern uintptr_t __vectors[];
     for(int i = 0; i < 256; i++){
  1018ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1018f5:	e9 c1 00 00 00       	jmp    1019bb <idt_init+0xd3>
        SETGATE(idt[i], 1, GD_KTEXT, __vectors[i], DPL_KERNEL);
  1018fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018fd:	8b 04 85 e0 f5 10 00 	mov    0x10f5e0(,%eax,4),%eax
  101904:	0f b7 d0             	movzwl %ax,%edx
  101907:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10190a:	66 89 14 c5 00 01 11 	mov    %dx,0x110100(,%eax,8)
  101911:	00 
  101912:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101915:	66 c7 04 c5 02 01 11 	movw   $0x8,0x110102(,%eax,8)
  10191c:	00 08 00 
  10191f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101922:	0f b6 14 c5 04 01 11 	movzbl 0x110104(,%eax,8),%edx
  101929:	00 
  10192a:	80 e2 e0             	and    $0xe0,%dl
  10192d:	88 14 c5 04 01 11 00 	mov    %dl,0x110104(,%eax,8)
  101934:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101937:	0f b6 14 c5 04 01 11 	movzbl 0x110104(,%eax,8),%edx
  10193e:	00 
  10193f:	80 e2 1f             	and    $0x1f,%dl
  101942:	88 14 c5 04 01 11 00 	mov    %dl,0x110104(,%eax,8)
  101949:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10194c:	0f b6 14 c5 05 01 11 	movzbl 0x110105(,%eax,8),%edx
  101953:	00 
  101954:	80 ca 0f             	or     $0xf,%dl
  101957:	88 14 c5 05 01 11 00 	mov    %dl,0x110105(,%eax,8)
  10195e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101961:	0f b6 14 c5 05 01 11 	movzbl 0x110105(,%eax,8),%edx
  101968:	00 
  101969:	80 e2 ef             	and    $0xef,%dl
  10196c:	88 14 c5 05 01 11 00 	mov    %dl,0x110105(,%eax,8)
  101973:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101976:	0f b6 14 c5 05 01 11 	movzbl 0x110105(,%eax,8),%edx
  10197d:	00 
  10197e:	80 e2 9f             	and    $0x9f,%dl
  101981:	88 14 c5 05 01 11 00 	mov    %dl,0x110105(,%eax,8)
  101988:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10198b:	0f b6 14 c5 05 01 11 	movzbl 0x110105(,%eax,8),%edx
  101992:	00 
  101993:	80 ca 80             	or     $0x80,%dl
  101996:	88 14 c5 05 01 11 00 	mov    %dl,0x110105(,%eax,8)
  10199d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019a0:	8b 04 85 e0 f5 10 00 	mov    0x10f5e0(,%eax,4),%eax
  1019a7:	c1 e8 10             	shr    $0x10,%eax
  1019aa:	0f b7 d0             	movzwl %ax,%edx
  1019ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019b0:	66 89 14 c5 06 01 11 	mov    %dx,0x110106(,%eax,8)
  1019b7:	00 
     for(int i = 0; i < 256; i++){
  1019b8:	ff 45 fc             	incl   -0x4(%ebp)
  1019bb:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
  1019c2:	0f 8e 32 ff ff ff    	jle    1018fa <idt_init+0x12>
     }
     SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
  1019c8:	a1 c4 f7 10 00       	mov    0x10f7c4,%eax
  1019cd:	0f b7 c0             	movzwl %ax,%eax
  1019d0:	66 a3 c8 04 11 00    	mov    %ax,0x1104c8
  1019d6:	66 c7 05 ca 04 11 00 	movw   $0x8,0x1104ca
  1019dd:	08 00 
  1019df:	0f b6 05 cc 04 11 00 	movzbl 0x1104cc,%eax
  1019e6:	24 e0                	and    $0xe0,%al
  1019e8:	a2 cc 04 11 00       	mov    %al,0x1104cc
  1019ed:	0f b6 05 cc 04 11 00 	movzbl 0x1104cc,%eax
  1019f4:	24 1f                	and    $0x1f,%al
  1019f6:	a2 cc 04 11 00       	mov    %al,0x1104cc
  1019fb:	0f b6 05 cd 04 11 00 	movzbl 0x1104cd,%eax
  101a02:	24 f0                	and    $0xf0,%al
  101a04:	0c 0e                	or     $0xe,%al
  101a06:	a2 cd 04 11 00       	mov    %al,0x1104cd
  101a0b:	0f b6 05 cd 04 11 00 	movzbl 0x1104cd,%eax
  101a12:	24 ef                	and    $0xef,%al
  101a14:	a2 cd 04 11 00       	mov    %al,0x1104cd
  101a19:	0f b6 05 cd 04 11 00 	movzbl 0x1104cd,%eax
  101a20:	0c 60                	or     $0x60,%al
  101a22:	a2 cd 04 11 00       	mov    %al,0x1104cd
  101a27:	0f b6 05 cd 04 11 00 	movzbl 0x1104cd,%eax
  101a2e:	0c 80                	or     $0x80,%al
  101a30:	a2 cd 04 11 00       	mov    %al,0x1104cd
  101a35:	a1 c4 f7 10 00       	mov    0x10f7c4,%eax
  101a3a:	c1 e8 10             	shr    $0x10,%eax
  101a3d:	0f b7 c0             	movzwl %ax,%eax
  101a40:	66 a3 ce 04 11 00    	mov    %ax,0x1104ce
  101a46:	c7 45 f8 60 f5 10 00 	movl   $0x10f560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd));
  101a4d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101a50:	0f 01 18             	lidtl  (%eax)
}
  101a53:	90                   	nop
     //SETGATE(idt[T_SWITCH_TOU], 0, GD_KTEXT, __vectors[T_SWITCH_TOU], DPL_KERNEL);
     lidt(&idt_pd);
}
  101a54:	90                   	nop
  101a55:	89 ec                	mov    %ebp,%esp
  101a57:	5d                   	pop    %ebp
  101a58:	c3                   	ret    

00101a59 <trapname>:

static const char *
trapname(int trapno) {
  101a59:	55                   	push   %ebp
  101a5a:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  101a5f:	83 f8 13             	cmp    $0x13,%eax
  101a62:	77 0c                	ja     101a70 <trapname+0x17>
        return excnames[trapno];
  101a64:	8b 45 08             	mov    0x8(%ebp),%eax
  101a67:	8b 04 85 80 3d 10 00 	mov    0x103d80(,%eax,4),%eax
  101a6e:	eb 18                	jmp    101a88 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101a70:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101a74:	7e 0d                	jle    101a83 <trapname+0x2a>
  101a76:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101a7a:	7f 07                	jg     101a83 <trapname+0x2a>
        return "Hardware Interrupt";
  101a7c:	b8 3f 3a 10 00       	mov    $0x103a3f,%eax
  101a81:	eb 05                	jmp    101a88 <trapname+0x2f>
    }
    return "(unknown trap)";
  101a83:	b8 52 3a 10 00       	mov    $0x103a52,%eax
}
  101a88:	5d                   	pop    %ebp
  101a89:	c3                   	ret    

00101a8a <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101a8a:	55                   	push   %ebp
  101a8b:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  101a90:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101a94:	83 f8 08             	cmp    $0x8,%eax
  101a97:	0f 94 c0             	sete   %al
  101a9a:	0f b6 c0             	movzbl %al,%eax
}
  101a9d:	5d                   	pop    %ebp
  101a9e:	c3                   	ret    

00101a9f <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101a9f:	55                   	push   %ebp
  101aa0:	89 e5                	mov    %esp,%ebp
  101aa2:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  101aa8:	89 44 24 04          	mov    %eax,0x4(%esp)
  101aac:	c7 04 24 93 3a 10 00 	movl   $0x103a93,(%esp)
  101ab3:	e8 78 e8 ff ff       	call   100330 <cprintf>
    print_regs(&tf->tf_regs);
  101ab8:	8b 45 08             	mov    0x8(%ebp),%eax
  101abb:	89 04 24             	mov    %eax,(%esp)
  101abe:	e8 8f 01 00 00       	call   101c52 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  101ac6:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101aca:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ace:	c7 04 24 a4 3a 10 00 	movl   $0x103aa4,(%esp)
  101ad5:	e8 56 e8 ff ff       	call   100330 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101ada:	8b 45 08             	mov    0x8(%ebp),%eax
  101add:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101ae1:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ae5:	c7 04 24 b7 3a 10 00 	movl   $0x103ab7,(%esp)
  101aec:	e8 3f e8 ff ff       	call   100330 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101af1:	8b 45 08             	mov    0x8(%ebp),%eax
  101af4:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101af8:	89 44 24 04          	mov    %eax,0x4(%esp)
  101afc:	c7 04 24 ca 3a 10 00 	movl   $0x103aca,(%esp)
  101b03:	e8 28 e8 ff ff       	call   100330 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101b08:	8b 45 08             	mov    0x8(%ebp),%eax
  101b0b:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101b0f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b13:	c7 04 24 dd 3a 10 00 	movl   $0x103add,(%esp)
  101b1a:	e8 11 e8 ff ff       	call   100330 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101b1f:	8b 45 08             	mov    0x8(%ebp),%eax
  101b22:	8b 40 30             	mov    0x30(%eax),%eax
  101b25:	89 04 24             	mov    %eax,(%esp)
  101b28:	e8 2c ff ff ff       	call   101a59 <trapname>
  101b2d:	8b 55 08             	mov    0x8(%ebp),%edx
  101b30:	8b 52 30             	mov    0x30(%edx),%edx
  101b33:	89 44 24 08          	mov    %eax,0x8(%esp)
  101b37:	89 54 24 04          	mov    %edx,0x4(%esp)
  101b3b:	c7 04 24 f0 3a 10 00 	movl   $0x103af0,(%esp)
  101b42:	e8 e9 e7 ff ff       	call   100330 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101b47:	8b 45 08             	mov    0x8(%ebp),%eax
  101b4a:	8b 40 34             	mov    0x34(%eax),%eax
  101b4d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b51:	c7 04 24 02 3b 10 00 	movl   $0x103b02,(%esp)
  101b58:	e8 d3 e7 ff ff       	call   100330 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  101b60:	8b 40 38             	mov    0x38(%eax),%eax
  101b63:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b67:	c7 04 24 11 3b 10 00 	movl   $0x103b11,(%esp)
  101b6e:	e8 bd e7 ff ff       	call   100330 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101b73:	8b 45 08             	mov    0x8(%ebp),%eax
  101b76:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b7a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b7e:	c7 04 24 20 3b 10 00 	movl   $0x103b20,(%esp)
  101b85:	e8 a6 e7 ff ff       	call   100330 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  101b8d:	8b 40 40             	mov    0x40(%eax),%eax
  101b90:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b94:	c7 04 24 33 3b 10 00 	movl   $0x103b33,(%esp)
  101b9b:	e8 90 e7 ff ff       	call   100330 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101ba0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101ba7:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101bae:	eb 3d                	jmp    101bed <print_trapframe+0x14e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  101bb3:	8b 50 40             	mov    0x40(%eax),%edx
  101bb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101bb9:	21 d0                	and    %edx,%eax
  101bbb:	85 c0                	test   %eax,%eax
  101bbd:	74 28                	je     101be7 <print_trapframe+0x148>
  101bbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101bc2:	8b 04 85 80 f5 10 00 	mov    0x10f580(,%eax,4),%eax
  101bc9:	85 c0                	test   %eax,%eax
  101bcb:	74 1a                	je     101be7 <print_trapframe+0x148>
            cprintf("%s,", IA32flags[i]);
  101bcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101bd0:	8b 04 85 80 f5 10 00 	mov    0x10f580(,%eax,4),%eax
  101bd7:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bdb:	c7 04 24 42 3b 10 00 	movl   $0x103b42,(%esp)
  101be2:	e8 49 e7 ff ff       	call   100330 <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101be7:	ff 45 f4             	incl   -0xc(%ebp)
  101bea:	d1 65 f0             	shll   -0x10(%ebp)
  101bed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101bf0:	83 f8 17             	cmp    $0x17,%eax
  101bf3:	76 bb                	jbe    101bb0 <print_trapframe+0x111>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  101bf8:	8b 40 40             	mov    0x40(%eax),%eax
  101bfb:	c1 e8 0c             	shr    $0xc,%eax
  101bfe:	83 e0 03             	and    $0x3,%eax
  101c01:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c05:	c7 04 24 46 3b 10 00 	movl   $0x103b46,(%esp)
  101c0c:	e8 1f e7 ff ff       	call   100330 <cprintf>

    if (!trap_in_kernel(tf)) {
  101c11:	8b 45 08             	mov    0x8(%ebp),%eax
  101c14:	89 04 24             	mov    %eax,(%esp)
  101c17:	e8 6e fe ff ff       	call   101a8a <trap_in_kernel>
  101c1c:	85 c0                	test   %eax,%eax
  101c1e:	75 2d                	jne    101c4d <print_trapframe+0x1ae>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101c20:	8b 45 08             	mov    0x8(%ebp),%eax
  101c23:	8b 40 44             	mov    0x44(%eax),%eax
  101c26:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c2a:	c7 04 24 4f 3b 10 00 	movl   $0x103b4f,(%esp)
  101c31:	e8 fa e6 ff ff       	call   100330 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101c36:	8b 45 08             	mov    0x8(%ebp),%eax
  101c39:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101c3d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c41:	c7 04 24 5e 3b 10 00 	movl   $0x103b5e,(%esp)
  101c48:	e8 e3 e6 ff ff       	call   100330 <cprintf>
    }
}
  101c4d:	90                   	nop
  101c4e:	89 ec                	mov    %ebp,%esp
  101c50:	5d                   	pop    %ebp
  101c51:	c3                   	ret    

00101c52 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101c52:	55                   	push   %ebp
  101c53:	89 e5                	mov    %esp,%ebp
  101c55:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101c58:	8b 45 08             	mov    0x8(%ebp),%eax
  101c5b:	8b 00                	mov    (%eax),%eax
  101c5d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c61:	c7 04 24 71 3b 10 00 	movl   $0x103b71,(%esp)
  101c68:	e8 c3 e6 ff ff       	call   100330 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  101c70:	8b 40 04             	mov    0x4(%eax),%eax
  101c73:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c77:	c7 04 24 80 3b 10 00 	movl   $0x103b80,(%esp)
  101c7e:	e8 ad e6 ff ff       	call   100330 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101c83:	8b 45 08             	mov    0x8(%ebp),%eax
  101c86:	8b 40 08             	mov    0x8(%eax),%eax
  101c89:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c8d:	c7 04 24 8f 3b 10 00 	movl   $0x103b8f,(%esp)
  101c94:	e8 97 e6 ff ff       	call   100330 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101c99:	8b 45 08             	mov    0x8(%ebp),%eax
  101c9c:	8b 40 0c             	mov    0xc(%eax),%eax
  101c9f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ca3:	c7 04 24 9e 3b 10 00 	movl   $0x103b9e,(%esp)
  101caa:	e8 81 e6 ff ff       	call   100330 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101caf:	8b 45 08             	mov    0x8(%ebp),%eax
  101cb2:	8b 40 10             	mov    0x10(%eax),%eax
  101cb5:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cb9:	c7 04 24 ad 3b 10 00 	movl   $0x103bad,(%esp)
  101cc0:	e8 6b e6 ff ff       	call   100330 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  101cc8:	8b 40 14             	mov    0x14(%eax),%eax
  101ccb:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ccf:	c7 04 24 bc 3b 10 00 	movl   $0x103bbc,(%esp)
  101cd6:	e8 55 e6 ff ff       	call   100330 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  101cde:	8b 40 18             	mov    0x18(%eax),%eax
  101ce1:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ce5:	c7 04 24 cb 3b 10 00 	movl   $0x103bcb,(%esp)
  101cec:	e8 3f e6 ff ff       	call   100330 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101cf1:	8b 45 08             	mov    0x8(%ebp),%eax
  101cf4:	8b 40 1c             	mov    0x1c(%eax),%eax
  101cf7:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cfb:	c7 04 24 da 3b 10 00 	movl   $0x103bda,(%esp)
  101d02:	e8 29 e6 ff ff       	call   100330 <cprintf>
}
  101d07:	90                   	nop
  101d08:	89 ec                	mov    %ebp,%esp
  101d0a:	5d                   	pop    %ebp
  101d0b:	c3                   	ret    

00101d0c <trap_dispatch>:
struct trapframe switchk2u, *switchu2k;
/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101d0c:	55                   	push   %ebp
  101d0d:	89 e5                	mov    %esp,%ebp
  101d0f:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
  101d12:	8b 45 08             	mov    0x8(%ebp),%eax
  101d15:	8b 40 30             	mov    0x30(%eax),%eax
  101d18:	83 f8 79             	cmp    $0x79,%eax
  101d1b:	0f 84 62 01 00 00    	je     101e83 <trap_dispatch+0x177>
  101d21:	83 f8 79             	cmp    $0x79,%eax
  101d24:	0f 87 02 02 00 00    	ja     101f2c <trap_dispatch+0x220>
  101d2a:	83 f8 78             	cmp    $0x78,%eax
  101d2d:	0f 84 d0 00 00 00    	je     101e03 <trap_dispatch+0xf7>
  101d33:	83 f8 78             	cmp    $0x78,%eax
  101d36:	0f 87 f0 01 00 00    	ja     101f2c <trap_dispatch+0x220>
  101d3c:	83 f8 2f             	cmp    $0x2f,%eax
  101d3f:	0f 87 e7 01 00 00    	ja     101f2c <trap_dispatch+0x220>
  101d45:	83 f8 2e             	cmp    $0x2e,%eax
  101d48:	0f 83 13 02 00 00    	jae    101f61 <trap_dispatch+0x255>
  101d4e:	83 f8 24             	cmp    $0x24,%eax
  101d51:	74 5e                	je     101db1 <trap_dispatch+0xa5>
  101d53:	83 f8 24             	cmp    $0x24,%eax
  101d56:	0f 87 d0 01 00 00    	ja     101f2c <trap_dispatch+0x220>
  101d5c:	83 f8 20             	cmp    $0x20,%eax
  101d5f:	74 0a                	je     101d6b <trap_dispatch+0x5f>
  101d61:	83 f8 21             	cmp    $0x21,%eax
  101d64:	74 74                	je     101dda <trap_dispatch+0xce>
  101d66:	e9 c1 01 00 00       	jmp    101f2c <trap_dispatch+0x220>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks++;
  101d6b:	a1 44 fe 10 00       	mov    0x10fe44,%eax
  101d70:	40                   	inc    %eax
  101d71:	a3 44 fe 10 00       	mov    %eax,0x10fe44
        if (ticks % TICK_NUM == 0){
  101d76:	8b 0d 44 fe 10 00    	mov    0x10fe44,%ecx
  101d7c:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101d81:	89 c8                	mov    %ecx,%eax
  101d83:	f7 e2                	mul    %edx
  101d85:	c1 ea 05             	shr    $0x5,%edx
  101d88:	89 d0                	mov    %edx,%eax
  101d8a:	c1 e0 02             	shl    $0x2,%eax
  101d8d:	01 d0                	add    %edx,%eax
  101d8f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  101d96:	01 d0                	add    %edx,%eax
  101d98:	c1 e0 02             	shl    $0x2,%eax
  101d9b:	29 c1                	sub    %eax,%ecx
  101d9d:	89 ca                	mov    %ecx,%edx
  101d9f:	85 d2                	test   %edx,%edx
  101da1:	0f 85 bd 01 00 00    	jne    101f64 <trap_dispatch+0x258>
            print_ticks();
  101da7:	e8 fa fa ff ff       	call   1018a6 <print_ticks>
        }
        break;
  101dac:	e9 b3 01 00 00       	jmp    101f64 <trap_dispatch+0x258>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101db1:	e8 a6 f8 ff ff       	call   10165c <cons_getc>
  101db6:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101db9:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101dbd:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101dc1:	89 54 24 08          	mov    %edx,0x8(%esp)
  101dc5:	89 44 24 04          	mov    %eax,0x4(%esp)
  101dc9:	c7 04 24 e9 3b 10 00 	movl   $0x103be9,(%esp)
  101dd0:	e8 5b e5 ff ff       	call   100330 <cprintf>
        break;
  101dd5:	e9 91 01 00 00       	jmp    101f6b <trap_dispatch+0x25f>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101dda:	e8 7d f8 ff ff       	call   10165c <cons_getc>
  101ddf:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101de2:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101de6:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101dea:	89 54 24 08          	mov    %edx,0x8(%esp)
  101dee:	89 44 24 04          	mov    %eax,0x4(%esp)
  101df2:	c7 04 24 fb 3b 10 00 	movl   $0x103bfb,(%esp)
  101df9:	e8 32 e5 ff ff       	call   100330 <cprintf>
        break;
  101dfe:	e9 68 01 00 00       	jmp    101f6b <trap_dispatch+0x25f>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.

    case T_SWITCH_TOU:
        if((tf->tf_cs & 3) == 0){
  101e03:	8b 45 08             	mov    0x8(%ebp),%eax
  101e06:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101e0a:	83 e0 03             	and    $0x3,%eax
  101e0d:	85 c0                	test   %eax,%eax
  101e0f:	0f 85 52 01 00 00    	jne    101f67 <trap_dispatch+0x25b>
            tf->tf_cs = USER_CS;
  101e15:	8b 45 08             	mov    0x8(%ebp),%eax
  101e18:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
            tf->tf_ss = tf->tf_ds = tf->tf_es = tf->tf_gs = tf->tf_fs = USER_DS;
  101e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  101e21:	66 c7 40 24 23 00    	movw   $0x23,0x24(%eax)
  101e27:	8b 45 08             	mov    0x8(%ebp),%eax
  101e2a:	0f b7 50 24          	movzwl 0x24(%eax),%edx
  101e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  101e31:	66 89 50 20          	mov    %dx,0x20(%eax)
  101e35:	8b 45 08             	mov    0x8(%ebp),%eax
  101e38:	0f b7 50 20          	movzwl 0x20(%eax),%edx
  101e3c:	8b 45 08             	mov    0x8(%ebp),%eax
  101e3f:	66 89 50 28          	mov    %dx,0x28(%eax)
  101e43:	8b 45 08             	mov    0x8(%ebp),%eax
  101e46:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  101e4d:	66 89 50 2c          	mov    %dx,0x2c(%eax)
  101e51:	8b 45 08             	mov    0x8(%ebp),%eax
  101e54:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
  101e58:	8b 45 08             	mov    0x8(%ebp),%eax
  101e5b:	66 89 50 48          	mov    %dx,0x48(%eax)
            tf->tf_esp = (uint32_t)tf + sizeof(struct trapframe);
  101e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  101e62:	8d 50 4c             	lea    0x4c(%eax),%edx
  101e65:	8b 45 08             	mov    0x8(%ebp),%eax
  101e68:	89 50 44             	mov    %edx,0x44(%eax)
            tf->tf_eflags |= FL_IOPL_MASK;
  101e6b:	8b 45 08             	mov    0x8(%ebp),%eax
  101e6e:	8b 40 40             	mov    0x40(%eax),%eax
  101e71:	0d 00 30 00 00       	or     $0x3000,%eax
  101e76:	89 c2                	mov    %eax,%edx
  101e78:	8b 45 08             	mov    0x8(%ebp),%eax
  101e7b:	89 50 40             	mov    %edx,0x40(%eax)
        }
        break;
  101e7e:	e9 e4 00 00 00       	jmp    101f67 <trap_dispatch+0x25b>
    case T_SWITCH_TOK:
        if((tf->tf_cs & 3) != 0){
  101e83:	8b 45 08             	mov    0x8(%ebp),%eax
  101e86:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101e8a:	83 e0 03             	and    $0x3,%eax
  101e8d:	85 c0                	test   %eax,%eax
  101e8f:	0f 84 d5 00 00 00    	je     101f6a <trap_dispatch+0x25e>
            tf->tf_cs = KERNEL_CS;
  101e95:	8b 45 08             	mov    0x8(%ebp),%eax
  101e98:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
            tf->tf_ss = tf->tf_ds = tf->tf_es = tf->tf_gs = tf->tf_fs = KERNEL_DS;
  101e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  101ea1:	66 c7 40 24 10 00    	movw   $0x10,0x24(%eax)
  101ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  101eaa:	0f b7 50 24          	movzwl 0x24(%eax),%edx
  101eae:	8b 45 08             	mov    0x8(%ebp),%eax
  101eb1:	66 89 50 20          	mov    %dx,0x20(%eax)
  101eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  101eb8:	0f b7 50 20          	movzwl 0x20(%eax),%edx
  101ebc:	8b 45 08             	mov    0x8(%ebp),%eax
  101ebf:	66 89 50 28          	mov    %dx,0x28(%eax)
  101ec3:	8b 45 08             	mov    0x8(%ebp),%eax
  101ec6:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101eca:	8b 45 08             	mov    0x8(%ebp),%eax
  101ecd:	66 89 50 2c          	mov    %dx,0x2c(%eax)
  101ed1:	8b 45 08             	mov    0x8(%ebp),%eax
  101ed4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
  101ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  101edb:	66 89 50 48          	mov    %dx,0x48(%eax)
            tf->tf_eflags &= ~FL_IOPL_MASK;
  101edf:	8b 45 08             	mov    0x8(%ebp),%eax
  101ee2:	8b 40 40             	mov    0x40(%eax),%eax
  101ee5:	25 ff cf ff ff       	and    $0xffffcfff,%eax
  101eea:	89 c2                	mov    %eax,%edx
  101eec:	8b 45 08             	mov    0x8(%ebp),%eax
  101eef:	89 50 40             	mov    %edx,0x40(%eax)
            switchu2k = (struct trapframe *)(tf->tf_esp - (sizeof(struct trapframe) - 8));
  101ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  101ef5:	8b 40 44             	mov    0x44(%eax),%eax
  101ef8:	83 e8 44             	sub    $0x44,%eax
  101efb:	a3 ec 00 11 00       	mov    %eax,0x1100ec
            memmove(switchu2k, tf, sizeof(struct trapframe) - 8);
  101f00:	a1 ec 00 11 00       	mov    0x1100ec,%eax
  101f05:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  101f0c:	00 
  101f0d:	8b 55 08             	mov    0x8(%ebp),%edx
  101f10:	89 54 24 04          	mov    %edx,0x4(%esp)
  101f14:	89 04 24             	mov    %eax,(%esp)
  101f17:	e8 1b 16 00 00       	call   103537 <memmove>
            *((uint32_t *)tf - 1) = (uint32_t)switchu2k;
  101f1c:	8b 15 ec 00 11 00    	mov    0x1100ec,%edx
  101f22:	8b 45 08             	mov    0x8(%ebp),%eax
  101f25:	83 e8 04             	sub    $0x4,%eax
  101f28:	89 10                	mov    %edx,(%eax)
        }
        break;
  101f2a:	eb 3e                	jmp    101f6a <trap_dispatch+0x25e>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  101f2f:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101f33:	83 e0 03             	and    $0x3,%eax
  101f36:	85 c0                	test   %eax,%eax
  101f38:	75 31                	jne    101f6b <trap_dispatch+0x25f>
            print_trapframe(tf);
  101f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  101f3d:	89 04 24             	mov    %eax,(%esp)
  101f40:	e8 5a fb ff ff       	call   101a9f <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101f45:	c7 44 24 08 0a 3c 10 	movl   $0x103c0a,0x8(%esp)
  101f4c:	00 
  101f4d:	c7 44 24 04 c6 00 00 	movl   $0xc6,0x4(%esp)
  101f54:	00 
  101f55:	c7 04 24 2e 3a 10 00 	movl   $0x103a2e,(%esp)
  101f5c:	e8 70 ed ff ff       	call   100cd1 <__panic>
        break;
  101f61:	90                   	nop
  101f62:	eb 07                	jmp    101f6b <trap_dispatch+0x25f>
        break;
  101f64:	90                   	nop
  101f65:	eb 04                	jmp    101f6b <trap_dispatch+0x25f>
        break;
  101f67:	90                   	nop
  101f68:	eb 01                	jmp    101f6b <trap_dispatch+0x25f>
        break;
  101f6a:	90                   	nop
        }
    }
}
  101f6b:	90                   	nop
  101f6c:	89 ec                	mov    %ebp,%esp
  101f6e:	5d                   	pop    %ebp
  101f6f:	c3                   	ret    

00101f70 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101f70:	55                   	push   %ebp
  101f71:	89 e5                	mov    %esp,%ebp
  101f73:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101f76:	8b 45 08             	mov    0x8(%ebp),%eax
  101f79:	89 04 24             	mov    %eax,(%esp)
  101f7c:	e8 8b fd ff ff       	call   101d0c <trap_dispatch>
}
  101f81:	90                   	nop
  101f82:	89 ec                	mov    %ebp,%esp
  101f84:	5d                   	pop    %ebp
  101f85:	c3                   	ret    

00101f86 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101f86:	1e                   	push   %ds
    pushl %es
  101f87:	06                   	push   %es
    pushl %fs
  101f88:	0f a0                	push   %fs
    pushl %gs
  101f8a:	0f a8                	push   %gs
    pushal
  101f8c:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101f8d:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101f92:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101f94:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101f96:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101f97:	e8 d4 ff ff ff       	call   101f70 <trap>

    # pop the pushed stack pointer
    popl %esp
  101f9c:	5c                   	pop    %esp

00101f9d <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101f9d:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  101f9e:	0f a9                	pop    %gs
    popl %fs
  101fa0:	0f a1                	pop    %fs
    popl %es
  101fa2:	07                   	pop    %es
    popl %ds
  101fa3:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101fa4:	83 c4 08             	add    $0x8,%esp
    iret
  101fa7:	cf                   	iret   

00101fa8 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101fa8:	6a 00                	push   $0x0
  pushl $0
  101faa:	6a 00                	push   $0x0
  jmp __alltraps
  101fac:	e9 d5 ff ff ff       	jmp    101f86 <__alltraps>

00101fb1 <vector1>:
.globl vector1
vector1:
  pushl $0
  101fb1:	6a 00                	push   $0x0
  pushl $1
  101fb3:	6a 01                	push   $0x1
  jmp __alltraps
  101fb5:	e9 cc ff ff ff       	jmp    101f86 <__alltraps>

00101fba <vector2>:
.globl vector2
vector2:
  pushl $0
  101fba:	6a 00                	push   $0x0
  pushl $2
  101fbc:	6a 02                	push   $0x2
  jmp __alltraps
  101fbe:	e9 c3 ff ff ff       	jmp    101f86 <__alltraps>

00101fc3 <vector3>:
.globl vector3
vector3:
  pushl $0
  101fc3:	6a 00                	push   $0x0
  pushl $3
  101fc5:	6a 03                	push   $0x3
  jmp __alltraps
  101fc7:	e9 ba ff ff ff       	jmp    101f86 <__alltraps>

00101fcc <vector4>:
.globl vector4
vector4:
  pushl $0
  101fcc:	6a 00                	push   $0x0
  pushl $4
  101fce:	6a 04                	push   $0x4
  jmp __alltraps
  101fd0:	e9 b1 ff ff ff       	jmp    101f86 <__alltraps>

00101fd5 <vector5>:
.globl vector5
vector5:
  pushl $0
  101fd5:	6a 00                	push   $0x0
  pushl $5
  101fd7:	6a 05                	push   $0x5
  jmp __alltraps
  101fd9:	e9 a8 ff ff ff       	jmp    101f86 <__alltraps>

00101fde <vector6>:
.globl vector6
vector6:
  pushl $0
  101fde:	6a 00                	push   $0x0
  pushl $6
  101fe0:	6a 06                	push   $0x6
  jmp __alltraps
  101fe2:	e9 9f ff ff ff       	jmp    101f86 <__alltraps>

00101fe7 <vector7>:
.globl vector7
vector7:
  pushl $0
  101fe7:	6a 00                	push   $0x0
  pushl $7
  101fe9:	6a 07                	push   $0x7
  jmp __alltraps
  101feb:	e9 96 ff ff ff       	jmp    101f86 <__alltraps>

00101ff0 <vector8>:
.globl vector8
vector8:
  pushl $8
  101ff0:	6a 08                	push   $0x8
  jmp __alltraps
  101ff2:	e9 8f ff ff ff       	jmp    101f86 <__alltraps>

00101ff7 <vector9>:
.globl vector9
vector9:
  pushl $0
  101ff7:	6a 00                	push   $0x0
  pushl $9
  101ff9:	6a 09                	push   $0x9
  jmp __alltraps
  101ffb:	e9 86 ff ff ff       	jmp    101f86 <__alltraps>

00102000 <vector10>:
.globl vector10
vector10:
  pushl $10
  102000:	6a 0a                	push   $0xa
  jmp __alltraps
  102002:	e9 7f ff ff ff       	jmp    101f86 <__alltraps>

00102007 <vector11>:
.globl vector11
vector11:
  pushl $11
  102007:	6a 0b                	push   $0xb
  jmp __alltraps
  102009:	e9 78 ff ff ff       	jmp    101f86 <__alltraps>

0010200e <vector12>:
.globl vector12
vector12:
  pushl $12
  10200e:	6a 0c                	push   $0xc
  jmp __alltraps
  102010:	e9 71 ff ff ff       	jmp    101f86 <__alltraps>

00102015 <vector13>:
.globl vector13
vector13:
  pushl $13
  102015:	6a 0d                	push   $0xd
  jmp __alltraps
  102017:	e9 6a ff ff ff       	jmp    101f86 <__alltraps>

0010201c <vector14>:
.globl vector14
vector14:
  pushl $14
  10201c:	6a 0e                	push   $0xe
  jmp __alltraps
  10201e:	e9 63 ff ff ff       	jmp    101f86 <__alltraps>

00102023 <vector15>:
.globl vector15
vector15:
  pushl $0
  102023:	6a 00                	push   $0x0
  pushl $15
  102025:	6a 0f                	push   $0xf
  jmp __alltraps
  102027:	e9 5a ff ff ff       	jmp    101f86 <__alltraps>

0010202c <vector16>:
.globl vector16
vector16:
  pushl $0
  10202c:	6a 00                	push   $0x0
  pushl $16
  10202e:	6a 10                	push   $0x10
  jmp __alltraps
  102030:	e9 51 ff ff ff       	jmp    101f86 <__alltraps>

00102035 <vector17>:
.globl vector17
vector17:
  pushl $17
  102035:	6a 11                	push   $0x11
  jmp __alltraps
  102037:	e9 4a ff ff ff       	jmp    101f86 <__alltraps>

0010203c <vector18>:
.globl vector18
vector18:
  pushl $0
  10203c:	6a 00                	push   $0x0
  pushl $18
  10203e:	6a 12                	push   $0x12
  jmp __alltraps
  102040:	e9 41 ff ff ff       	jmp    101f86 <__alltraps>

00102045 <vector19>:
.globl vector19
vector19:
  pushl $0
  102045:	6a 00                	push   $0x0
  pushl $19
  102047:	6a 13                	push   $0x13
  jmp __alltraps
  102049:	e9 38 ff ff ff       	jmp    101f86 <__alltraps>

0010204e <vector20>:
.globl vector20
vector20:
  pushl $0
  10204e:	6a 00                	push   $0x0
  pushl $20
  102050:	6a 14                	push   $0x14
  jmp __alltraps
  102052:	e9 2f ff ff ff       	jmp    101f86 <__alltraps>

00102057 <vector21>:
.globl vector21
vector21:
  pushl $0
  102057:	6a 00                	push   $0x0
  pushl $21
  102059:	6a 15                	push   $0x15
  jmp __alltraps
  10205b:	e9 26 ff ff ff       	jmp    101f86 <__alltraps>

00102060 <vector22>:
.globl vector22
vector22:
  pushl $0
  102060:	6a 00                	push   $0x0
  pushl $22
  102062:	6a 16                	push   $0x16
  jmp __alltraps
  102064:	e9 1d ff ff ff       	jmp    101f86 <__alltraps>

00102069 <vector23>:
.globl vector23
vector23:
  pushl $0
  102069:	6a 00                	push   $0x0
  pushl $23
  10206b:	6a 17                	push   $0x17
  jmp __alltraps
  10206d:	e9 14 ff ff ff       	jmp    101f86 <__alltraps>

00102072 <vector24>:
.globl vector24
vector24:
  pushl $0
  102072:	6a 00                	push   $0x0
  pushl $24
  102074:	6a 18                	push   $0x18
  jmp __alltraps
  102076:	e9 0b ff ff ff       	jmp    101f86 <__alltraps>

0010207b <vector25>:
.globl vector25
vector25:
  pushl $0
  10207b:	6a 00                	push   $0x0
  pushl $25
  10207d:	6a 19                	push   $0x19
  jmp __alltraps
  10207f:	e9 02 ff ff ff       	jmp    101f86 <__alltraps>

00102084 <vector26>:
.globl vector26
vector26:
  pushl $0
  102084:	6a 00                	push   $0x0
  pushl $26
  102086:	6a 1a                	push   $0x1a
  jmp __alltraps
  102088:	e9 f9 fe ff ff       	jmp    101f86 <__alltraps>

0010208d <vector27>:
.globl vector27
vector27:
  pushl $0
  10208d:	6a 00                	push   $0x0
  pushl $27
  10208f:	6a 1b                	push   $0x1b
  jmp __alltraps
  102091:	e9 f0 fe ff ff       	jmp    101f86 <__alltraps>

00102096 <vector28>:
.globl vector28
vector28:
  pushl $0
  102096:	6a 00                	push   $0x0
  pushl $28
  102098:	6a 1c                	push   $0x1c
  jmp __alltraps
  10209a:	e9 e7 fe ff ff       	jmp    101f86 <__alltraps>

0010209f <vector29>:
.globl vector29
vector29:
  pushl $0
  10209f:	6a 00                	push   $0x0
  pushl $29
  1020a1:	6a 1d                	push   $0x1d
  jmp __alltraps
  1020a3:	e9 de fe ff ff       	jmp    101f86 <__alltraps>

001020a8 <vector30>:
.globl vector30
vector30:
  pushl $0
  1020a8:	6a 00                	push   $0x0
  pushl $30
  1020aa:	6a 1e                	push   $0x1e
  jmp __alltraps
  1020ac:	e9 d5 fe ff ff       	jmp    101f86 <__alltraps>

001020b1 <vector31>:
.globl vector31
vector31:
  pushl $0
  1020b1:	6a 00                	push   $0x0
  pushl $31
  1020b3:	6a 1f                	push   $0x1f
  jmp __alltraps
  1020b5:	e9 cc fe ff ff       	jmp    101f86 <__alltraps>

001020ba <vector32>:
.globl vector32
vector32:
  pushl $0
  1020ba:	6a 00                	push   $0x0
  pushl $32
  1020bc:	6a 20                	push   $0x20
  jmp __alltraps
  1020be:	e9 c3 fe ff ff       	jmp    101f86 <__alltraps>

001020c3 <vector33>:
.globl vector33
vector33:
  pushl $0
  1020c3:	6a 00                	push   $0x0
  pushl $33
  1020c5:	6a 21                	push   $0x21
  jmp __alltraps
  1020c7:	e9 ba fe ff ff       	jmp    101f86 <__alltraps>

001020cc <vector34>:
.globl vector34
vector34:
  pushl $0
  1020cc:	6a 00                	push   $0x0
  pushl $34
  1020ce:	6a 22                	push   $0x22
  jmp __alltraps
  1020d0:	e9 b1 fe ff ff       	jmp    101f86 <__alltraps>

001020d5 <vector35>:
.globl vector35
vector35:
  pushl $0
  1020d5:	6a 00                	push   $0x0
  pushl $35
  1020d7:	6a 23                	push   $0x23
  jmp __alltraps
  1020d9:	e9 a8 fe ff ff       	jmp    101f86 <__alltraps>

001020de <vector36>:
.globl vector36
vector36:
  pushl $0
  1020de:	6a 00                	push   $0x0
  pushl $36
  1020e0:	6a 24                	push   $0x24
  jmp __alltraps
  1020e2:	e9 9f fe ff ff       	jmp    101f86 <__alltraps>

001020e7 <vector37>:
.globl vector37
vector37:
  pushl $0
  1020e7:	6a 00                	push   $0x0
  pushl $37
  1020e9:	6a 25                	push   $0x25
  jmp __alltraps
  1020eb:	e9 96 fe ff ff       	jmp    101f86 <__alltraps>

001020f0 <vector38>:
.globl vector38
vector38:
  pushl $0
  1020f0:	6a 00                	push   $0x0
  pushl $38
  1020f2:	6a 26                	push   $0x26
  jmp __alltraps
  1020f4:	e9 8d fe ff ff       	jmp    101f86 <__alltraps>

001020f9 <vector39>:
.globl vector39
vector39:
  pushl $0
  1020f9:	6a 00                	push   $0x0
  pushl $39
  1020fb:	6a 27                	push   $0x27
  jmp __alltraps
  1020fd:	e9 84 fe ff ff       	jmp    101f86 <__alltraps>

00102102 <vector40>:
.globl vector40
vector40:
  pushl $0
  102102:	6a 00                	push   $0x0
  pushl $40
  102104:	6a 28                	push   $0x28
  jmp __alltraps
  102106:	e9 7b fe ff ff       	jmp    101f86 <__alltraps>

0010210b <vector41>:
.globl vector41
vector41:
  pushl $0
  10210b:	6a 00                	push   $0x0
  pushl $41
  10210d:	6a 29                	push   $0x29
  jmp __alltraps
  10210f:	e9 72 fe ff ff       	jmp    101f86 <__alltraps>

00102114 <vector42>:
.globl vector42
vector42:
  pushl $0
  102114:	6a 00                	push   $0x0
  pushl $42
  102116:	6a 2a                	push   $0x2a
  jmp __alltraps
  102118:	e9 69 fe ff ff       	jmp    101f86 <__alltraps>

0010211d <vector43>:
.globl vector43
vector43:
  pushl $0
  10211d:	6a 00                	push   $0x0
  pushl $43
  10211f:	6a 2b                	push   $0x2b
  jmp __alltraps
  102121:	e9 60 fe ff ff       	jmp    101f86 <__alltraps>

00102126 <vector44>:
.globl vector44
vector44:
  pushl $0
  102126:	6a 00                	push   $0x0
  pushl $44
  102128:	6a 2c                	push   $0x2c
  jmp __alltraps
  10212a:	e9 57 fe ff ff       	jmp    101f86 <__alltraps>

0010212f <vector45>:
.globl vector45
vector45:
  pushl $0
  10212f:	6a 00                	push   $0x0
  pushl $45
  102131:	6a 2d                	push   $0x2d
  jmp __alltraps
  102133:	e9 4e fe ff ff       	jmp    101f86 <__alltraps>

00102138 <vector46>:
.globl vector46
vector46:
  pushl $0
  102138:	6a 00                	push   $0x0
  pushl $46
  10213a:	6a 2e                	push   $0x2e
  jmp __alltraps
  10213c:	e9 45 fe ff ff       	jmp    101f86 <__alltraps>

00102141 <vector47>:
.globl vector47
vector47:
  pushl $0
  102141:	6a 00                	push   $0x0
  pushl $47
  102143:	6a 2f                	push   $0x2f
  jmp __alltraps
  102145:	e9 3c fe ff ff       	jmp    101f86 <__alltraps>

0010214a <vector48>:
.globl vector48
vector48:
  pushl $0
  10214a:	6a 00                	push   $0x0
  pushl $48
  10214c:	6a 30                	push   $0x30
  jmp __alltraps
  10214e:	e9 33 fe ff ff       	jmp    101f86 <__alltraps>

00102153 <vector49>:
.globl vector49
vector49:
  pushl $0
  102153:	6a 00                	push   $0x0
  pushl $49
  102155:	6a 31                	push   $0x31
  jmp __alltraps
  102157:	e9 2a fe ff ff       	jmp    101f86 <__alltraps>

0010215c <vector50>:
.globl vector50
vector50:
  pushl $0
  10215c:	6a 00                	push   $0x0
  pushl $50
  10215e:	6a 32                	push   $0x32
  jmp __alltraps
  102160:	e9 21 fe ff ff       	jmp    101f86 <__alltraps>

00102165 <vector51>:
.globl vector51
vector51:
  pushl $0
  102165:	6a 00                	push   $0x0
  pushl $51
  102167:	6a 33                	push   $0x33
  jmp __alltraps
  102169:	e9 18 fe ff ff       	jmp    101f86 <__alltraps>

0010216e <vector52>:
.globl vector52
vector52:
  pushl $0
  10216e:	6a 00                	push   $0x0
  pushl $52
  102170:	6a 34                	push   $0x34
  jmp __alltraps
  102172:	e9 0f fe ff ff       	jmp    101f86 <__alltraps>

00102177 <vector53>:
.globl vector53
vector53:
  pushl $0
  102177:	6a 00                	push   $0x0
  pushl $53
  102179:	6a 35                	push   $0x35
  jmp __alltraps
  10217b:	e9 06 fe ff ff       	jmp    101f86 <__alltraps>

00102180 <vector54>:
.globl vector54
vector54:
  pushl $0
  102180:	6a 00                	push   $0x0
  pushl $54
  102182:	6a 36                	push   $0x36
  jmp __alltraps
  102184:	e9 fd fd ff ff       	jmp    101f86 <__alltraps>

00102189 <vector55>:
.globl vector55
vector55:
  pushl $0
  102189:	6a 00                	push   $0x0
  pushl $55
  10218b:	6a 37                	push   $0x37
  jmp __alltraps
  10218d:	e9 f4 fd ff ff       	jmp    101f86 <__alltraps>

00102192 <vector56>:
.globl vector56
vector56:
  pushl $0
  102192:	6a 00                	push   $0x0
  pushl $56
  102194:	6a 38                	push   $0x38
  jmp __alltraps
  102196:	e9 eb fd ff ff       	jmp    101f86 <__alltraps>

0010219b <vector57>:
.globl vector57
vector57:
  pushl $0
  10219b:	6a 00                	push   $0x0
  pushl $57
  10219d:	6a 39                	push   $0x39
  jmp __alltraps
  10219f:	e9 e2 fd ff ff       	jmp    101f86 <__alltraps>

001021a4 <vector58>:
.globl vector58
vector58:
  pushl $0
  1021a4:	6a 00                	push   $0x0
  pushl $58
  1021a6:	6a 3a                	push   $0x3a
  jmp __alltraps
  1021a8:	e9 d9 fd ff ff       	jmp    101f86 <__alltraps>

001021ad <vector59>:
.globl vector59
vector59:
  pushl $0
  1021ad:	6a 00                	push   $0x0
  pushl $59
  1021af:	6a 3b                	push   $0x3b
  jmp __alltraps
  1021b1:	e9 d0 fd ff ff       	jmp    101f86 <__alltraps>

001021b6 <vector60>:
.globl vector60
vector60:
  pushl $0
  1021b6:	6a 00                	push   $0x0
  pushl $60
  1021b8:	6a 3c                	push   $0x3c
  jmp __alltraps
  1021ba:	e9 c7 fd ff ff       	jmp    101f86 <__alltraps>

001021bf <vector61>:
.globl vector61
vector61:
  pushl $0
  1021bf:	6a 00                	push   $0x0
  pushl $61
  1021c1:	6a 3d                	push   $0x3d
  jmp __alltraps
  1021c3:	e9 be fd ff ff       	jmp    101f86 <__alltraps>

001021c8 <vector62>:
.globl vector62
vector62:
  pushl $0
  1021c8:	6a 00                	push   $0x0
  pushl $62
  1021ca:	6a 3e                	push   $0x3e
  jmp __alltraps
  1021cc:	e9 b5 fd ff ff       	jmp    101f86 <__alltraps>

001021d1 <vector63>:
.globl vector63
vector63:
  pushl $0
  1021d1:	6a 00                	push   $0x0
  pushl $63
  1021d3:	6a 3f                	push   $0x3f
  jmp __alltraps
  1021d5:	e9 ac fd ff ff       	jmp    101f86 <__alltraps>

001021da <vector64>:
.globl vector64
vector64:
  pushl $0
  1021da:	6a 00                	push   $0x0
  pushl $64
  1021dc:	6a 40                	push   $0x40
  jmp __alltraps
  1021de:	e9 a3 fd ff ff       	jmp    101f86 <__alltraps>

001021e3 <vector65>:
.globl vector65
vector65:
  pushl $0
  1021e3:	6a 00                	push   $0x0
  pushl $65
  1021e5:	6a 41                	push   $0x41
  jmp __alltraps
  1021e7:	e9 9a fd ff ff       	jmp    101f86 <__alltraps>

001021ec <vector66>:
.globl vector66
vector66:
  pushl $0
  1021ec:	6a 00                	push   $0x0
  pushl $66
  1021ee:	6a 42                	push   $0x42
  jmp __alltraps
  1021f0:	e9 91 fd ff ff       	jmp    101f86 <__alltraps>

001021f5 <vector67>:
.globl vector67
vector67:
  pushl $0
  1021f5:	6a 00                	push   $0x0
  pushl $67
  1021f7:	6a 43                	push   $0x43
  jmp __alltraps
  1021f9:	e9 88 fd ff ff       	jmp    101f86 <__alltraps>

001021fe <vector68>:
.globl vector68
vector68:
  pushl $0
  1021fe:	6a 00                	push   $0x0
  pushl $68
  102200:	6a 44                	push   $0x44
  jmp __alltraps
  102202:	e9 7f fd ff ff       	jmp    101f86 <__alltraps>

00102207 <vector69>:
.globl vector69
vector69:
  pushl $0
  102207:	6a 00                	push   $0x0
  pushl $69
  102209:	6a 45                	push   $0x45
  jmp __alltraps
  10220b:	e9 76 fd ff ff       	jmp    101f86 <__alltraps>

00102210 <vector70>:
.globl vector70
vector70:
  pushl $0
  102210:	6a 00                	push   $0x0
  pushl $70
  102212:	6a 46                	push   $0x46
  jmp __alltraps
  102214:	e9 6d fd ff ff       	jmp    101f86 <__alltraps>

00102219 <vector71>:
.globl vector71
vector71:
  pushl $0
  102219:	6a 00                	push   $0x0
  pushl $71
  10221b:	6a 47                	push   $0x47
  jmp __alltraps
  10221d:	e9 64 fd ff ff       	jmp    101f86 <__alltraps>

00102222 <vector72>:
.globl vector72
vector72:
  pushl $0
  102222:	6a 00                	push   $0x0
  pushl $72
  102224:	6a 48                	push   $0x48
  jmp __alltraps
  102226:	e9 5b fd ff ff       	jmp    101f86 <__alltraps>

0010222b <vector73>:
.globl vector73
vector73:
  pushl $0
  10222b:	6a 00                	push   $0x0
  pushl $73
  10222d:	6a 49                	push   $0x49
  jmp __alltraps
  10222f:	e9 52 fd ff ff       	jmp    101f86 <__alltraps>

00102234 <vector74>:
.globl vector74
vector74:
  pushl $0
  102234:	6a 00                	push   $0x0
  pushl $74
  102236:	6a 4a                	push   $0x4a
  jmp __alltraps
  102238:	e9 49 fd ff ff       	jmp    101f86 <__alltraps>

0010223d <vector75>:
.globl vector75
vector75:
  pushl $0
  10223d:	6a 00                	push   $0x0
  pushl $75
  10223f:	6a 4b                	push   $0x4b
  jmp __alltraps
  102241:	e9 40 fd ff ff       	jmp    101f86 <__alltraps>

00102246 <vector76>:
.globl vector76
vector76:
  pushl $0
  102246:	6a 00                	push   $0x0
  pushl $76
  102248:	6a 4c                	push   $0x4c
  jmp __alltraps
  10224a:	e9 37 fd ff ff       	jmp    101f86 <__alltraps>

0010224f <vector77>:
.globl vector77
vector77:
  pushl $0
  10224f:	6a 00                	push   $0x0
  pushl $77
  102251:	6a 4d                	push   $0x4d
  jmp __alltraps
  102253:	e9 2e fd ff ff       	jmp    101f86 <__alltraps>

00102258 <vector78>:
.globl vector78
vector78:
  pushl $0
  102258:	6a 00                	push   $0x0
  pushl $78
  10225a:	6a 4e                	push   $0x4e
  jmp __alltraps
  10225c:	e9 25 fd ff ff       	jmp    101f86 <__alltraps>

00102261 <vector79>:
.globl vector79
vector79:
  pushl $0
  102261:	6a 00                	push   $0x0
  pushl $79
  102263:	6a 4f                	push   $0x4f
  jmp __alltraps
  102265:	e9 1c fd ff ff       	jmp    101f86 <__alltraps>

0010226a <vector80>:
.globl vector80
vector80:
  pushl $0
  10226a:	6a 00                	push   $0x0
  pushl $80
  10226c:	6a 50                	push   $0x50
  jmp __alltraps
  10226e:	e9 13 fd ff ff       	jmp    101f86 <__alltraps>

00102273 <vector81>:
.globl vector81
vector81:
  pushl $0
  102273:	6a 00                	push   $0x0
  pushl $81
  102275:	6a 51                	push   $0x51
  jmp __alltraps
  102277:	e9 0a fd ff ff       	jmp    101f86 <__alltraps>

0010227c <vector82>:
.globl vector82
vector82:
  pushl $0
  10227c:	6a 00                	push   $0x0
  pushl $82
  10227e:	6a 52                	push   $0x52
  jmp __alltraps
  102280:	e9 01 fd ff ff       	jmp    101f86 <__alltraps>

00102285 <vector83>:
.globl vector83
vector83:
  pushl $0
  102285:	6a 00                	push   $0x0
  pushl $83
  102287:	6a 53                	push   $0x53
  jmp __alltraps
  102289:	e9 f8 fc ff ff       	jmp    101f86 <__alltraps>

0010228e <vector84>:
.globl vector84
vector84:
  pushl $0
  10228e:	6a 00                	push   $0x0
  pushl $84
  102290:	6a 54                	push   $0x54
  jmp __alltraps
  102292:	e9 ef fc ff ff       	jmp    101f86 <__alltraps>

00102297 <vector85>:
.globl vector85
vector85:
  pushl $0
  102297:	6a 00                	push   $0x0
  pushl $85
  102299:	6a 55                	push   $0x55
  jmp __alltraps
  10229b:	e9 e6 fc ff ff       	jmp    101f86 <__alltraps>

001022a0 <vector86>:
.globl vector86
vector86:
  pushl $0
  1022a0:	6a 00                	push   $0x0
  pushl $86
  1022a2:	6a 56                	push   $0x56
  jmp __alltraps
  1022a4:	e9 dd fc ff ff       	jmp    101f86 <__alltraps>

001022a9 <vector87>:
.globl vector87
vector87:
  pushl $0
  1022a9:	6a 00                	push   $0x0
  pushl $87
  1022ab:	6a 57                	push   $0x57
  jmp __alltraps
  1022ad:	e9 d4 fc ff ff       	jmp    101f86 <__alltraps>

001022b2 <vector88>:
.globl vector88
vector88:
  pushl $0
  1022b2:	6a 00                	push   $0x0
  pushl $88
  1022b4:	6a 58                	push   $0x58
  jmp __alltraps
  1022b6:	e9 cb fc ff ff       	jmp    101f86 <__alltraps>

001022bb <vector89>:
.globl vector89
vector89:
  pushl $0
  1022bb:	6a 00                	push   $0x0
  pushl $89
  1022bd:	6a 59                	push   $0x59
  jmp __alltraps
  1022bf:	e9 c2 fc ff ff       	jmp    101f86 <__alltraps>

001022c4 <vector90>:
.globl vector90
vector90:
  pushl $0
  1022c4:	6a 00                	push   $0x0
  pushl $90
  1022c6:	6a 5a                	push   $0x5a
  jmp __alltraps
  1022c8:	e9 b9 fc ff ff       	jmp    101f86 <__alltraps>

001022cd <vector91>:
.globl vector91
vector91:
  pushl $0
  1022cd:	6a 00                	push   $0x0
  pushl $91
  1022cf:	6a 5b                	push   $0x5b
  jmp __alltraps
  1022d1:	e9 b0 fc ff ff       	jmp    101f86 <__alltraps>

001022d6 <vector92>:
.globl vector92
vector92:
  pushl $0
  1022d6:	6a 00                	push   $0x0
  pushl $92
  1022d8:	6a 5c                	push   $0x5c
  jmp __alltraps
  1022da:	e9 a7 fc ff ff       	jmp    101f86 <__alltraps>

001022df <vector93>:
.globl vector93
vector93:
  pushl $0
  1022df:	6a 00                	push   $0x0
  pushl $93
  1022e1:	6a 5d                	push   $0x5d
  jmp __alltraps
  1022e3:	e9 9e fc ff ff       	jmp    101f86 <__alltraps>

001022e8 <vector94>:
.globl vector94
vector94:
  pushl $0
  1022e8:	6a 00                	push   $0x0
  pushl $94
  1022ea:	6a 5e                	push   $0x5e
  jmp __alltraps
  1022ec:	e9 95 fc ff ff       	jmp    101f86 <__alltraps>

001022f1 <vector95>:
.globl vector95
vector95:
  pushl $0
  1022f1:	6a 00                	push   $0x0
  pushl $95
  1022f3:	6a 5f                	push   $0x5f
  jmp __alltraps
  1022f5:	e9 8c fc ff ff       	jmp    101f86 <__alltraps>

001022fa <vector96>:
.globl vector96
vector96:
  pushl $0
  1022fa:	6a 00                	push   $0x0
  pushl $96
  1022fc:	6a 60                	push   $0x60
  jmp __alltraps
  1022fe:	e9 83 fc ff ff       	jmp    101f86 <__alltraps>

00102303 <vector97>:
.globl vector97
vector97:
  pushl $0
  102303:	6a 00                	push   $0x0
  pushl $97
  102305:	6a 61                	push   $0x61
  jmp __alltraps
  102307:	e9 7a fc ff ff       	jmp    101f86 <__alltraps>

0010230c <vector98>:
.globl vector98
vector98:
  pushl $0
  10230c:	6a 00                	push   $0x0
  pushl $98
  10230e:	6a 62                	push   $0x62
  jmp __alltraps
  102310:	e9 71 fc ff ff       	jmp    101f86 <__alltraps>

00102315 <vector99>:
.globl vector99
vector99:
  pushl $0
  102315:	6a 00                	push   $0x0
  pushl $99
  102317:	6a 63                	push   $0x63
  jmp __alltraps
  102319:	e9 68 fc ff ff       	jmp    101f86 <__alltraps>

0010231e <vector100>:
.globl vector100
vector100:
  pushl $0
  10231e:	6a 00                	push   $0x0
  pushl $100
  102320:	6a 64                	push   $0x64
  jmp __alltraps
  102322:	e9 5f fc ff ff       	jmp    101f86 <__alltraps>

00102327 <vector101>:
.globl vector101
vector101:
  pushl $0
  102327:	6a 00                	push   $0x0
  pushl $101
  102329:	6a 65                	push   $0x65
  jmp __alltraps
  10232b:	e9 56 fc ff ff       	jmp    101f86 <__alltraps>

00102330 <vector102>:
.globl vector102
vector102:
  pushl $0
  102330:	6a 00                	push   $0x0
  pushl $102
  102332:	6a 66                	push   $0x66
  jmp __alltraps
  102334:	e9 4d fc ff ff       	jmp    101f86 <__alltraps>

00102339 <vector103>:
.globl vector103
vector103:
  pushl $0
  102339:	6a 00                	push   $0x0
  pushl $103
  10233b:	6a 67                	push   $0x67
  jmp __alltraps
  10233d:	e9 44 fc ff ff       	jmp    101f86 <__alltraps>

00102342 <vector104>:
.globl vector104
vector104:
  pushl $0
  102342:	6a 00                	push   $0x0
  pushl $104
  102344:	6a 68                	push   $0x68
  jmp __alltraps
  102346:	e9 3b fc ff ff       	jmp    101f86 <__alltraps>

0010234b <vector105>:
.globl vector105
vector105:
  pushl $0
  10234b:	6a 00                	push   $0x0
  pushl $105
  10234d:	6a 69                	push   $0x69
  jmp __alltraps
  10234f:	e9 32 fc ff ff       	jmp    101f86 <__alltraps>

00102354 <vector106>:
.globl vector106
vector106:
  pushl $0
  102354:	6a 00                	push   $0x0
  pushl $106
  102356:	6a 6a                	push   $0x6a
  jmp __alltraps
  102358:	e9 29 fc ff ff       	jmp    101f86 <__alltraps>

0010235d <vector107>:
.globl vector107
vector107:
  pushl $0
  10235d:	6a 00                	push   $0x0
  pushl $107
  10235f:	6a 6b                	push   $0x6b
  jmp __alltraps
  102361:	e9 20 fc ff ff       	jmp    101f86 <__alltraps>

00102366 <vector108>:
.globl vector108
vector108:
  pushl $0
  102366:	6a 00                	push   $0x0
  pushl $108
  102368:	6a 6c                	push   $0x6c
  jmp __alltraps
  10236a:	e9 17 fc ff ff       	jmp    101f86 <__alltraps>

0010236f <vector109>:
.globl vector109
vector109:
  pushl $0
  10236f:	6a 00                	push   $0x0
  pushl $109
  102371:	6a 6d                	push   $0x6d
  jmp __alltraps
  102373:	e9 0e fc ff ff       	jmp    101f86 <__alltraps>

00102378 <vector110>:
.globl vector110
vector110:
  pushl $0
  102378:	6a 00                	push   $0x0
  pushl $110
  10237a:	6a 6e                	push   $0x6e
  jmp __alltraps
  10237c:	e9 05 fc ff ff       	jmp    101f86 <__alltraps>

00102381 <vector111>:
.globl vector111
vector111:
  pushl $0
  102381:	6a 00                	push   $0x0
  pushl $111
  102383:	6a 6f                	push   $0x6f
  jmp __alltraps
  102385:	e9 fc fb ff ff       	jmp    101f86 <__alltraps>

0010238a <vector112>:
.globl vector112
vector112:
  pushl $0
  10238a:	6a 00                	push   $0x0
  pushl $112
  10238c:	6a 70                	push   $0x70
  jmp __alltraps
  10238e:	e9 f3 fb ff ff       	jmp    101f86 <__alltraps>

00102393 <vector113>:
.globl vector113
vector113:
  pushl $0
  102393:	6a 00                	push   $0x0
  pushl $113
  102395:	6a 71                	push   $0x71
  jmp __alltraps
  102397:	e9 ea fb ff ff       	jmp    101f86 <__alltraps>

0010239c <vector114>:
.globl vector114
vector114:
  pushl $0
  10239c:	6a 00                	push   $0x0
  pushl $114
  10239e:	6a 72                	push   $0x72
  jmp __alltraps
  1023a0:	e9 e1 fb ff ff       	jmp    101f86 <__alltraps>

001023a5 <vector115>:
.globl vector115
vector115:
  pushl $0
  1023a5:	6a 00                	push   $0x0
  pushl $115
  1023a7:	6a 73                	push   $0x73
  jmp __alltraps
  1023a9:	e9 d8 fb ff ff       	jmp    101f86 <__alltraps>

001023ae <vector116>:
.globl vector116
vector116:
  pushl $0
  1023ae:	6a 00                	push   $0x0
  pushl $116
  1023b0:	6a 74                	push   $0x74
  jmp __alltraps
  1023b2:	e9 cf fb ff ff       	jmp    101f86 <__alltraps>

001023b7 <vector117>:
.globl vector117
vector117:
  pushl $0
  1023b7:	6a 00                	push   $0x0
  pushl $117
  1023b9:	6a 75                	push   $0x75
  jmp __alltraps
  1023bb:	e9 c6 fb ff ff       	jmp    101f86 <__alltraps>

001023c0 <vector118>:
.globl vector118
vector118:
  pushl $0
  1023c0:	6a 00                	push   $0x0
  pushl $118
  1023c2:	6a 76                	push   $0x76
  jmp __alltraps
  1023c4:	e9 bd fb ff ff       	jmp    101f86 <__alltraps>

001023c9 <vector119>:
.globl vector119
vector119:
  pushl $0
  1023c9:	6a 00                	push   $0x0
  pushl $119
  1023cb:	6a 77                	push   $0x77
  jmp __alltraps
  1023cd:	e9 b4 fb ff ff       	jmp    101f86 <__alltraps>

001023d2 <vector120>:
.globl vector120
vector120:
  pushl $0
  1023d2:	6a 00                	push   $0x0
  pushl $120
  1023d4:	6a 78                	push   $0x78
  jmp __alltraps
  1023d6:	e9 ab fb ff ff       	jmp    101f86 <__alltraps>

001023db <vector121>:
.globl vector121
vector121:
  pushl $0
  1023db:	6a 00                	push   $0x0
  pushl $121
  1023dd:	6a 79                	push   $0x79
  jmp __alltraps
  1023df:	e9 a2 fb ff ff       	jmp    101f86 <__alltraps>

001023e4 <vector122>:
.globl vector122
vector122:
  pushl $0
  1023e4:	6a 00                	push   $0x0
  pushl $122
  1023e6:	6a 7a                	push   $0x7a
  jmp __alltraps
  1023e8:	e9 99 fb ff ff       	jmp    101f86 <__alltraps>

001023ed <vector123>:
.globl vector123
vector123:
  pushl $0
  1023ed:	6a 00                	push   $0x0
  pushl $123
  1023ef:	6a 7b                	push   $0x7b
  jmp __alltraps
  1023f1:	e9 90 fb ff ff       	jmp    101f86 <__alltraps>

001023f6 <vector124>:
.globl vector124
vector124:
  pushl $0
  1023f6:	6a 00                	push   $0x0
  pushl $124
  1023f8:	6a 7c                	push   $0x7c
  jmp __alltraps
  1023fa:	e9 87 fb ff ff       	jmp    101f86 <__alltraps>

001023ff <vector125>:
.globl vector125
vector125:
  pushl $0
  1023ff:	6a 00                	push   $0x0
  pushl $125
  102401:	6a 7d                	push   $0x7d
  jmp __alltraps
  102403:	e9 7e fb ff ff       	jmp    101f86 <__alltraps>

00102408 <vector126>:
.globl vector126
vector126:
  pushl $0
  102408:	6a 00                	push   $0x0
  pushl $126
  10240a:	6a 7e                	push   $0x7e
  jmp __alltraps
  10240c:	e9 75 fb ff ff       	jmp    101f86 <__alltraps>

00102411 <vector127>:
.globl vector127
vector127:
  pushl $0
  102411:	6a 00                	push   $0x0
  pushl $127
  102413:	6a 7f                	push   $0x7f
  jmp __alltraps
  102415:	e9 6c fb ff ff       	jmp    101f86 <__alltraps>

0010241a <vector128>:
.globl vector128
vector128:
  pushl $0
  10241a:	6a 00                	push   $0x0
  pushl $128
  10241c:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  102421:	e9 60 fb ff ff       	jmp    101f86 <__alltraps>

00102426 <vector129>:
.globl vector129
vector129:
  pushl $0
  102426:	6a 00                	push   $0x0
  pushl $129
  102428:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  10242d:	e9 54 fb ff ff       	jmp    101f86 <__alltraps>

00102432 <vector130>:
.globl vector130
vector130:
  pushl $0
  102432:	6a 00                	push   $0x0
  pushl $130
  102434:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  102439:	e9 48 fb ff ff       	jmp    101f86 <__alltraps>

0010243e <vector131>:
.globl vector131
vector131:
  pushl $0
  10243e:	6a 00                	push   $0x0
  pushl $131
  102440:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  102445:	e9 3c fb ff ff       	jmp    101f86 <__alltraps>

0010244a <vector132>:
.globl vector132
vector132:
  pushl $0
  10244a:	6a 00                	push   $0x0
  pushl $132
  10244c:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  102451:	e9 30 fb ff ff       	jmp    101f86 <__alltraps>

00102456 <vector133>:
.globl vector133
vector133:
  pushl $0
  102456:	6a 00                	push   $0x0
  pushl $133
  102458:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  10245d:	e9 24 fb ff ff       	jmp    101f86 <__alltraps>

00102462 <vector134>:
.globl vector134
vector134:
  pushl $0
  102462:	6a 00                	push   $0x0
  pushl $134
  102464:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  102469:	e9 18 fb ff ff       	jmp    101f86 <__alltraps>

0010246e <vector135>:
.globl vector135
vector135:
  pushl $0
  10246e:	6a 00                	push   $0x0
  pushl $135
  102470:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  102475:	e9 0c fb ff ff       	jmp    101f86 <__alltraps>

0010247a <vector136>:
.globl vector136
vector136:
  pushl $0
  10247a:	6a 00                	push   $0x0
  pushl $136
  10247c:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  102481:	e9 00 fb ff ff       	jmp    101f86 <__alltraps>

00102486 <vector137>:
.globl vector137
vector137:
  pushl $0
  102486:	6a 00                	push   $0x0
  pushl $137
  102488:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  10248d:	e9 f4 fa ff ff       	jmp    101f86 <__alltraps>

00102492 <vector138>:
.globl vector138
vector138:
  pushl $0
  102492:	6a 00                	push   $0x0
  pushl $138
  102494:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  102499:	e9 e8 fa ff ff       	jmp    101f86 <__alltraps>

0010249e <vector139>:
.globl vector139
vector139:
  pushl $0
  10249e:	6a 00                	push   $0x0
  pushl $139
  1024a0:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  1024a5:	e9 dc fa ff ff       	jmp    101f86 <__alltraps>

001024aa <vector140>:
.globl vector140
vector140:
  pushl $0
  1024aa:	6a 00                	push   $0x0
  pushl $140
  1024ac:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  1024b1:	e9 d0 fa ff ff       	jmp    101f86 <__alltraps>

001024b6 <vector141>:
.globl vector141
vector141:
  pushl $0
  1024b6:	6a 00                	push   $0x0
  pushl $141
  1024b8:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  1024bd:	e9 c4 fa ff ff       	jmp    101f86 <__alltraps>

001024c2 <vector142>:
.globl vector142
vector142:
  pushl $0
  1024c2:	6a 00                	push   $0x0
  pushl $142
  1024c4:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  1024c9:	e9 b8 fa ff ff       	jmp    101f86 <__alltraps>

001024ce <vector143>:
.globl vector143
vector143:
  pushl $0
  1024ce:	6a 00                	push   $0x0
  pushl $143
  1024d0:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  1024d5:	e9 ac fa ff ff       	jmp    101f86 <__alltraps>

001024da <vector144>:
.globl vector144
vector144:
  pushl $0
  1024da:	6a 00                	push   $0x0
  pushl $144
  1024dc:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  1024e1:	e9 a0 fa ff ff       	jmp    101f86 <__alltraps>

001024e6 <vector145>:
.globl vector145
vector145:
  pushl $0
  1024e6:	6a 00                	push   $0x0
  pushl $145
  1024e8:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  1024ed:	e9 94 fa ff ff       	jmp    101f86 <__alltraps>

001024f2 <vector146>:
.globl vector146
vector146:
  pushl $0
  1024f2:	6a 00                	push   $0x0
  pushl $146
  1024f4:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  1024f9:	e9 88 fa ff ff       	jmp    101f86 <__alltraps>

001024fe <vector147>:
.globl vector147
vector147:
  pushl $0
  1024fe:	6a 00                	push   $0x0
  pushl $147
  102500:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  102505:	e9 7c fa ff ff       	jmp    101f86 <__alltraps>

0010250a <vector148>:
.globl vector148
vector148:
  pushl $0
  10250a:	6a 00                	push   $0x0
  pushl $148
  10250c:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  102511:	e9 70 fa ff ff       	jmp    101f86 <__alltraps>

00102516 <vector149>:
.globl vector149
vector149:
  pushl $0
  102516:	6a 00                	push   $0x0
  pushl $149
  102518:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  10251d:	e9 64 fa ff ff       	jmp    101f86 <__alltraps>

00102522 <vector150>:
.globl vector150
vector150:
  pushl $0
  102522:	6a 00                	push   $0x0
  pushl $150
  102524:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  102529:	e9 58 fa ff ff       	jmp    101f86 <__alltraps>

0010252e <vector151>:
.globl vector151
vector151:
  pushl $0
  10252e:	6a 00                	push   $0x0
  pushl $151
  102530:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  102535:	e9 4c fa ff ff       	jmp    101f86 <__alltraps>

0010253a <vector152>:
.globl vector152
vector152:
  pushl $0
  10253a:	6a 00                	push   $0x0
  pushl $152
  10253c:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  102541:	e9 40 fa ff ff       	jmp    101f86 <__alltraps>

00102546 <vector153>:
.globl vector153
vector153:
  pushl $0
  102546:	6a 00                	push   $0x0
  pushl $153
  102548:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  10254d:	e9 34 fa ff ff       	jmp    101f86 <__alltraps>

00102552 <vector154>:
.globl vector154
vector154:
  pushl $0
  102552:	6a 00                	push   $0x0
  pushl $154
  102554:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  102559:	e9 28 fa ff ff       	jmp    101f86 <__alltraps>

0010255e <vector155>:
.globl vector155
vector155:
  pushl $0
  10255e:	6a 00                	push   $0x0
  pushl $155
  102560:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  102565:	e9 1c fa ff ff       	jmp    101f86 <__alltraps>

0010256a <vector156>:
.globl vector156
vector156:
  pushl $0
  10256a:	6a 00                	push   $0x0
  pushl $156
  10256c:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  102571:	e9 10 fa ff ff       	jmp    101f86 <__alltraps>

00102576 <vector157>:
.globl vector157
vector157:
  pushl $0
  102576:	6a 00                	push   $0x0
  pushl $157
  102578:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  10257d:	e9 04 fa ff ff       	jmp    101f86 <__alltraps>

00102582 <vector158>:
.globl vector158
vector158:
  pushl $0
  102582:	6a 00                	push   $0x0
  pushl $158
  102584:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  102589:	e9 f8 f9 ff ff       	jmp    101f86 <__alltraps>

0010258e <vector159>:
.globl vector159
vector159:
  pushl $0
  10258e:	6a 00                	push   $0x0
  pushl $159
  102590:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  102595:	e9 ec f9 ff ff       	jmp    101f86 <__alltraps>

0010259a <vector160>:
.globl vector160
vector160:
  pushl $0
  10259a:	6a 00                	push   $0x0
  pushl $160
  10259c:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  1025a1:	e9 e0 f9 ff ff       	jmp    101f86 <__alltraps>

001025a6 <vector161>:
.globl vector161
vector161:
  pushl $0
  1025a6:	6a 00                	push   $0x0
  pushl $161
  1025a8:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  1025ad:	e9 d4 f9 ff ff       	jmp    101f86 <__alltraps>

001025b2 <vector162>:
.globl vector162
vector162:
  pushl $0
  1025b2:	6a 00                	push   $0x0
  pushl $162
  1025b4:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  1025b9:	e9 c8 f9 ff ff       	jmp    101f86 <__alltraps>

001025be <vector163>:
.globl vector163
vector163:
  pushl $0
  1025be:	6a 00                	push   $0x0
  pushl $163
  1025c0:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  1025c5:	e9 bc f9 ff ff       	jmp    101f86 <__alltraps>

001025ca <vector164>:
.globl vector164
vector164:
  pushl $0
  1025ca:	6a 00                	push   $0x0
  pushl $164
  1025cc:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  1025d1:	e9 b0 f9 ff ff       	jmp    101f86 <__alltraps>

001025d6 <vector165>:
.globl vector165
vector165:
  pushl $0
  1025d6:	6a 00                	push   $0x0
  pushl $165
  1025d8:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  1025dd:	e9 a4 f9 ff ff       	jmp    101f86 <__alltraps>

001025e2 <vector166>:
.globl vector166
vector166:
  pushl $0
  1025e2:	6a 00                	push   $0x0
  pushl $166
  1025e4:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  1025e9:	e9 98 f9 ff ff       	jmp    101f86 <__alltraps>

001025ee <vector167>:
.globl vector167
vector167:
  pushl $0
  1025ee:	6a 00                	push   $0x0
  pushl $167
  1025f0:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  1025f5:	e9 8c f9 ff ff       	jmp    101f86 <__alltraps>

001025fa <vector168>:
.globl vector168
vector168:
  pushl $0
  1025fa:	6a 00                	push   $0x0
  pushl $168
  1025fc:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  102601:	e9 80 f9 ff ff       	jmp    101f86 <__alltraps>

00102606 <vector169>:
.globl vector169
vector169:
  pushl $0
  102606:	6a 00                	push   $0x0
  pushl $169
  102608:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  10260d:	e9 74 f9 ff ff       	jmp    101f86 <__alltraps>

00102612 <vector170>:
.globl vector170
vector170:
  pushl $0
  102612:	6a 00                	push   $0x0
  pushl $170
  102614:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  102619:	e9 68 f9 ff ff       	jmp    101f86 <__alltraps>

0010261e <vector171>:
.globl vector171
vector171:
  pushl $0
  10261e:	6a 00                	push   $0x0
  pushl $171
  102620:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  102625:	e9 5c f9 ff ff       	jmp    101f86 <__alltraps>

0010262a <vector172>:
.globl vector172
vector172:
  pushl $0
  10262a:	6a 00                	push   $0x0
  pushl $172
  10262c:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  102631:	e9 50 f9 ff ff       	jmp    101f86 <__alltraps>

00102636 <vector173>:
.globl vector173
vector173:
  pushl $0
  102636:	6a 00                	push   $0x0
  pushl $173
  102638:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  10263d:	e9 44 f9 ff ff       	jmp    101f86 <__alltraps>

00102642 <vector174>:
.globl vector174
vector174:
  pushl $0
  102642:	6a 00                	push   $0x0
  pushl $174
  102644:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  102649:	e9 38 f9 ff ff       	jmp    101f86 <__alltraps>

0010264e <vector175>:
.globl vector175
vector175:
  pushl $0
  10264e:	6a 00                	push   $0x0
  pushl $175
  102650:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  102655:	e9 2c f9 ff ff       	jmp    101f86 <__alltraps>

0010265a <vector176>:
.globl vector176
vector176:
  pushl $0
  10265a:	6a 00                	push   $0x0
  pushl $176
  10265c:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  102661:	e9 20 f9 ff ff       	jmp    101f86 <__alltraps>

00102666 <vector177>:
.globl vector177
vector177:
  pushl $0
  102666:	6a 00                	push   $0x0
  pushl $177
  102668:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  10266d:	e9 14 f9 ff ff       	jmp    101f86 <__alltraps>

00102672 <vector178>:
.globl vector178
vector178:
  pushl $0
  102672:	6a 00                	push   $0x0
  pushl $178
  102674:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  102679:	e9 08 f9 ff ff       	jmp    101f86 <__alltraps>

0010267e <vector179>:
.globl vector179
vector179:
  pushl $0
  10267e:	6a 00                	push   $0x0
  pushl $179
  102680:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  102685:	e9 fc f8 ff ff       	jmp    101f86 <__alltraps>

0010268a <vector180>:
.globl vector180
vector180:
  pushl $0
  10268a:	6a 00                	push   $0x0
  pushl $180
  10268c:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  102691:	e9 f0 f8 ff ff       	jmp    101f86 <__alltraps>

00102696 <vector181>:
.globl vector181
vector181:
  pushl $0
  102696:	6a 00                	push   $0x0
  pushl $181
  102698:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  10269d:	e9 e4 f8 ff ff       	jmp    101f86 <__alltraps>

001026a2 <vector182>:
.globl vector182
vector182:
  pushl $0
  1026a2:	6a 00                	push   $0x0
  pushl $182
  1026a4:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  1026a9:	e9 d8 f8 ff ff       	jmp    101f86 <__alltraps>

001026ae <vector183>:
.globl vector183
vector183:
  pushl $0
  1026ae:	6a 00                	push   $0x0
  pushl $183
  1026b0:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  1026b5:	e9 cc f8 ff ff       	jmp    101f86 <__alltraps>

001026ba <vector184>:
.globl vector184
vector184:
  pushl $0
  1026ba:	6a 00                	push   $0x0
  pushl $184
  1026bc:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  1026c1:	e9 c0 f8 ff ff       	jmp    101f86 <__alltraps>

001026c6 <vector185>:
.globl vector185
vector185:
  pushl $0
  1026c6:	6a 00                	push   $0x0
  pushl $185
  1026c8:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  1026cd:	e9 b4 f8 ff ff       	jmp    101f86 <__alltraps>

001026d2 <vector186>:
.globl vector186
vector186:
  pushl $0
  1026d2:	6a 00                	push   $0x0
  pushl $186
  1026d4:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  1026d9:	e9 a8 f8 ff ff       	jmp    101f86 <__alltraps>

001026de <vector187>:
.globl vector187
vector187:
  pushl $0
  1026de:	6a 00                	push   $0x0
  pushl $187
  1026e0:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  1026e5:	e9 9c f8 ff ff       	jmp    101f86 <__alltraps>

001026ea <vector188>:
.globl vector188
vector188:
  pushl $0
  1026ea:	6a 00                	push   $0x0
  pushl $188
  1026ec:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  1026f1:	e9 90 f8 ff ff       	jmp    101f86 <__alltraps>

001026f6 <vector189>:
.globl vector189
vector189:
  pushl $0
  1026f6:	6a 00                	push   $0x0
  pushl $189
  1026f8:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  1026fd:	e9 84 f8 ff ff       	jmp    101f86 <__alltraps>

00102702 <vector190>:
.globl vector190
vector190:
  pushl $0
  102702:	6a 00                	push   $0x0
  pushl $190
  102704:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  102709:	e9 78 f8 ff ff       	jmp    101f86 <__alltraps>

0010270e <vector191>:
.globl vector191
vector191:
  pushl $0
  10270e:	6a 00                	push   $0x0
  pushl $191
  102710:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  102715:	e9 6c f8 ff ff       	jmp    101f86 <__alltraps>

0010271a <vector192>:
.globl vector192
vector192:
  pushl $0
  10271a:	6a 00                	push   $0x0
  pushl $192
  10271c:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  102721:	e9 60 f8 ff ff       	jmp    101f86 <__alltraps>

00102726 <vector193>:
.globl vector193
vector193:
  pushl $0
  102726:	6a 00                	push   $0x0
  pushl $193
  102728:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  10272d:	e9 54 f8 ff ff       	jmp    101f86 <__alltraps>

00102732 <vector194>:
.globl vector194
vector194:
  pushl $0
  102732:	6a 00                	push   $0x0
  pushl $194
  102734:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  102739:	e9 48 f8 ff ff       	jmp    101f86 <__alltraps>

0010273e <vector195>:
.globl vector195
vector195:
  pushl $0
  10273e:	6a 00                	push   $0x0
  pushl $195
  102740:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  102745:	e9 3c f8 ff ff       	jmp    101f86 <__alltraps>

0010274a <vector196>:
.globl vector196
vector196:
  pushl $0
  10274a:	6a 00                	push   $0x0
  pushl $196
  10274c:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  102751:	e9 30 f8 ff ff       	jmp    101f86 <__alltraps>

00102756 <vector197>:
.globl vector197
vector197:
  pushl $0
  102756:	6a 00                	push   $0x0
  pushl $197
  102758:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  10275d:	e9 24 f8 ff ff       	jmp    101f86 <__alltraps>

00102762 <vector198>:
.globl vector198
vector198:
  pushl $0
  102762:	6a 00                	push   $0x0
  pushl $198
  102764:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  102769:	e9 18 f8 ff ff       	jmp    101f86 <__alltraps>

0010276e <vector199>:
.globl vector199
vector199:
  pushl $0
  10276e:	6a 00                	push   $0x0
  pushl $199
  102770:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  102775:	e9 0c f8 ff ff       	jmp    101f86 <__alltraps>

0010277a <vector200>:
.globl vector200
vector200:
  pushl $0
  10277a:	6a 00                	push   $0x0
  pushl $200
  10277c:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  102781:	e9 00 f8 ff ff       	jmp    101f86 <__alltraps>

00102786 <vector201>:
.globl vector201
vector201:
  pushl $0
  102786:	6a 00                	push   $0x0
  pushl $201
  102788:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  10278d:	e9 f4 f7 ff ff       	jmp    101f86 <__alltraps>

00102792 <vector202>:
.globl vector202
vector202:
  pushl $0
  102792:	6a 00                	push   $0x0
  pushl $202
  102794:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  102799:	e9 e8 f7 ff ff       	jmp    101f86 <__alltraps>

0010279e <vector203>:
.globl vector203
vector203:
  pushl $0
  10279e:	6a 00                	push   $0x0
  pushl $203
  1027a0:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  1027a5:	e9 dc f7 ff ff       	jmp    101f86 <__alltraps>

001027aa <vector204>:
.globl vector204
vector204:
  pushl $0
  1027aa:	6a 00                	push   $0x0
  pushl $204
  1027ac:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  1027b1:	e9 d0 f7 ff ff       	jmp    101f86 <__alltraps>

001027b6 <vector205>:
.globl vector205
vector205:
  pushl $0
  1027b6:	6a 00                	push   $0x0
  pushl $205
  1027b8:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  1027bd:	e9 c4 f7 ff ff       	jmp    101f86 <__alltraps>

001027c2 <vector206>:
.globl vector206
vector206:
  pushl $0
  1027c2:	6a 00                	push   $0x0
  pushl $206
  1027c4:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  1027c9:	e9 b8 f7 ff ff       	jmp    101f86 <__alltraps>

001027ce <vector207>:
.globl vector207
vector207:
  pushl $0
  1027ce:	6a 00                	push   $0x0
  pushl $207
  1027d0:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  1027d5:	e9 ac f7 ff ff       	jmp    101f86 <__alltraps>

001027da <vector208>:
.globl vector208
vector208:
  pushl $0
  1027da:	6a 00                	push   $0x0
  pushl $208
  1027dc:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  1027e1:	e9 a0 f7 ff ff       	jmp    101f86 <__alltraps>

001027e6 <vector209>:
.globl vector209
vector209:
  pushl $0
  1027e6:	6a 00                	push   $0x0
  pushl $209
  1027e8:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  1027ed:	e9 94 f7 ff ff       	jmp    101f86 <__alltraps>

001027f2 <vector210>:
.globl vector210
vector210:
  pushl $0
  1027f2:	6a 00                	push   $0x0
  pushl $210
  1027f4:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  1027f9:	e9 88 f7 ff ff       	jmp    101f86 <__alltraps>

001027fe <vector211>:
.globl vector211
vector211:
  pushl $0
  1027fe:	6a 00                	push   $0x0
  pushl $211
  102800:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  102805:	e9 7c f7 ff ff       	jmp    101f86 <__alltraps>

0010280a <vector212>:
.globl vector212
vector212:
  pushl $0
  10280a:	6a 00                	push   $0x0
  pushl $212
  10280c:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  102811:	e9 70 f7 ff ff       	jmp    101f86 <__alltraps>

00102816 <vector213>:
.globl vector213
vector213:
  pushl $0
  102816:	6a 00                	push   $0x0
  pushl $213
  102818:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  10281d:	e9 64 f7 ff ff       	jmp    101f86 <__alltraps>

00102822 <vector214>:
.globl vector214
vector214:
  pushl $0
  102822:	6a 00                	push   $0x0
  pushl $214
  102824:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  102829:	e9 58 f7 ff ff       	jmp    101f86 <__alltraps>

0010282e <vector215>:
.globl vector215
vector215:
  pushl $0
  10282e:	6a 00                	push   $0x0
  pushl $215
  102830:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  102835:	e9 4c f7 ff ff       	jmp    101f86 <__alltraps>

0010283a <vector216>:
.globl vector216
vector216:
  pushl $0
  10283a:	6a 00                	push   $0x0
  pushl $216
  10283c:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  102841:	e9 40 f7 ff ff       	jmp    101f86 <__alltraps>

00102846 <vector217>:
.globl vector217
vector217:
  pushl $0
  102846:	6a 00                	push   $0x0
  pushl $217
  102848:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  10284d:	e9 34 f7 ff ff       	jmp    101f86 <__alltraps>

00102852 <vector218>:
.globl vector218
vector218:
  pushl $0
  102852:	6a 00                	push   $0x0
  pushl $218
  102854:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  102859:	e9 28 f7 ff ff       	jmp    101f86 <__alltraps>

0010285e <vector219>:
.globl vector219
vector219:
  pushl $0
  10285e:	6a 00                	push   $0x0
  pushl $219
  102860:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  102865:	e9 1c f7 ff ff       	jmp    101f86 <__alltraps>

0010286a <vector220>:
.globl vector220
vector220:
  pushl $0
  10286a:	6a 00                	push   $0x0
  pushl $220
  10286c:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  102871:	e9 10 f7 ff ff       	jmp    101f86 <__alltraps>

00102876 <vector221>:
.globl vector221
vector221:
  pushl $0
  102876:	6a 00                	push   $0x0
  pushl $221
  102878:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  10287d:	e9 04 f7 ff ff       	jmp    101f86 <__alltraps>

00102882 <vector222>:
.globl vector222
vector222:
  pushl $0
  102882:	6a 00                	push   $0x0
  pushl $222
  102884:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  102889:	e9 f8 f6 ff ff       	jmp    101f86 <__alltraps>

0010288e <vector223>:
.globl vector223
vector223:
  pushl $0
  10288e:	6a 00                	push   $0x0
  pushl $223
  102890:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  102895:	e9 ec f6 ff ff       	jmp    101f86 <__alltraps>

0010289a <vector224>:
.globl vector224
vector224:
  pushl $0
  10289a:	6a 00                	push   $0x0
  pushl $224
  10289c:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  1028a1:	e9 e0 f6 ff ff       	jmp    101f86 <__alltraps>

001028a6 <vector225>:
.globl vector225
vector225:
  pushl $0
  1028a6:	6a 00                	push   $0x0
  pushl $225
  1028a8:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  1028ad:	e9 d4 f6 ff ff       	jmp    101f86 <__alltraps>

001028b2 <vector226>:
.globl vector226
vector226:
  pushl $0
  1028b2:	6a 00                	push   $0x0
  pushl $226
  1028b4:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  1028b9:	e9 c8 f6 ff ff       	jmp    101f86 <__alltraps>

001028be <vector227>:
.globl vector227
vector227:
  pushl $0
  1028be:	6a 00                	push   $0x0
  pushl $227
  1028c0:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  1028c5:	e9 bc f6 ff ff       	jmp    101f86 <__alltraps>

001028ca <vector228>:
.globl vector228
vector228:
  pushl $0
  1028ca:	6a 00                	push   $0x0
  pushl $228
  1028cc:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  1028d1:	e9 b0 f6 ff ff       	jmp    101f86 <__alltraps>

001028d6 <vector229>:
.globl vector229
vector229:
  pushl $0
  1028d6:	6a 00                	push   $0x0
  pushl $229
  1028d8:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  1028dd:	e9 a4 f6 ff ff       	jmp    101f86 <__alltraps>

001028e2 <vector230>:
.globl vector230
vector230:
  pushl $0
  1028e2:	6a 00                	push   $0x0
  pushl $230
  1028e4:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  1028e9:	e9 98 f6 ff ff       	jmp    101f86 <__alltraps>

001028ee <vector231>:
.globl vector231
vector231:
  pushl $0
  1028ee:	6a 00                	push   $0x0
  pushl $231
  1028f0:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  1028f5:	e9 8c f6 ff ff       	jmp    101f86 <__alltraps>

001028fa <vector232>:
.globl vector232
vector232:
  pushl $0
  1028fa:	6a 00                	push   $0x0
  pushl $232
  1028fc:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  102901:	e9 80 f6 ff ff       	jmp    101f86 <__alltraps>

00102906 <vector233>:
.globl vector233
vector233:
  pushl $0
  102906:	6a 00                	push   $0x0
  pushl $233
  102908:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  10290d:	e9 74 f6 ff ff       	jmp    101f86 <__alltraps>

00102912 <vector234>:
.globl vector234
vector234:
  pushl $0
  102912:	6a 00                	push   $0x0
  pushl $234
  102914:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  102919:	e9 68 f6 ff ff       	jmp    101f86 <__alltraps>

0010291e <vector235>:
.globl vector235
vector235:
  pushl $0
  10291e:	6a 00                	push   $0x0
  pushl $235
  102920:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  102925:	e9 5c f6 ff ff       	jmp    101f86 <__alltraps>

0010292a <vector236>:
.globl vector236
vector236:
  pushl $0
  10292a:	6a 00                	push   $0x0
  pushl $236
  10292c:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102931:	e9 50 f6 ff ff       	jmp    101f86 <__alltraps>

00102936 <vector237>:
.globl vector237
vector237:
  pushl $0
  102936:	6a 00                	push   $0x0
  pushl $237
  102938:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  10293d:	e9 44 f6 ff ff       	jmp    101f86 <__alltraps>

00102942 <vector238>:
.globl vector238
vector238:
  pushl $0
  102942:	6a 00                	push   $0x0
  pushl $238
  102944:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  102949:	e9 38 f6 ff ff       	jmp    101f86 <__alltraps>

0010294e <vector239>:
.globl vector239
vector239:
  pushl $0
  10294e:	6a 00                	push   $0x0
  pushl $239
  102950:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  102955:	e9 2c f6 ff ff       	jmp    101f86 <__alltraps>

0010295a <vector240>:
.globl vector240
vector240:
  pushl $0
  10295a:	6a 00                	push   $0x0
  pushl $240
  10295c:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102961:	e9 20 f6 ff ff       	jmp    101f86 <__alltraps>

00102966 <vector241>:
.globl vector241
vector241:
  pushl $0
  102966:	6a 00                	push   $0x0
  pushl $241
  102968:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  10296d:	e9 14 f6 ff ff       	jmp    101f86 <__alltraps>

00102972 <vector242>:
.globl vector242
vector242:
  pushl $0
  102972:	6a 00                	push   $0x0
  pushl $242
  102974:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  102979:	e9 08 f6 ff ff       	jmp    101f86 <__alltraps>

0010297e <vector243>:
.globl vector243
vector243:
  pushl $0
  10297e:	6a 00                	push   $0x0
  pushl $243
  102980:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  102985:	e9 fc f5 ff ff       	jmp    101f86 <__alltraps>

0010298a <vector244>:
.globl vector244
vector244:
  pushl $0
  10298a:	6a 00                	push   $0x0
  pushl $244
  10298c:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  102991:	e9 f0 f5 ff ff       	jmp    101f86 <__alltraps>

00102996 <vector245>:
.globl vector245
vector245:
  pushl $0
  102996:	6a 00                	push   $0x0
  pushl $245
  102998:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  10299d:	e9 e4 f5 ff ff       	jmp    101f86 <__alltraps>

001029a2 <vector246>:
.globl vector246
vector246:
  pushl $0
  1029a2:	6a 00                	push   $0x0
  pushl $246
  1029a4:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  1029a9:	e9 d8 f5 ff ff       	jmp    101f86 <__alltraps>

001029ae <vector247>:
.globl vector247
vector247:
  pushl $0
  1029ae:	6a 00                	push   $0x0
  pushl $247
  1029b0:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  1029b5:	e9 cc f5 ff ff       	jmp    101f86 <__alltraps>

001029ba <vector248>:
.globl vector248
vector248:
  pushl $0
  1029ba:	6a 00                	push   $0x0
  pushl $248
  1029bc:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  1029c1:	e9 c0 f5 ff ff       	jmp    101f86 <__alltraps>

001029c6 <vector249>:
.globl vector249
vector249:
  pushl $0
  1029c6:	6a 00                	push   $0x0
  pushl $249
  1029c8:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  1029cd:	e9 b4 f5 ff ff       	jmp    101f86 <__alltraps>

001029d2 <vector250>:
.globl vector250
vector250:
  pushl $0
  1029d2:	6a 00                	push   $0x0
  pushl $250
  1029d4:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  1029d9:	e9 a8 f5 ff ff       	jmp    101f86 <__alltraps>

001029de <vector251>:
.globl vector251
vector251:
  pushl $0
  1029de:	6a 00                	push   $0x0
  pushl $251
  1029e0:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  1029e5:	e9 9c f5 ff ff       	jmp    101f86 <__alltraps>

001029ea <vector252>:
.globl vector252
vector252:
  pushl $0
  1029ea:	6a 00                	push   $0x0
  pushl $252
  1029ec:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  1029f1:	e9 90 f5 ff ff       	jmp    101f86 <__alltraps>

001029f6 <vector253>:
.globl vector253
vector253:
  pushl $0
  1029f6:	6a 00                	push   $0x0
  pushl $253
  1029f8:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  1029fd:	e9 84 f5 ff ff       	jmp    101f86 <__alltraps>

00102a02 <vector254>:
.globl vector254
vector254:
  pushl $0
  102a02:	6a 00                	push   $0x0
  pushl $254
  102a04:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  102a09:	e9 78 f5 ff ff       	jmp    101f86 <__alltraps>

00102a0e <vector255>:
.globl vector255
vector255:
  pushl $0
  102a0e:	6a 00                	push   $0x0
  pushl $255
  102a10:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102a15:	e9 6c f5 ff ff       	jmp    101f86 <__alltraps>

00102a1a <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  102a1a:	55                   	push   %ebp
  102a1b:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  102a1d:	8b 45 08             	mov    0x8(%ebp),%eax
  102a20:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  102a23:	b8 23 00 00 00       	mov    $0x23,%eax
  102a28:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  102a2a:	b8 23 00 00 00       	mov    $0x23,%eax
  102a2f:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102a31:	b8 10 00 00 00       	mov    $0x10,%eax
  102a36:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  102a38:	b8 10 00 00 00       	mov    $0x10,%eax
  102a3d:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102a3f:	b8 10 00 00 00       	mov    $0x10,%eax
  102a44:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  102a46:	ea 4d 2a 10 00 08 00 	ljmp   $0x8,$0x102a4d
}
  102a4d:	90                   	nop
  102a4e:	5d                   	pop    %ebp
  102a4f:	c3                   	ret    

00102a50 <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102a50:	55                   	push   %ebp
  102a51:	89 e5                	mov    %esp,%ebp
  102a53:	83 ec 14             	sub    $0x14,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  102a56:	b8 00 09 11 00       	mov    $0x110900,%eax
  102a5b:	05 00 04 00 00       	add    $0x400,%eax
  102a60:	a3 04 0d 11 00       	mov    %eax,0x110d04
    ts.ts_ss0 = KERNEL_DS;
  102a65:	66 c7 05 08 0d 11 00 	movw   $0x10,0x110d08
  102a6c:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  102a6e:	66 c7 05 08 fa 10 00 	movw   $0x68,0x10fa08
  102a75:	68 00 
  102a77:	b8 00 0d 11 00       	mov    $0x110d00,%eax
  102a7c:	0f b7 c0             	movzwl %ax,%eax
  102a7f:	66 a3 0a fa 10 00    	mov    %ax,0x10fa0a
  102a85:	b8 00 0d 11 00       	mov    $0x110d00,%eax
  102a8a:	c1 e8 10             	shr    $0x10,%eax
  102a8d:	a2 0c fa 10 00       	mov    %al,0x10fa0c
  102a92:	0f b6 05 0d fa 10 00 	movzbl 0x10fa0d,%eax
  102a99:	24 f0                	and    $0xf0,%al
  102a9b:	0c 09                	or     $0x9,%al
  102a9d:	a2 0d fa 10 00       	mov    %al,0x10fa0d
  102aa2:	0f b6 05 0d fa 10 00 	movzbl 0x10fa0d,%eax
  102aa9:	0c 10                	or     $0x10,%al
  102aab:	a2 0d fa 10 00       	mov    %al,0x10fa0d
  102ab0:	0f b6 05 0d fa 10 00 	movzbl 0x10fa0d,%eax
  102ab7:	24 9f                	and    $0x9f,%al
  102ab9:	a2 0d fa 10 00       	mov    %al,0x10fa0d
  102abe:	0f b6 05 0d fa 10 00 	movzbl 0x10fa0d,%eax
  102ac5:	0c 80                	or     $0x80,%al
  102ac7:	a2 0d fa 10 00       	mov    %al,0x10fa0d
  102acc:	0f b6 05 0e fa 10 00 	movzbl 0x10fa0e,%eax
  102ad3:	24 f0                	and    $0xf0,%al
  102ad5:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  102ada:	0f b6 05 0e fa 10 00 	movzbl 0x10fa0e,%eax
  102ae1:	24 ef                	and    $0xef,%al
  102ae3:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  102ae8:	0f b6 05 0e fa 10 00 	movzbl 0x10fa0e,%eax
  102aef:	24 df                	and    $0xdf,%al
  102af1:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  102af6:	0f b6 05 0e fa 10 00 	movzbl 0x10fa0e,%eax
  102afd:	0c 40                	or     $0x40,%al
  102aff:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  102b04:	0f b6 05 0e fa 10 00 	movzbl 0x10fa0e,%eax
  102b0b:	24 7f                	and    $0x7f,%al
  102b0d:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  102b12:	b8 00 0d 11 00       	mov    $0x110d00,%eax
  102b17:	c1 e8 18             	shr    $0x18,%eax
  102b1a:	a2 0f fa 10 00       	mov    %al,0x10fa0f
    gdt[SEG_TSS].sd_s = 0;
  102b1f:	0f b6 05 0d fa 10 00 	movzbl 0x10fa0d,%eax
  102b26:	24 ef                	and    $0xef,%al
  102b28:	a2 0d fa 10 00       	mov    %al,0x10fa0d

    // reload all segment registers
    lgdt(&gdt_pd);
  102b2d:	c7 04 24 10 fa 10 00 	movl   $0x10fa10,(%esp)
  102b34:	e8 e1 fe ff ff       	call   102a1a <lgdt>
  102b39:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  102b3f:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102b43:	0f 00 d8             	ltr    %ax
}
  102b46:	90                   	nop

    // load the TSS
    ltr(GD_TSS);
}
  102b47:	90                   	nop
  102b48:	89 ec                	mov    %ebp,%esp
  102b4a:	5d                   	pop    %ebp
  102b4b:	c3                   	ret    

00102b4c <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  102b4c:	55                   	push   %ebp
  102b4d:	89 e5                	mov    %esp,%ebp
    gdt_init();
  102b4f:	e8 fc fe ff ff       	call   102a50 <gdt_init>
}
  102b54:	90                   	nop
  102b55:	5d                   	pop    %ebp
  102b56:	c3                   	ret    

00102b57 <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  102b57:	55                   	push   %ebp
  102b58:	89 e5                	mov    %esp,%ebp
  102b5a:	83 ec 58             	sub    $0x58,%esp
  102b5d:	8b 45 10             	mov    0x10(%ebp),%eax
  102b60:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102b63:	8b 45 14             	mov    0x14(%ebp),%eax
  102b66:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  102b69:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102b6c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102b6f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102b72:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  102b75:	8b 45 18             	mov    0x18(%ebp),%eax
  102b78:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102b7b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102b7e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102b81:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102b84:	89 55 f0             	mov    %edx,-0x10(%ebp)
  102b87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102b8d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102b91:	74 1c                	je     102baf <printnum+0x58>
  102b93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b96:	ba 00 00 00 00       	mov    $0x0,%edx
  102b9b:	f7 75 e4             	divl   -0x1c(%ebp)
  102b9e:	89 55 f4             	mov    %edx,-0xc(%ebp)
  102ba1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ba4:	ba 00 00 00 00       	mov    $0x0,%edx
  102ba9:	f7 75 e4             	divl   -0x1c(%ebp)
  102bac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102baf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102bb2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102bb5:	f7 75 e4             	divl   -0x1c(%ebp)
  102bb8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102bbb:	89 55 dc             	mov    %edx,-0x24(%ebp)
  102bbe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102bc1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102bc4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102bc7:	89 55 ec             	mov    %edx,-0x14(%ebp)
  102bca:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102bcd:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  102bd0:	8b 45 18             	mov    0x18(%ebp),%eax
  102bd3:	ba 00 00 00 00       	mov    $0x0,%edx
  102bd8:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  102bdb:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  102bde:	19 d1                	sbb    %edx,%ecx
  102be0:	72 4c                	jb     102c2e <printnum+0xd7>
        printnum(putch, putdat, result, base, width - 1, padc);
  102be2:	8b 45 1c             	mov    0x1c(%ebp),%eax
  102be5:	8d 50 ff             	lea    -0x1(%eax),%edx
  102be8:	8b 45 20             	mov    0x20(%ebp),%eax
  102beb:	89 44 24 18          	mov    %eax,0x18(%esp)
  102bef:	89 54 24 14          	mov    %edx,0x14(%esp)
  102bf3:	8b 45 18             	mov    0x18(%ebp),%eax
  102bf6:	89 44 24 10          	mov    %eax,0x10(%esp)
  102bfa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102bfd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102c00:	89 44 24 08          	mov    %eax,0x8(%esp)
  102c04:	89 54 24 0c          	mov    %edx,0xc(%esp)
  102c08:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c0b:	89 44 24 04          	mov    %eax,0x4(%esp)
  102c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  102c12:	89 04 24             	mov    %eax,(%esp)
  102c15:	e8 3d ff ff ff       	call   102b57 <printnum>
  102c1a:	eb 1b                	jmp    102c37 <printnum+0xe0>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  102c1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c1f:	89 44 24 04          	mov    %eax,0x4(%esp)
  102c23:	8b 45 20             	mov    0x20(%ebp),%eax
  102c26:	89 04 24             	mov    %eax,(%esp)
  102c29:	8b 45 08             	mov    0x8(%ebp),%eax
  102c2c:	ff d0                	call   *%eax
        while (-- width > 0)
  102c2e:	ff 4d 1c             	decl   0x1c(%ebp)
  102c31:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  102c35:	7f e5                	jg     102c1c <printnum+0xc5>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  102c37:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102c3a:	05 50 3e 10 00       	add    $0x103e50,%eax
  102c3f:	0f b6 00             	movzbl (%eax),%eax
  102c42:	0f be c0             	movsbl %al,%eax
  102c45:	8b 55 0c             	mov    0xc(%ebp),%edx
  102c48:	89 54 24 04          	mov    %edx,0x4(%esp)
  102c4c:	89 04 24             	mov    %eax,(%esp)
  102c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  102c52:	ff d0                	call   *%eax
}
  102c54:	90                   	nop
  102c55:	89 ec                	mov    %ebp,%esp
  102c57:	5d                   	pop    %ebp
  102c58:	c3                   	ret    

00102c59 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  102c59:	55                   	push   %ebp
  102c5a:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102c5c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102c60:	7e 14                	jle    102c76 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  102c62:	8b 45 08             	mov    0x8(%ebp),%eax
  102c65:	8b 00                	mov    (%eax),%eax
  102c67:	8d 48 08             	lea    0x8(%eax),%ecx
  102c6a:	8b 55 08             	mov    0x8(%ebp),%edx
  102c6d:	89 0a                	mov    %ecx,(%edx)
  102c6f:	8b 50 04             	mov    0x4(%eax),%edx
  102c72:	8b 00                	mov    (%eax),%eax
  102c74:	eb 30                	jmp    102ca6 <getuint+0x4d>
    }
    else if (lflag) {
  102c76:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102c7a:	74 16                	je     102c92 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  102c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  102c7f:	8b 00                	mov    (%eax),%eax
  102c81:	8d 48 04             	lea    0x4(%eax),%ecx
  102c84:	8b 55 08             	mov    0x8(%ebp),%edx
  102c87:	89 0a                	mov    %ecx,(%edx)
  102c89:	8b 00                	mov    (%eax),%eax
  102c8b:	ba 00 00 00 00       	mov    $0x0,%edx
  102c90:	eb 14                	jmp    102ca6 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  102c92:	8b 45 08             	mov    0x8(%ebp),%eax
  102c95:	8b 00                	mov    (%eax),%eax
  102c97:	8d 48 04             	lea    0x4(%eax),%ecx
  102c9a:	8b 55 08             	mov    0x8(%ebp),%edx
  102c9d:	89 0a                	mov    %ecx,(%edx)
  102c9f:	8b 00                	mov    (%eax),%eax
  102ca1:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  102ca6:	5d                   	pop    %ebp
  102ca7:	c3                   	ret    

00102ca8 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  102ca8:	55                   	push   %ebp
  102ca9:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102cab:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102caf:	7e 14                	jle    102cc5 <getint+0x1d>
        return va_arg(*ap, long long);
  102cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  102cb4:	8b 00                	mov    (%eax),%eax
  102cb6:	8d 48 08             	lea    0x8(%eax),%ecx
  102cb9:	8b 55 08             	mov    0x8(%ebp),%edx
  102cbc:	89 0a                	mov    %ecx,(%edx)
  102cbe:	8b 50 04             	mov    0x4(%eax),%edx
  102cc1:	8b 00                	mov    (%eax),%eax
  102cc3:	eb 28                	jmp    102ced <getint+0x45>
    }
    else if (lflag) {
  102cc5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102cc9:	74 12                	je     102cdd <getint+0x35>
        return va_arg(*ap, long);
  102ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  102cce:	8b 00                	mov    (%eax),%eax
  102cd0:	8d 48 04             	lea    0x4(%eax),%ecx
  102cd3:	8b 55 08             	mov    0x8(%ebp),%edx
  102cd6:	89 0a                	mov    %ecx,(%edx)
  102cd8:	8b 00                	mov    (%eax),%eax
  102cda:	99                   	cltd   
  102cdb:	eb 10                	jmp    102ced <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  102cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  102ce0:	8b 00                	mov    (%eax),%eax
  102ce2:	8d 48 04             	lea    0x4(%eax),%ecx
  102ce5:	8b 55 08             	mov    0x8(%ebp),%edx
  102ce8:	89 0a                	mov    %ecx,(%edx)
  102cea:	8b 00                	mov    (%eax),%eax
  102cec:	99                   	cltd   
    }
}
  102ced:	5d                   	pop    %ebp
  102cee:	c3                   	ret    

00102cef <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  102cef:	55                   	push   %ebp
  102cf0:	89 e5                	mov    %esp,%ebp
  102cf2:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  102cf5:	8d 45 14             	lea    0x14(%ebp),%eax
  102cf8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  102cfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102cfe:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102d02:	8b 45 10             	mov    0x10(%ebp),%eax
  102d05:	89 44 24 08          	mov    %eax,0x8(%esp)
  102d09:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d0c:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d10:	8b 45 08             	mov    0x8(%ebp),%eax
  102d13:	89 04 24             	mov    %eax,(%esp)
  102d16:	e8 05 00 00 00       	call   102d20 <vprintfmt>
    va_end(ap);
}
  102d1b:	90                   	nop
  102d1c:	89 ec                	mov    %ebp,%esp
  102d1e:	5d                   	pop    %ebp
  102d1f:	c3                   	ret    

00102d20 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  102d20:	55                   	push   %ebp
  102d21:	89 e5                	mov    %esp,%ebp
  102d23:	56                   	push   %esi
  102d24:	53                   	push   %ebx
  102d25:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102d28:	eb 17                	jmp    102d41 <vprintfmt+0x21>
            if (ch == '\0') {
  102d2a:	85 db                	test   %ebx,%ebx
  102d2c:	0f 84 bf 03 00 00    	je     1030f1 <vprintfmt+0x3d1>
                return;
            }
            putch(ch, putdat);
  102d32:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d35:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d39:	89 1c 24             	mov    %ebx,(%esp)
  102d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  102d3f:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102d41:	8b 45 10             	mov    0x10(%ebp),%eax
  102d44:	8d 50 01             	lea    0x1(%eax),%edx
  102d47:	89 55 10             	mov    %edx,0x10(%ebp)
  102d4a:	0f b6 00             	movzbl (%eax),%eax
  102d4d:	0f b6 d8             	movzbl %al,%ebx
  102d50:	83 fb 25             	cmp    $0x25,%ebx
  102d53:	75 d5                	jne    102d2a <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
  102d55:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  102d59:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  102d60:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102d63:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  102d66:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102d6d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102d70:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  102d73:	8b 45 10             	mov    0x10(%ebp),%eax
  102d76:	8d 50 01             	lea    0x1(%eax),%edx
  102d79:	89 55 10             	mov    %edx,0x10(%ebp)
  102d7c:	0f b6 00             	movzbl (%eax),%eax
  102d7f:	0f b6 d8             	movzbl %al,%ebx
  102d82:	8d 43 dd             	lea    -0x23(%ebx),%eax
  102d85:	83 f8 55             	cmp    $0x55,%eax
  102d88:	0f 87 37 03 00 00    	ja     1030c5 <vprintfmt+0x3a5>
  102d8e:	8b 04 85 74 3e 10 00 	mov    0x103e74(,%eax,4),%eax
  102d95:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  102d97:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  102d9b:	eb d6                	jmp    102d73 <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  102d9d:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  102da1:	eb d0                	jmp    102d73 <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  102da3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  102daa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102dad:	89 d0                	mov    %edx,%eax
  102daf:	c1 e0 02             	shl    $0x2,%eax
  102db2:	01 d0                	add    %edx,%eax
  102db4:	01 c0                	add    %eax,%eax
  102db6:	01 d8                	add    %ebx,%eax
  102db8:	83 e8 30             	sub    $0x30,%eax
  102dbb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  102dbe:	8b 45 10             	mov    0x10(%ebp),%eax
  102dc1:	0f b6 00             	movzbl (%eax),%eax
  102dc4:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  102dc7:	83 fb 2f             	cmp    $0x2f,%ebx
  102dca:	7e 38                	jle    102e04 <vprintfmt+0xe4>
  102dcc:	83 fb 39             	cmp    $0x39,%ebx
  102dcf:	7f 33                	jg     102e04 <vprintfmt+0xe4>
            for (precision = 0; ; ++ fmt) {
  102dd1:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
  102dd4:	eb d4                	jmp    102daa <vprintfmt+0x8a>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  102dd6:	8b 45 14             	mov    0x14(%ebp),%eax
  102dd9:	8d 50 04             	lea    0x4(%eax),%edx
  102ddc:	89 55 14             	mov    %edx,0x14(%ebp)
  102ddf:	8b 00                	mov    (%eax),%eax
  102de1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  102de4:	eb 1f                	jmp    102e05 <vprintfmt+0xe5>

        case '.':
            if (width < 0)
  102de6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102dea:	79 87                	jns    102d73 <vprintfmt+0x53>
                width = 0;
  102dec:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  102df3:	e9 7b ff ff ff       	jmp    102d73 <vprintfmt+0x53>

        case '#':
            altflag = 1;
  102df8:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  102dff:	e9 6f ff ff ff       	jmp    102d73 <vprintfmt+0x53>
            goto process_precision;
  102e04:	90                   	nop

        process_precision:
            if (width < 0)
  102e05:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102e09:	0f 89 64 ff ff ff    	jns    102d73 <vprintfmt+0x53>
                width = precision, precision = -1;
  102e0f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102e12:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102e15:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  102e1c:	e9 52 ff ff ff       	jmp    102d73 <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  102e21:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
  102e24:	e9 4a ff ff ff       	jmp    102d73 <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  102e29:	8b 45 14             	mov    0x14(%ebp),%eax
  102e2c:	8d 50 04             	lea    0x4(%eax),%edx
  102e2f:	89 55 14             	mov    %edx,0x14(%ebp)
  102e32:	8b 00                	mov    (%eax),%eax
  102e34:	8b 55 0c             	mov    0xc(%ebp),%edx
  102e37:	89 54 24 04          	mov    %edx,0x4(%esp)
  102e3b:	89 04 24             	mov    %eax,(%esp)
  102e3e:	8b 45 08             	mov    0x8(%ebp),%eax
  102e41:	ff d0                	call   *%eax
            break;
  102e43:	e9 a4 02 00 00       	jmp    1030ec <vprintfmt+0x3cc>

        // error message
        case 'e':
            err = va_arg(ap, int);
  102e48:	8b 45 14             	mov    0x14(%ebp),%eax
  102e4b:	8d 50 04             	lea    0x4(%eax),%edx
  102e4e:	89 55 14             	mov    %edx,0x14(%ebp)
  102e51:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  102e53:	85 db                	test   %ebx,%ebx
  102e55:	79 02                	jns    102e59 <vprintfmt+0x139>
                err = -err;
  102e57:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  102e59:	83 fb 06             	cmp    $0x6,%ebx
  102e5c:	7f 0b                	jg     102e69 <vprintfmt+0x149>
  102e5e:	8b 34 9d 34 3e 10 00 	mov    0x103e34(,%ebx,4),%esi
  102e65:	85 f6                	test   %esi,%esi
  102e67:	75 23                	jne    102e8c <vprintfmt+0x16c>
                printfmt(putch, putdat, "error %d", err);
  102e69:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  102e6d:	c7 44 24 08 61 3e 10 	movl   $0x103e61,0x8(%esp)
  102e74:	00 
  102e75:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e78:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e7c:	8b 45 08             	mov    0x8(%ebp),%eax
  102e7f:	89 04 24             	mov    %eax,(%esp)
  102e82:	e8 68 fe ff ff       	call   102cef <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  102e87:	e9 60 02 00 00       	jmp    1030ec <vprintfmt+0x3cc>
                printfmt(putch, putdat, "%s", p);
  102e8c:	89 74 24 0c          	mov    %esi,0xc(%esp)
  102e90:	c7 44 24 08 6a 3e 10 	movl   $0x103e6a,0x8(%esp)
  102e97:	00 
  102e98:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e9b:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e9f:	8b 45 08             	mov    0x8(%ebp),%eax
  102ea2:	89 04 24             	mov    %eax,(%esp)
  102ea5:	e8 45 fe ff ff       	call   102cef <printfmt>
            break;
  102eaa:	e9 3d 02 00 00       	jmp    1030ec <vprintfmt+0x3cc>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  102eaf:	8b 45 14             	mov    0x14(%ebp),%eax
  102eb2:	8d 50 04             	lea    0x4(%eax),%edx
  102eb5:	89 55 14             	mov    %edx,0x14(%ebp)
  102eb8:	8b 30                	mov    (%eax),%esi
  102eba:	85 f6                	test   %esi,%esi
  102ebc:	75 05                	jne    102ec3 <vprintfmt+0x1a3>
                p = "(null)";
  102ebe:	be 6d 3e 10 00       	mov    $0x103e6d,%esi
            }
            if (width > 0 && padc != '-') {
  102ec3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102ec7:	7e 76                	jle    102f3f <vprintfmt+0x21f>
  102ec9:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  102ecd:	74 70                	je     102f3f <vprintfmt+0x21f>
                for (width -= strnlen(p, precision); width > 0; width --) {
  102ecf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102ed2:	89 44 24 04          	mov    %eax,0x4(%esp)
  102ed6:	89 34 24             	mov    %esi,(%esp)
  102ed9:	e8 16 03 00 00       	call   1031f4 <strnlen>
  102ede:	89 c2                	mov    %eax,%edx
  102ee0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102ee3:	29 d0                	sub    %edx,%eax
  102ee5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102ee8:	eb 16                	jmp    102f00 <vprintfmt+0x1e0>
                    putch(padc, putdat);
  102eea:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  102eee:	8b 55 0c             	mov    0xc(%ebp),%edx
  102ef1:	89 54 24 04          	mov    %edx,0x4(%esp)
  102ef5:	89 04 24             	mov    %eax,(%esp)
  102ef8:	8b 45 08             	mov    0x8(%ebp),%eax
  102efb:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
  102efd:	ff 4d e8             	decl   -0x18(%ebp)
  102f00:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102f04:	7f e4                	jg     102eea <vprintfmt+0x1ca>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102f06:	eb 37                	jmp    102f3f <vprintfmt+0x21f>
                if (altflag && (ch < ' ' || ch > '~')) {
  102f08:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  102f0c:	74 1f                	je     102f2d <vprintfmt+0x20d>
  102f0e:	83 fb 1f             	cmp    $0x1f,%ebx
  102f11:	7e 05                	jle    102f18 <vprintfmt+0x1f8>
  102f13:	83 fb 7e             	cmp    $0x7e,%ebx
  102f16:	7e 15                	jle    102f2d <vprintfmt+0x20d>
                    putch('?', putdat);
  102f18:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f1b:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f1f:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  102f26:	8b 45 08             	mov    0x8(%ebp),%eax
  102f29:	ff d0                	call   *%eax
  102f2b:	eb 0f                	jmp    102f3c <vprintfmt+0x21c>
                }
                else {
                    putch(ch, putdat);
  102f2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f30:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f34:	89 1c 24             	mov    %ebx,(%esp)
  102f37:	8b 45 08             	mov    0x8(%ebp),%eax
  102f3a:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102f3c:	ff 4d e8             	decl   -0x18(%ebp)
  102f3f:	89 f0                	mov    %esi,%eax
  102f41:	8d 70 01             	lea    0x1(%eax),%esi
  102f44:	0f b6 00             	movzbl (%eax),%eax
  102f47:	0f be d8             	movsbl %al,%ebx
  102f4a:	85 db                	test   %ebx,%ebx
  102f4c:	74 27                	je     102f75 <vprintfmt+0x255>
  102f4e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102f52:	78 b4                	js     102f08 <vprintfmt+0x1e8>
  102f54:	ff 4d e4             	decl   -0x1c(%ebp)
  102f57:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102f5b:	79 ab                	jns    102f08 <vprintfmt+0x1e8>
                }
            }
            for (; width > 0; width --) {
  102f5d:	eb 16                	jmp    102f75 <vprintfmt+0x255>
                putch(' ', putdat);
  102f5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f62:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f66:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  102f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  102f70:	ff d0                	call   *%eax
            for (; width > 0; width --) {
  102f72:	ff 4d e8             	decl   -0x18(%ebp)
  102f75:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102f79:	7f e4                	jg     102f5f <vprintfmt+0x23f>
            }
            break;
  102f7b:	e9 6c 01 00 00       	jmp    1030ec <vprintfmt+0x3cc>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  102f80:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102f83:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f87:	8d 45 14             	lea    0x14(%ebp),%eax
  102f8a:	89 04 24             	mov    %eax,(%esp)
  102f8d:	e8 16 fd ff ff       	call   102ca8 <getint>
  102f92:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f95:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  102f98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f9b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102f9e:	85 d2                	test   %edx,%edx
  102fa0:	79 26                	jns    102fc8 <vprintfmt+0x2a8>
                putch('-', putdat);
  102fa2:	8b 45 0c             	mov    0xc(%ebp),%eax
  102fa5:	89 44 24 04          	mov    %eax,0x4(%esp)
  102fa9:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  102fb0:	8b 45 08             	mov    0x8(%ebp),%eax
  102fb3:	ff d0                	call   *%eax
                num = -(long long)num;
  102fb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102fb8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102fbb:	f7 d8                	neg    %eax
  102fbd:	83 d2 00             	adc    $0x0,%edx
  102fc0:	f7 da                	neg    %edx
  102fc2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102fc5:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  102fc8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102fcf:	e9 a8 00 00 00       	jmp    10307c <vprintfmt+0x35c>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  102fd4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102fd7:	89 44 24 04          	mov    %eax,0x4(%esp)
  102fdb:	8d 45 14             	lea    0x14(%ebp),%eax
  102fde:	89 04 24             	mov    %eax,(%esp)
  102fe1:	e8 73 fc ff ff       	call   102c59 <getuint>
  102fe6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102fe9:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  102fec:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102ff3:	e9 84 00 00 00       	jmp    10307c <vprintfmt+0x35c>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  102ff8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102ffb:	89 44 24 04          	mov    %eax,0x4(%esp)
  102fff:	8d 45 14             	lea    0x14(%ebp),%eax
  103002:	89 04 24             	mov    %eax,(%esp)
  103005:	e8 4f fc ff ff       	call   102c59 <getuint>
  10300a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10300d:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  103010:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  103017:	eb 63                	jmp    10307c <vprintfmt+0x35c>

        // pointer
        case 'p':
            putch('0', putdat);
  103019:	8b 45 0c             	mov    0xc(%ebp),%eax
  10301c:	89 44 24 04          	mov    %eax,0x4(%esp)
  103020:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  103027:	8b 45 08             	mov    0x8(%ebp),%eax
  10302a:	ff d0                	call   *%eax
            putch('x', putdat);
  10302c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10302f:	89 44 24 04          	mov    %eax,0x4(%esp)
  103033:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  10303a:	8b 45 08             	mov    0x8(%ebp),%eax
  10303d:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  10303f:	8b 45 14             	mov    0x14(%ebp),%eax
  103042:	8d 50 04             	lea    0x4(%eax),%edx
  103045:	89 55 14             	mov    %edx,0x14(%ebp)
  103048:	8b 00                	mov    (%eax),%eax
  10304a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10304d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  103054:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  10305b:	eb 1f                	jmp    10307c <vprintfmt+0x35c>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  10305d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103060:	89 44 24 04          	mov    %eax,0x4(%esp)
  103064:	8d 45 14             	lea    0x14(%ebp),%eax
  103067:	89 04 24             	mov    %eax,(%esp)
  10306a:	e8 ea fb ff ff       	call   102c59 <getuint>
  10306f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103072:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  103075:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  10307c:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  103080:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103083:	89 54 24 18          	mov    %edx,0x18(%esp)
  103087:	8b 55 e8             	mov    -0x18(%ebp),%edx
  10308a:	89 54 24 14          	mov    %edx,0x14(%esp)
  10308e:	89 44 24 10          	mov    %eax,0x10(%esp)
  103092:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103095:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103098:	89 44 24 08          	mov    %eax,0x8(%esp)
  10309c:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1030a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1030a7:	8b 45 08             	mov    0x8(%ebp),%eax
  1030aa:	89 04 24             	mov    %eax,(%esp)
  1030ad:	e8 a5 fa ff ff       	call   102b57 <printnum>
            break;
  1030b2:	eb 38                	jmp    1030ec <vprintfmt+0x3cc>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  1030b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1030bb:	89 1c 24             	mov    %ebx,(%esp)
  1030be:	8b 45 08             	mov    0x8(%ebp),%eax
  1030c1:	ff d0                	call   *%eax
            break;
  1030c3:	eb 27                	jmp    1030ec <vprintfmt+0x3cc>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  1030c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1030cc:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  1030d3:	8b 45 08             	mov    0x8(%ebp),%eax
  1030d6:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  1030d8:	ff 4d 10             	decl   0x10(%ebp)
  1030db:	eb 03                	jmp    1030e0 <vprintfmt+0x3c0>
  1030dd:	ff 4d 10             	decl   0x10(%ebp)
  1030e0:	8b 45 10             	mov    0x10(%ebp),%eax
  1030e3:	48                   	dec    %eax
  1030e4:	0f b6 00             	movzbl (%eax),%eax
  1030e7:	3c 25                	cmp    $0x25,%al
  1030e9:	75 f2                	jne    1030dd <vprintfmt+0x3bd>
                /* do nothing */;
            break;
  1030eb:	90                   	nop
    while (1) {
  1030ec:	e9 37 fc ff ff       	jmp    102d28 <vprintfmt+0x8>
                return;
  1030f1:	90                   	nop
        }
    }
}
  1030f2:	83 c4 40             	add    $0x40,%esp
  1030f5:	5b                   	pop    %ebx
  1030f6:	5e                   	pop    %esi
  1030f7:	5d                   	pop    %ebp
  1030f8:	c3                   	ret    

001030f9 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  1030f9:	55                   	push   %ebp
  1030fa:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  1030fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030ff:	8b 40 08             	mov    0x8(%eax),%eax
  103102:	8d 50 01             	lea    0x1(%eax),%edx
  103105:	8b 45 0c             	mov    0xc(%ebp),%eax
  103108:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  10310b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10310e:	8b 10                	mov    (%eax),%edx
  103110:	8b 45 0c             	mov    0xc(%ebp),%eax
  103113:	8b 40 04             	mov    0x4(%eax),%eax
  103116:	39 c2                	cmp    %eax,%edx
  103118:	73 12                	jae    10312c <sprintputch+0x33>
        *b->buf ++ = ch;
  10311a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10311d:	8b 00                	mov    (%eax),%eax
  10311f:	8d 48 01             	lea    0x1(%eax),%ecx
  103122:	8b 55 0c             	mov    0xc(%ebp),%edx
  103125:	89 0a                	mov    %ecx,(%edx)
  103127:	8b 55 08             	mov    0x8(%ebp),%edx
  10312a:	88 10                	mov    %dl,(%eax)
    }
}
  10312c:	90                   	nop
  10312d:	5d                   	pop    %ebp
  10312e:	c3                   	ret    

0010312f <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  10312f:	55                   	push   %ebp
  103130:	89 e5                	mov    %esp,%ebp
  103132:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  103135:	8d 45 14             	lea    0x14(%ebp),%eax
  103138:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  10313b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10313e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103142:	8b 45 10             	mov    0x10(%ebp),%eax
  103145:	89 44 24 08          	mov    %eax,0x8(%esp)
  103149:	8b 45 0c             	mov    0xc(%ebp),%eax
  10314c:	89 44 24 04          	mov    %eax,0x4(%esp)
  103150:	8b 45 08             	mov    0x8(%ebp),%eax
  103153:	89 04 24             	mov    %eax,(%esp)
  103156:	e8 0a 00 00 00       	call   103165 <vsnprintf>
  10315b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10315e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103161:	89 ec                	mov    %ebp,%esp
  103163:	5d                   	pop    %ebp
  103164:	c3                   	ret    

00103165 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  103165:	55                   	push   %ebp
  103166:	89 e5                	mov    %esp,%ebp
  103168:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  10316b:	8b 45 08             	mov    0x8(%ebp),%eax
  10316e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103171:	8b 45 0c             	mov    0xc(%ebp),%eax
  103174:	8d 50 ff             	lea    -0x1(%eax),%edx
  103177:	8b 45 08             	mov    0x8(%ebp),%eax
  10317a:	01 d0                	add    %edx,%eax
  10317c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10317f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  103186:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10318a:	74 0a                	je     103196 <vsnprintf+0x31>
  10318c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10318f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103192:	39 c2                	cmp    %eax,%edx
  103194:	76 07                	jbe    10319d <vsnprintf+0x38>
        return -E_INVAL;
  103196:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  10319b:	eb 2a                	jmp    1031c7 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  10319d:	8b 45 14             	mov    0x14(%ebp),%eax
  1031a0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1031a4:	8b 45 10             	mov    0x10(%ebp),%eax
  1031a7:	89 44 24 08          	mov    %eax,0x8(%esp)
  1031ab:	8d 45 ec             	lea    -0x14(%ebp),%eax
  1031ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  1031b2:	c7 04 24 f9 30 10 00 	movl   $0x1030f9,(%esp)
  1031b9:	e8 62 fb ff ff       	call   102d20 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  1031be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1031c1:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  1031c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1031c7:	89 ec                	mov    %ebp,%esp
  1031c9:	5d                   	pop    %ebp
  1031ca:	c3                   	ret    

001031cb <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  1031cb:	55                   	push   %ebp
  1031cc:	89 e5                	mov    %esp,%ebp
  1031ce:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  1031d1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  1031d8:	eb 03                	jmp    1031dd <strlen+0x12>
        cnt ++;
  1031da:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
  1031dd:	8b 45 08             	mov    0x8(%ebp),%eax
  1031e0:	8d 50 01             	lea    0x1(%eax),%edx
  1031e3:	89 55 08             	mov    %edx,0x8(%ebp)
  1031e6:	0f b6 00             	movzbl (%eax),%eax
  1031e9:	84 c0                	test   %al,%al
  1031eb:	75 ed                	jne    1031da <strlen+0xf>
    }
    return cnt;
  1031ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1031f0:	89 ec                	mov    %ebp,%esp
  1031f2:	5d                   	pop    %ebp
  1031f3:	c3                   	ret    

001031f4 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  1031f4:	55                   	push   %ebp
  1031f5:	89 e5                	mov    %esp,%ebp
  1031f7:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  1031fa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  103201:	eb 03                	jmp    103206 <strnlen+0x12>
        cnt ++;
  103203:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  103206:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103209:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10320c:	73 10                	jae    10321e <strnlen+0x2a>
  10320e:	8b 45 08             	mov    0x8(%ebp),%eax
  103211:	8d 50 01             	lea    0x1(%eax),%edx
  103214:	89 55 08             	mov    %edx,0x8(%ebp)
  103217:	0f b6 00             	movzbl (%eax),%eax
  10321a:	84 c0                	test   %al,%al
  10321c:	75 e5                	jne    103203 <strnlen+0xf>
    }
    return cnt;
  10321e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  103221:	89 ec                	mov    %ebp,%esp
  103223:	5d                   	pop    %ebp
  103224:	c3                   	ret    

00103225 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  103225:	55                   	push   %ebp
  103226:	89 e5                	mov    %esp,%ebp
  103228:	57                   	push   %edi
  103229:	56                   	push   %esi
  10322a:	83 ec 20             	sub    $0x20,%esp
  10322d:	8b 45 08             	mov    0x8(%ebp),%eax
  103230:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103233:	8b 45 0c             	mov    0xc(%ebp),%eax
  103236:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  103239:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10323c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10323f:	89 d1                	mov    %edx,%ecx
  103241:	89 c2                	mov    %eax,%edx
  103243:	89 ce                	mov    %ecx,%esi
  103245:	89 d7                	mov    %edx,%edi
  103247:	ac                   	lods   %ds:(%esi),%al
  103248:	aa                   	stos   %al,%es:(%edi)
  103249:	84 c0                	test   %al,%al
  10324b:	75 fa                	jne    103247 <strcpy+0x22>
  10324d:	89 fa                	mov    %edi,%edx
  10324f:	89 f1                	mov    %esi,%ecx
  103251:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  103254:	89 55 e8             	mov    %edx,-0x18(%ebp)
  103257:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  10325a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  10325d:	83 c4 20             	add    $0x20,%esp
  103260:	5e                   	pop    %esi
  103261:	5f                   	pop    %edi
  103262:	5d                   	pop    %ebp
  103263:	c3                   	ret    

00103264 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  103264:	55                   	push   %ebp
  103265:	89 e5                	mov    %esp,%ebp
  103267:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  10326a:	8b 45 08             	mov    0x8(%ebp),%eax
  10326d:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  103270:	eb 1e                	jmp    103290 <strncpy+0x2c>
        if ((*p = *src) != '\0') {
  103272:	8b 45 0c             	mov    0xc(%ebp),%eax
  103275:	0f b6 10             	movzbl (%eax),%edx
  103278:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10327b:	88 10                	mov    %dl,(%eax)
  10327d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103280:	0f b6 00             	movzbl (%eax),%eax
  103283:	84 c0                	test   %al,%al
  103285:	74 03                	je     10328a <strncpy+0x26>
            src ++;
  103287:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
  10328a:	ff 45 fc             	incl   -0x4(%ebp)
  10328d:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
  103290:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103294:	75 dc                	jne    103272 <strncpy+0xe>
    }
    return dst;
  103296:	8b 45 08             	mov    0x8(%ebp),%eax
}
  103299:	89 ec                	mov    %ebp,%esp
  10329b:	5d                   	pop    %ebp
  10329c:	c3                   	ret    

0010329d <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  10329d:	55                   	push   %ebp
  10329e:	89 e5                	mov    %esp,%ebp
  1032a0:	57                   	push   %edi
  1032a1:	56                   	push   %esi
  1032a2:	83 ec 20             	sub    $0x20,%esp
  1032a5:	8b 45 08             	mov    0x8(%ebp),%eax
  1032a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1032ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  1032b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1032b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1032b7:	89 d1                	mov    %edx,%ecx
  1032b9:	89 c2                	mov    %eax,%edx
  1032bb:	89 ce                	mov    %ecx,%esi
  1032bd:	89 d7                	mov    %edx,%edi
  1032bf:	ac                   	lods   %ds:(%esi),%al
  1032c0:	ae                   	scas   %es:(%edi),%al
  1032c1:	75 08                	jne    1032cb <strcmp+0x2e>
  1032c3:	84 c0                	test   %al,%al
  1032c5:	75 f8                	jne    1032bf <strcmp+0x22>
  1032c7:	31 c0                	xor    %eax,%eax
  1032c9:	eb 04                	jmp    1032cf <strcmp+0x32>
  1032cb:	19 c0                	sbb    %eax,%eax
  1032cd:	0c 01                	or     $0x1,%al
  1032cf:	89 fa                	mov    %edi,%edx
  1032d1:	89 f1                	mov    %esi,%ecx
  1032d3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1032d6:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  1032d9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  1032dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  1032df:	83 c4 20             	add    $0x20,%esp
  1032e2:	5e                   	pop    %esi
  1032e3:	5f                   	pop    %edi
  1032e4:	5d                   	pop    %ebp
  1032e5:	c3                   	ret    

001032e6 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  1032e6:	55                   	push   %ebp
  1032e7:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  1032e9:	eb 09                	jmp    1032f4 <strncmp+0xe>
        n --, s1 ++, s2 ++;
  1032eb:	ff 4d 10             	decl   0x10(%ebp)
  1032ee:	ff 45 08             	incl   0x8(%ebp)
  1032f1:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  1032f4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1032f8:	74 1a                	je     103314 <strncmp+0x2e>
  1032fa:	8b 45 08             	mov    0x8(%ebp),%eax
  1032fd:	0f b6 00             	movzbl (%eax),%eax
  103300:	84 c0                	test   %al,%al
  103302:	74 10                	je     103314 <strncmp+0x2e>
  103304:	8b 45 08             	mov    0x8(%ebp),%eax
  103307:	0f b6 10             	movzbl (%eax),%edx
  10330a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10330d:	0f b6 00             	movzbl (%eax),%eax
  103310:	38 c2                	cmp    %al,%dl
  103312:	74 d7                	je     1032eb <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  103314:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103318:	74 18                	je     103332 <strncmp+0x4c>
  10331a:	8b 45 08             	mov    0x8(%ebp),%eax
  10331d:	0f b6 00             	movzbl (%eax),%eax
  103320:	0f b6 d0             	movzbl %al,%edx
  103323:	8b 45 0c             	mov    0xc(%ebp),%eax
  103326:	0f b6 00             	movzbl (%eax),%eax
  103329:	0f b6 c8             	movzbl %al,%ecx
  10332c:	89 d0                	mov    %edx,%eax
  10332e:	29 c8                	sub    %ecx,%eax
  103330:	eb 05                	jmp    103337 <strncmp+0x51>
  103332:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103337:	5d                   	pop    %ebp
  103338:	c3                   	ret    

00103339 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  103339:	55                   	push   %ebp
  10333a:	89 e5                	mov    %esp,%ebp
  10333c:	83 ec 04             	sub    $0x4,%esp
  10333f:	8b 45 0c             	mov    0xc(%ebp),%eax
  103342:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  103345:	eb 13                	jmp    10335a <strchr+0x21>
        if (*s == c) {
  103347:	8b 45 08             	mov    0x8(%ebp),%eax
  10334a:	0f b6 00             	movzbl (%eax),%eax
  10334d:	38 45 fc             	cmp    %al,-0x4(%ebp)
  103350:	75 05                	jne    103357 <strchr+0x1e>
            return (char *)s;
  103352:	8b 45 08             	mov    0x8(%ebp),%eax
  103355:	eb 12                	jmp    103369 <strchr+0x30>
        }
        s ++;
  103357:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  10335a:	8b 45 08             	mov    0x8(%ebp),%eax
  10335d:	0f b6 00             	movzbl (%eax),%eax
  103360:	84 c0                	test   %al,%al
  103362:	75 e3                	jne    103347 <strchr+0xe>
    }
    return NULL;
  103364:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103369:	89 ec                	mov    %ebp,%esp
  10336b:	5d                   	pop    %ebp
  10336c:	c3                   	ret    

0010336d <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  10336d:	55                   	push   %ebp
  10336e:	89 e5                	mov    %esp,%ebp
  103370:	83 ec 04             	sub    $0x4,%esp
  103373:	8b 45 0c             	mov    0xc(%ebp),%eax
  103376:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  103379:	eb 0e                	jmp    103389 <strfind+0x1c>
        if (*s == c) {
  10337b:	8b 45 08             	mov    0x8(%ebp),%eax
  10337e:	0f b6 00             	movzbl (%eax),%eax
  103381:	38 45 fc             	cmp    %al,-0x4(%ebp)
  103384:	74 0f                	je     103395 <strfind+0x28>
            break;
        }
        s ++;
  103386:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  103389:	8b 45 08             	mov    0x8(%ebp),%eax
  10338c:	0f b6 00             	movzbl (%eax),%eax
  10338f:	84 c0                	test   %al,%al
  103391:	75 e8                	jne    10337b <strfind+0xe>
  103393:	eb 01                	jmp    103396 <strfind+0x29>
            break;
  103395:	90                   	nop
    }
    return (char *)s;
  103396:	8b 45 08             	mov    0x8(%ebp),%eax
}
  103399:	89 ec                	mov    %ebp,%esp
  10339b:	5d                   	pop    %ebp
  10339c:	c3                   	ret    

0010339d <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  10339d:	55                   	push   %ebp
  10339e:	89 e5                	mov    %esp,%ebp
  1033a0:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  1033a3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  1033aa:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  1033b1:	eb 03                	jmp    1033b6 <strtol+0x19>
        s ++;
  1033b3:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  1033b6:	8b 45 08             	mov    0x8(%ebp),%eax
  1033b9:	0f b6 00             	movzbl (%eax),%eax
  1033bc:	3c 20                	cmp    $0x20,%al
  1033be:	74 f3                	je     1033b3 <strtol+0x16>
  1033c0:	8b 45 08             	mov    0x8(%ebp),%eax
  1033c3:	0f b6 00             	movzbl (%eax),%eax
  1033c6:	3c 09                	cmp    $0x9,%al
  1033c8:	74 e9                	je     1033b3 <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
  1033ca:	8b 45 08             	mov    0x8(%ebp),%eax
  1033cd:	0f b6 00             	movzbl (%eax),%eax
  1033d0:	3c 2b                	cmp    $0x2b,%al
  1033d2:	75 05                	jne    1033d9 <strtol+0x3c>
        s ++;
  1033d4:	ff 45 08             	incl   0x8(%ebp)
  1033d7:	eb 14                	jmp    1033ed <strtol+0x50>
    }
    else if (*s == '-') {
  1033d9:	8b 45 08             	mov    0x8(%ebp),%eax
  1033dc:	0f b6 00             	movzbl (%eax),%eax
  1033df:	3c 2d                	cmp    $0x2d,%al
  1033e1:	75 0a                	jne    1033ed <strtol+0x50>
        s ++, neg = 1;
  1033e3:	ff 45 08             	incl   0x8(%ebp)
  1033e6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  1033ed:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1033f1:	74 06                	je     1033f9 <strtol+0x5c>
  1033f3:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  1033f7:	75 22                	jne    10341b <strtol+0x7e>
  1033f9:	8b 45 08             	mov    0x8(%ebp),%eax
  1033fc:	0f b6 00             	movzbl (%eax),%eax
  1033ff:	3c 30                	cmp    $0x30,%al
  103401:	75 18                	jne    10341b <strtol+0x7e>
  103403:	8b 45 08             	mov    0x8(%ebp),%eax
  103406:	40                   	inc    %eax
  103407:	0f b6 00             	movzbl (%eax),%eax
  10340a:	3c 78                	cmp    $0x78,%al
  10340c:	75 0d                	jne    10341b <strtol+0x7e>
        s += 2, base = 16;
  10340e:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  103412:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  103419:	eb 29                	jmp    103444 <strtol+0xa7>
    }
    else if (base == 0 && s[0] == '0') {
  10341b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10341f:	75 16                	jne    103437 <strtol+0x9a>
  103421:	8b 45 08             	mov    0x8(%ebp),%eax
  103424:	0f b6 00             	movzbl (%eax),%eax
  103427:	3c 30                	cmp    $0x30,%al
  103429:	75 0c                	jne    103437 <strtol+0x9a>
        s ++, base = 8;
  10342b:	ff 45 08             	incl   0x8(%ebp)
  10342e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  103435:	eb 0d                	jmp    103444 <strtol+0xa7>
    }
    else if (base == 0) {
  103437:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10343b:	75 07                	jne    103444 <strtol+0xa7>
        base = 10;
  10343d:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  103444:	8b 45 08             	mov    0x8(%ebp),%eax
  103447:	0f b6 00             	movzbl (%eax),%eax
  10344a:	3c 2f                	cmp    $0x2f,%al
  10344c:	7e 1b                	jle    103469 <strtol+0xcc>
  10344e:	8b 45 08             	mov    0x8(%ebp),%eax
  103451:	0f b6 00             	movzbl (%eax),%eax
  103454:	3c 39                	cmp    $0x39,%al
  103456:	7f 11                	jg     103469 <strtol+0xcc>
            dig = *s - '0';
  103458:	8b 45 08             	mov    0x8(%ebp),%eax
  10345b:	0f b6 00             	movzbl (%eax),%eax
  10345e:	0f be c0             	movsbl %al,%eax
  103461:	83 e8 30             	sub    $0x30,%eax
  103464:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103467:	eb 48                	jmp    1034b1 <strtol+0x114>
        }
        else if (*s >= 'a' && *s <= 'z') {
  103469:	8b 45 08             	mov    0x8(%ebp),%eax
  10346c:	0f b6 00             	movzbl (%eax),%eax
  10346f:	3c 60                	cmp    $0x60,%al
  103471:	7e 1b                	jle    10348e <strtol+0xf1>
  103473:	8b 45 08             	mov    0x8(%ebp),%eax
  103476:	0f b6 00             	movzbl (%eax),%eax
  103479:	3c 7a                	cmp    $0x7a,%al
  10347b:	7f 11                	jg     10348e <strtol+0xf1>
            dig = *s - 'a' + 10;
  10347d:	8b 45 08             	mov    0x8(%ebp),%eax
  103480:	0f b6 00             	movzbl (%eax),%eax
  103483:	0f be c0             	movsbl %al,%eax
  103486:	83 e8 57             	sub    $0x57,%eax
  103489:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10348c:	eb 23                	jmp    1034b1 <strtol+0x114>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  10348e:	8b 45 08             	mov    0x8(%ebp),%eax
  103491:	0f b6 00             	movzbl (%eax),%eax
  103494:	3c 40                	cmp    $0x40,%al
  103496:	7e 3b                	jle    1034d3 <strtol+0x136>
  103498:	8b 45 08             	mov    0x8(%ebp),%eax
  10349b:	0f b6 00             	movzbl (%eax),%eax
  10349e:	3c 5a                	cmp    $0x5a,%al
  1034a0:	7f 31                	jg     1034d3 <strtol+0x136>
            dig = *s - 'A' + 10;
  1034a2:	8b 45 08             	mov    0x8(%ebp),%eax
  1034a5:	0f b6 00             	movzbl (%eax),%eax
  1034a8:	0f be c0             	movsbl %al,%eax
  1034ab:	83 e8 37             	sub    $0x37,%eax
  1034ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  1034b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1034b4:	3b 45 10             	cmp    0x10(%ebp),%eax
  1034b7:	7d 19                	jge    1034d2 <strtol+0x135>
            break;
        }
        s ++, val = (val * base) + dig;
  1034b9:	ff 45 08             	incl   0x8(%ebp)
  1034bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1034bf:	0f af 45 10          	imul   0x10(%ebp),%eax
  1034c3:	89 c2                	mov    %eax,%edx
  1034c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1034c8:	01 d0                	add    %edx,%eax
  1034ca:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
  1034cd:	e9 72 ff ff ff       	jmp    103444 <strtol+0xa7>
            break;
  1034d2:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
  1034d3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1034d7:	74 08                	je     1034e1 <strtol+0x144>
        *endptr = (char *) s;
  1034d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034dc:	8b 55 08             	mov    0x8(%ebp),%edx
  1034df:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  1034e1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  1034e5:	74 07                	je     1034ee <strtol+0x151>
  1034e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1034ea:	f7 d8                	neg    %eax
  1034ec:	eb 03                	jmp    1034f1 <strtol+0x154>
  1034ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  1034f1:	89 ec                	mov    %ebp,%esp
  1034f3:	5d                   	pop    %ebp
  1034f4:	c3                   	ret    

001034f5 <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  1034f5:	55                   	push   %ebp
  1034f6:	89 e5                	mov    %esp,%ebp
  1034f8:	83 ec 28             	sub    $0x28,%esp
  1034fb:	89 7d fc             	mov    %edi,-0x4(%ebp)
  1034fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  103501:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  103504:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  103508:	8b 45 08             	mov    0x8(%ebp),%eax
  10350b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  10350e:	88 55 f7             	mov    %dl,-0x9(%ebp)
  103511:	8b 45 10             	mov    0x10(%ebp),%eax
  103514:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  103517:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  10351a:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  10351e:	8b 55 f8             	mov    -0x8(%ebp),%edx
  103521:	89 d7                	mov    %edx,%edi
  103523:	f3 aa                	rep stos %al,%es:(%edi)
  103525:	89 fa                	mov    %edi,%edx
  103527:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  10352a:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  10352d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  103530:	8b 7d fc             	mov    -0x4(%ebp),%edi
  103533:	89 ec                	mov    %ebp,%esp
  103535:	5d                   	pop    %ebp
  103536:	c3                   	ret    

00103537 <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  103537:	55                   	push   %ebp
  103538:	89 e5                	mov    %esp,%ebp
  10353a:	57                   	push   %edi
  10353b:	56                   	push   %esi
  10353c:	53                   	push   %ebx
  10353d:	83 ec 30             	sub    $0x30,%esp
  103540:	8b 45 08             	mov    0x8(%ebp),%eax
  103543:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103546:	8b 45 0c             	mov    0xc(%ebp),%eax
  103549:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10354c:	8b 45 10             	mov    0x10(%ebp),%eax
  10354f:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  103552:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103555:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  103558:	73 42                	jae    10359c <memmove+0x65>
  10355a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10355d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103560:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103563:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103566:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103569:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  10356c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10356f:	c1 e8 02             	shr    $0x2,%eax
  103572:	89 c1                	mov    %eax,%ecx
    asm volatile (
  103574:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103577:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10357a:	89 d7                	mov    %edx,%edi
  10357c:	89 c6                	mov    %eax,%esi
  10357e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  103580:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  103583:	83 e1 03             	and    $0x3,%ecx
  103586:	74 02                	je     10358a <memmove+0x53>
  103588:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  10358a:	89 f0                	mov    %esi,%eax
  10358c:	89 fa                	mov    %edi,%edx
  10358e:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  103591:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  103594:	89 45 d0             	mov    %eax,-0x30(%ebp)
            : "memory");
    return dst;
  103597:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        return __memcpy(dst, src, n);
  10359a:	eb 36                	jmp    1035d2 <memmove+0x9b>
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  10359c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10359f:	8d 50 ff             	lea    -0x1(%eax),%edx
  1035a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1035a5:	01 c2                	add    %eax,%edx
  1035a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1035aa:	8d 48 ff             	lea    -0x1(%eax),%ecx
  1035ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1035b0:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  1035b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1035b6:	89 c1                	mov    %eax,%ecx
  1035b8:	89 d8                	mov    %ebx,%eax
  1035ba:	89 d6                	mov    %edx,%esi
  1035bc:	89 c7                	mov    %eax,%edi
  1035be:	fd                   	std    
  1035bf:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1035c1:	fc                   	cld    
  1035c2:	89 f8                	mov    %edi,%eax
  1035c4:	89 f2                	mov    %esi,%edx
  1035c6:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  1035c9:	89 55 c8             	mov    %edx,-0x38(%ebp)
  1035cc:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  1035cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  1035d2:	83 c4 30             	add    $0x30,%esp
  1035d5:	5b                   	pop    %ebx
  1035d6:	5e                   	pop    %esi
  1035d7:	5f                   	pop    %edi
  1035d8:	5d                   	pop    %ebp
  1035d9:	c3                   	ret    

001035da <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  1035da:	55                   	push   %ebp
  1035db:	89 e5                	mov    %esp,%ebp
  1035dd:	57                   	push   %edi
  1035de:	56                   	push   %esi
  1035df:	83 ec 20             	sub    $0x20,%esp
  1035e2:	8b 45 08             	mov    0x8(%ebp),%eax
  1035e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1035e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1035eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1035ee:	8b 45 10             	mov    0x10(%ebp),%eax
  1035f1:	89 45 ec             	mov    %eax,-0x14(%ebp)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  1035f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1035f7:	c1 e8 02             	shr    $0x2,%eax
  1035fa:	89 c1                	mov    %eax,%ecx
    asm volatile (
  1035fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1035ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103602:	89 d7                	mov    %edx,%edi
  103604:	89 c6                	mov    %eax,%esi
  103606:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  103608:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  10360b:	83 e1 03             	and    $0x3,%ecx
  10360e:	74 02                	je     103612 <memcpy+0x38>
  103610:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  103612:	89 f0                	mov    %esi,%eax
  103614:	89 fa                	mov    %edi,%edx
  103616:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  103619:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  10361c:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  10361f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  103622:	83 c4 20             	add    $0x20,%esp
  103625:	5e                   	pop    %esi
  103626:	5f                   	pop    %edi
  103627:	5d                   	pop    %ebp
  103628:	c3                   	ret    

00103629 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  103629:	55                   	push   %ebp
  10362a:	89 e5                	mov    %esp,%ebp
  10362c:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  10362f:	8b 45 08             	mov    0x8(%ebp),%eax
  103632:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  103635:	8b 45 0c             	mov    0xc(%ebp),%eax
  103638:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  10363b:	eb 2e                	jmp    10366b <memcmp+0x42>
        if (*s1 != *s2) {
  10363d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103640:	0f b6 10             	movzbl (%eax),%edx
  103643:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103646:	0f b6 00             	movzbl (%eax),%eax
  103649:	38 c2                	cmp    %al,%dl
  10364b:	74 18                	je     103665 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  10364d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103650:	0f b6 00             	movzbl (%eax),%eax
  103653:	0f b6 d0             	movzbl %al,%edx
  103656:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103659:	0f b6 00             	movzbl (%eax),%eax
  10365c:	0f b6 c8             	movzbl %al,%ecx
  10365f:	89 d0                	mov    %edx,%eax
  103661:	29 c8                	sub    %ecx,%eax
  103663:	eb 18                	jmp    10367d <memcmp+0x54>
        }
        s1 ++, s2 ++;
  103665:	ff 45 fc             	incl   -0x4(%ebp)
  103668:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
  10366b:	8b 45 10             	mov    0x10(%ebp),%eax
  10366e:	8d 50 ff             	lea    -0x1(%eax),%edx
  103671:	89 55 10             	mov    %edx,0x10(%ebp)
  103674:	85 c0                	test   %eax,%eax
  103676:	75 c5                	jne    10363d <memcmp+0x14>
    }
    return 0;
  103678:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10367d:	89 ec                	mov    %ebp,%esp
  10367f:	5d                   	pop    %ebp
  103680:	c3                   	ret    
