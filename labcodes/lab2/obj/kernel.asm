
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:

.text
.globl kern_entry
kern_entry:
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
c0100000:	b8 00 a0 11 00       	mov    $0x11a000,%eax
    movl %eax, %cr3
c0100005:	0f 22 d8             	mov    %eax,%cr3

    # enable paging
    movl %cr0, %eax
c0100008:	0f 20 c0             	mov    %cr0,%eax
    orl $(CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP), %eax
c010000b:	0d 2f 00 05 80       	or     $0x8005002f,%eax
    andl $~(CR0_TS | CR0_EM), %eax
c0100010:	83 e0 f3             	and    $0xfffffff3,%eax
    movl %eax, %cr0
c0100013:	0f 22 c0             	mov    %eax,%cr0

    # update eip
    # now, eip = 0x1.....
    leal next, %eax
c0100016:	8d 05 1e 00 10 c0    	lea    0xc010001e,%eax
    # set eip = KERNBASE + 0x1.....
    jmp *%eax
c010001c:	ff e0                	jmp    *%eax

c010001e <next>:
next:

    # unmap va 0 ~ 4M, it's temporary mapping
    xorl %eax, %eax
c010001e:	31 c0                	xor    %eax,%eax
    movl %eax, __boot_pgdir
c0100020:	a3 00 a0 11 c0       	mov    %eax,0xc011a000

    # set ebp, esp
    movl $0x0, %ebp
c0100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010002a:	bc 00 90 11 c0       	mov    $0xc0119000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
c010002f:	e8 02 00 00 00       	call   c0100036 <kern_init>

c0100034 <spin>:

# should never get here
spin:
    jmp spin
c0100034:	eb fe                	jmp    c0100034 <spin>

c0100036 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
c0100036:	55                   	push   %ebp
c0100037:	89 e5                	mov    %esp,%ebp
c0100039:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c010003c:	b8 2c cf 11 c0       	mov    $0xc011cf2c,%eax
c0100041:	2d 00 c0 11 c0       	sub    $0xc011c000,%eax
c0100046:	89 44 24 08          	mov    %eax,0x8(%esp)
c010004a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100051:	00 
c0100052:	c7 04 24 00 c0 11 c0 	movl   $0xc011c000,(%esp)
c0100059:	e8 13 5f 00 00       	call   c0105f71 <memset>

    cons_init();                // init the console
c010005e:	e8 11 16 00 00       	call   c0101674 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c0100063:	c7 45 f4 00 61 10 c0 	movl   $0xc0106100,-0xc(%ebp)
    cprintf("%s\n\n", message);
c010006a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010006d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100071:	c7 04 24 1c 61 10 c0 	movl   $0xc010611c,(%esp)
c0100078:	e8 e4 02 00 00       	call   c0100361 <cprintf>

    print_kerninfo();
c010007d:	e8 02 08 00 00       	call   c0100884 <print_kerninfo>

    grade_backtrace();
c0100082:	e8 90 00 00 00       	call   c0100117 <grade_backtrace>

    pmm_init();                 // init physical memory management
c0100087:	e8 2e 44 00 00       	call   c01044ba <pmm_init>

    pic_init();                 // init interrupt controller
c010008c:	e8 64 17 00 00       	call   c01017f5 <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100091:	e8 eb 18 00 00       	call   c0101981 <idt_init>

    clock_init();               // init clock interrupt
c0100096:	e8 38 0d 00 00       	call   c0100dd3 <clock_init>
    intr_enable();              // enable irq interrupt
c010009b:	e8 b3 16 00 00       	call   c0101753 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
c01000a0:	eb fe                	jmp    c01000a0 <kern_init+0x6a>

c01000a2 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c01000a2:	55                   	push   %ebp
c01000a3:	89 e5                	mov    %esp,%ebp
c01000a5:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000a8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000af:	00 
c01000b0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000b7:	00 
c01000b8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000bf:	e8 2a 0c 00 00       	call   c0100cee <mon_backtrace>
}
c01000c4:	90                   	nop
c01000c5:	89 ec                	mov    %ebp,%esp
c01000c7:	5d                   	pop    %ebp
c01000c8:	c3                   	ret    

c01000c9 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000c9:	55                   	push   %ebp
c01000ca:	89 e5                	mov    %esp,%ebp
c01000cc:	83 ec 18             	sub    $0x18,%esp
c01000cf:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000d2:	8d 4d 0c             	lea    0xc(%ebp),%ecx
c01000d5:	8b 55 0c             	mov    0xc(%ebp),%edx
c01000d8:	8d 5d 08             	lea    0x8(%ebp),%ebx
c01000db:	8b 45 08             	mov    0x8(%ebp),%eax
c01000de:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01000e2:	89 54 24 08          	mov    %edx,0x8(%esp)
c01000e6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01000ea:	89 04 24             	mov    %eax,(%esp)
c01000ed:	e8 b0 ff ff ff       	call   c01000a2 <grade_backtrace2>
}
c01000f2:	90                   	nop
c01000f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01000f6:	89 ec                	mov    %ebp,%esp
c01000f8:	5d                   	pop    %ebp
c01000f9:	c3                   	ret    

c01000fa <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c01000fa:	55                   	push   %ebp
c01000fb:	89 e5                	mov    %esp,%ebp
c01000fd:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c0100100:	8b 45 10             	mov    0x10(%ebp),%eax
c0100103:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100107:	8b 45 08             	mov    0x8(%ebp),%eax
c010010a:	89 04 24             	mov    %eax,(%esp)
c010010d:	e8 b7 ff ff ff       	call   c01000c9 <grade_backtrace1>
}
c0100112:	90                   	nop
c0100113:	89 ec                	mov    %ebp,%esp
c0100115:	5d                   	pop    %ebp
c0100116:	c3                   	ret    

c0100117 <grade_backtrace>:

void
grade_backtrace(void) {
c0100117:	55                   	push   %ebp
c0100118:	89 e5                	mov    %esp,%ebp
c010011a:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c010011d:	b8 36 00 10 c0       	mov    $0xc0100036,%eax
c0100122:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c0100129:	ff 
c010012a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010012e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100135:	e8 c0 ff ff ff       	call   c01000fa <grade_backtrace0>
}
c010013a:	90                   	nop
c010013b:	89 ec                	mov    %ebp,%esp
c010013d:	5d                   	pop    %ebp
c010013e:	c3                   	ret    

c010013f <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c010013f:	55                   	push   %ebp
c0100140:	89 e5                	mov    %esp,%ebp
c0100142:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c0100145:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c0100148:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c010014b:	8c 45 f2             	mov    %es,-0xe(%ebp)
c010014e:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c0100151:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100155:	83 e0 03             	and    $0x3,%eax
c0100158:	89 c2                	mov    %eax,%edx
c010015a:	a1 00 c0 11 c0       	mov    0xc011c000,%eax
c010015f:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100163:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100167:	c7 04 24 21 61 10 c0 	movl   $0xc0106121,(%esp)
c010016e:	e8 ee 01 00 00       	call   c0100361 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100173:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100177:	89 c2                	mov    %eax,%edx
c0100179:	a1 00 c0 11 c0       	mov    0xc011c000,%eax
c010017e:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100182:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100186:	c7 04 24 2f 61 10 c0 	movl   $0xc010612f,(%esp)
c010018d:	e8 cf 01 00 00       	call   c0100361 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c0100192:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0100196:	89 c2                	mov    %eax,%edx
c0100198:	a1 00 c0 11 c0       	mov    0xc011c000,%eax
c010019d:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001a1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001a5:	c7 04 24 3d 61 10 c0 	movl   $0xc010613d,(%esp)
c01001ac:	e8 b0 01 00 00       	call   c0100361 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001b1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001b5:	89 c2                	mov    %eax,%edx
c01001b7:	a1 00 c0 11 c0       	mov    0xc011c000,%eax
c01001bc:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001c0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001c4:	c7 04 24 4b 61 10 c0 	movl   $0xc010614b,(%esp)
c01001cb:	e8 91 01 00 00       	call   c0100361 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001d0:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001d4:	89 c2                	mov    %eax,%edx
c01001d6:	a1 00 c0 11 c0       	mov    0xc011c000,%eax
c01001db:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001df:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001e3:	c7 04 24 59 61 10 c0 	movl   $0xc0106159,(%esp)
c01001ea:	e8 72 01 00 00       	call   c0100361 <cprintf>
    round ++;
c01001ef:	a1 00 c0 11 c0       	mov    0xc011c000,%eax
c01001f4:	40                   	inc    %eax
c01001f5:	a3 00 c0 11 c0       	mov    %eax,0xc011c000
}
c01001fa:	90                   	nop
c01001fb:	89 ec                	mov    %ebp,%esp
c01001fd:	5d                   	pop    %ebp
c01001fe:	c3                   	ret    

c01001ff <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c01001ff:	55                   	push   %ebp
c0100200:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
	asm volatile (
c0100202:	83 ec 08             	sub    $0x8,%esp
c0100205:	cd 78                	int    $0x78
c0100207:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp"
	    : 
	    : "i"(T_SWITCH_TOU)
	);
}
c0100209:	90                   	nop
c010020a:	5d                   	pop    %ebp
c010020b:	c3                   	ret    

c010020c <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c010020c:	55                   	push   %ebp
c010020d:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
	asm volatile (
c010020f:	cd 79                	int    $0x79
c0100211:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp \n"
	    : 
	    : "i"(T_SWITCH_TOK)
	);
}
c0100213:	90                   	nop
c0100214:	5d                   	pop    %ebp
c0100215:	c3                   	ret    

c0100216 <lab1_switch_test>:

static void
lab1_switch_test(void) {
c0100216:	55                   	push   %ebp
c0100217:	89 e5                	mov    %esp,%ebp
c0100219:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c010021c:	e8 1e ff ff ff       	call   c010013f <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c0100221:	c7 04 24 68 61 10 c0 	movl   $0xc0106168,(%esp)
c0100228:	e8 34 01 00 00       	call   c0100361 <cprintf>
    lab1_switch_to_user();
c010022d:	e8 cd ff ff ff       	call   c01001ff <lab1_switch_to_user>
    lab1_print_cur_status();
c0100232:	e8 08 ff ff ff       	call   c010013f <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c0100237:	c7 04 24 88 61 10 c0 	movl   $0xc0106188,(%esp)
c010023e:	e8 1e 01 00 00       	call   c0100361 <cprintf>
    lab1_switch_to_kernel();
c0100243:	e8 c4 ff ff ff       	call   c010020c <lab1_switch_to_kernel>
    lab1_print_cur_status();
c0100248:	e8 f2 fe ff ff       	call   c010013f <lab1_print_cur_status>
}
c010024d:	90                   	nop
c010024e:	89 ec                	mov    %ebp,%esp
c0100250:	5d                   	pop    %ebp
c0100251:	c3                   	ret    

c0100252 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c0100252:	55                   	push   %ebp
c0100253:	89 e5                	mov    %esp,%ebp
c0100255:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c0100258:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010025c:	74 13                	je     c0100271 <readline+0x1f>
        cprintf("%s", prompt);
c010025e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100261:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100265:	c7 04 24 a7 61 10 c0 	movl   $0xc01061a7,(%esp)
c010026c:	e8 f0 00 00 00       	call   c0100361 <cprintf>
    }
    int i = 0, c;
c0100271:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c0100278:	e8 73 01 00 00       	call   c01003f0 <getchar>
c010027d:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c0100280:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100284:	79 07                	jns    c010028d <readline+0x3b>
            return NULL;
c0100286:	b8 00 00 00 00       	mov    $0x0,%eax
c010028b:	eb 78                	jmp    c0100305 <readline+0xb3>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c010028d:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c0100291:	7e 28                	jle    c01002bb <readline+0x69>
c0100293:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c010029a:	7f 1f                	jg     c01002bb <readline+0x69>
            cputchar(c);
c010029c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010029f:	89 04 24             	mov    %eax,(%esp)
c01002a2:	e8 e2 00 00 00       	call   c0100389 <cputchar>
            buf[i ++] = c;
c01002a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01002aa:	8d 50 01             	lea    0x1(%eax),%edx
c01002ad:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01002b0:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01002b3:	88 90 20 c0 11 c0    	mov    %dl,-0x3fee3fe0(%eax)
c01002b9:	eb 45                	jmp    c0100300 <readline+0xae>
        }
        else if (c == '\b' && i > 0) {
c01002bb:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01002bf:	75 16                	jne    c01002d7 <readline+0x85>
c01002c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01002c5:	7e 10                	jle    c01002d7 <readline+0x85>
            cputchar(c);
c01002c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002ca:	89 04 24             	mov    %eax,(%esp)
c01002cd:	e8 b7 00 00 00       	call   c0100389 <cputchar>
            i --;
c01002d2:	ff 4d f4             	decl   -0xc(%ebp)
c01002d5:	eb 29                	jmp    c0100300 <readline+0xae>
        }
        else if (c == '\n' || c == '\r') {
c01002d7:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01002db:	74 06                	je     c01002e3 <readline+0x91>
c01002dd:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01002e1:	75 95                	jne    c0100278 <readline+0x26>
            cputchar(c);
c01002e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002e6:	89 04 24             	mov    %eax,(%esp)
c01002e9:	e8 9b 00 00 00       	call   c0100389 <cputchar>
            buf[i] = '\0';
c01002ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01002f1:	05 20 c0 11 c0       	add    $0xc011c020,%eax
c01002f6:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01002f9:	b8 20 c0 11 c0       	mov    $0xc011c020,%eax
c01002fe:	eb 05                	jmp    c0100305 <readline+0xb3>
        c = getchar();
c0100300:	e9 73 ff ff ff       	jmp    c0100278 <readline+0x26>
        }
    }
}
c0100305:	89 ec                	mov    %ebp,%esp
c0100307:	5d                   	pop    %ebp
c0100308:	c3                   	ret    

c0100309 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c0100309:	55                   	push   %ebp
c010030a:	89 e5                	mov    %esp,%ebp
c010030c:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c010030f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100312:	89 04 24             	mov    %eax,(%esp)
c0100315:	e8 89 13 00 00       	call   c01016a3 <cons_putc>
    (*cnt) ++;
c010031a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010031d:	8b 00                	mov    (%eax),%eax
c010031f:	8d 50 01             	lea    0x1(%eax),%edx
c0100322:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100325:	89 10                	mov    %edx,(%eax)
}
c0100327:	90                   	nop
c0100328:	89 ec                	mov    %ebp,%esp
c010032a:	5d                   	pop    %ebp
c010032b:	c3                   	ret    

c010032c <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c010032c:	55                   	push   %ebp
c010032d:	89 e5                	mov    %esp,%ebp
c010032f:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c0100332:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c0100339:	8b 45 0c             	mov    0xc(%ebp),%eax
c010033c:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0100340:	8b 45 08             	mov    0x8(%ebp),%eax
c0100343:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100347:	8d 45 f4             	lea    -0xc(%ebp),%eax
c010034a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010034e:	c7 04 24 09 03 10 c0 	movl   $0xc0100309,(%esp)
c0100355:	e8 42 54 00 00       	call   c010579c <vprintfmt>
    return cnt;
c010035a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010035d:	89 ec                	mov    %ebp,%esp
c010035f:	5d                   	pop    %ebp
c0100360:	c3                   	ret    

c0100361 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c0100361:	55                   	push   %ebp
c0100362:	89 e5                	mov    %esp,%ebp
c0100364:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0100367:	8d 45 0c             	lea    0xc(%ebp),%eax
c010036a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c010036d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100370:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100374:	8b 45 08             	mov    0x8(%ebp),%eax
c0100377:	89 04 24             	mov    %eax,(%esp)
c010037a:	e8 ad ff ff ff       	call   c010032c <vcprintf>
c010037f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0100382:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100385:	89 ec                	mov    %ebp,%esp
c0100387:	5d                   	pop    %ebp
c0100388:	c3                   	ret    

c0100389 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c0100389:	55                   	push   %ebp
c010038a:	89 e5                	mov    %esp,%ebp
c010038c:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c010038f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100392:	89 04 24             	mov    %eax,(%esp)
c0100395:	e8 09 13 00 00       	call   c01016a3 <cons_putc>
}
c010039a:	90                   	nop
c010039b:	89 ec                	mov    %ebp,%esp
c010039d:	5d                   	pop    %ebp
c010039e:	c3                   	ret    

c010039f <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c010039f:	55                   	push   %ebp
c01003a0:	89 e5                	mov    %esp,%ebp
c01003a2:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c01003a5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c01003ac:	eb 13                	jmp    c01003c1 <cputs+0x22>
        cputch(c, &cnt);
c01003ae:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c01003b2:	8d 55 f0             	lea    -0x10(%ebp),%edx
c01003b5:	89 54 24 04          	mov    %edx,0x4(%esp)
c01003b9:	89 04 24             	mov    %eax,(%esp)
c01003bc:	e8 48 ff ff ff       	call   c0100309 <cputch>
    while ((c = *str ++) != '\0') {
c01003c1:	8b 45 08             	mov    0x8(%ebp),%eax
c01003c4:	8d 50 01             	lea    0x1(%eax),%edx
c01003c7:	89 55 08             	mov    %edx,0x8(%ebp)
c01003ca:	0f b6 00             	movzbl (%eax),%eax
c01003cd:	88 45 f7             	mov    %al,-0x9(%ebp)
c01003d0:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01003d4:	75 d8                	jne    c01003ae <cputs+0xf>
    }
    cputch('\n', &cnt);
c01003d6:	8d 45 f0             	lea    -0x10(%ebp),%eax
c01003d9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01003dd:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c01003e4:	e8 20 ff ff ff       	call   c0100309 <cputch>
    return cnt;
c01003e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01003ec:	89 ec                	mov    %ebp,%esp
c01003ee:	5d                   	pop    %ebp
c01003ef:	c3                   	ret    

c01003f0 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c01003f0:	55                   	push   %ebp
c01003f1:	89 e5                	mov    %esp,%ebp
c01003f3:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c01003f6:	90                   	nop
c01003f7:	e8 e6 12 00 00       	call   c01016e2 <cons_getc>
c01003fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01003ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100403:	74 f2                	je     c01003f7 <getchar+0x7>
        /* do nothing */;
    return c;
c0100405:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100408:	89 ec                	mov    %ebp,%esp
c010040a:	5d                   	pop    %ebp
c010040b:	c3                   	ret    

c010040c <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c010040c:	55                   	push   %ebp
c010040d:	89 e5                	mov    %esp,%ebp
c010040f:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c0100412:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100415:	8b 00                	mov    (%eax),%eax
c0100417:	89 45 fc             	mov    %eax,-0x4(%ebp)
c010041a:	8b 45 10             	mov    0x10(%ebp),%eax
c010041d:	8b 00                	mov    (%eax),%eax
c010041f:	89 45 f8             	mov    %eax,-0x8(%ebp)
c0100422:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c0100429:	e9 ca 00 00 00       	jmp    c01004f8 <stab_binsearch+0xec>
        int true_m = (l + r) / 2, m = true_m;
c010042e:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100431:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100434:	01 d0                	add    %edx,%eax
c0100436:	89 c2                	mov    %eax,%edx
c0100438:	c1 ea 1f             	shr    $0x1f,%edx
c010043b:	01 d0                	add    %edx,%eax
c010043d:	d1 f8                	sar    %eax
c010043f:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0100442:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100445:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100448:	eb 03                	jmp    c010044d <stab_binsearch+0x41>
            m --;
c010044a:	ff 4d f0             	decl   -0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
c010044d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100450:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100453:	7c 1f                	jl     c0100474 <stab_binsearch+0x68>
c0100455:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100458:	89 d0                	mov    %edx,%eax
c010045a:	01 c0                	add    %eax,%eax
c010045c:	01 d0                	add    %edx,%eax
c010045e:	c1 e0 02             	shl    $0x2,%eax
c0100461:	89 c2                	mov    %eax,%edx
c0100463:	8b 45 08             	mov    0x8(%ebp),%eax
c0100466:	01 d0                	add    %edx,%eax
c0100468:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010046c:	0f b6 c0             	movzbl %al,%eax
c010046f:	39 45 14             	cmp    %eax,0x14(%ebp)
c0100472:	75 d6                	jne    c010044a <stab_binsearch+0x3e>
        }
        if (m < l) {    // no match in [l, m]
c0100474:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100477:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010047a:	7d 09                	jge    c0100485 <stab_binsearch+0x79>
            l = true_m + 1;
c010047c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010047f:	40                   	inc    %eax
c0100480:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c0100483:	eb 73                	jmp    c01004f8 <stab_binsearch+0xec>
        }

        // actual binary search
        any_matches = 1;
c0100485:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c010048c:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010048f:	89 d0                	mov    %edx,%eax
c0100491:	01 c0                	add    %eax,%eax
c0100493:	01 d0                	add    %edx,%eax
c0100495:	c1 e0 02             	shl    $0x2,%eax
c0100498:	89 c2                	mov    %eax,%edx
c010049a:	8b 45 08             	mov    0x8(%ebp),%eax
c010049d:	01 d0                	add    %edx,%eax
c010049f:	8b 40 08             	mov    0x8(%eax),%eax
c01004a2:	39 45 18             	cmp    %eax,0x18(%ebp)
c01004a5:	76 11                	jbe    c01004b8 <stab_binsearch+0xac>
            *region_left = m;
c01004a7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004ad:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c01004af:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01004b2:	40                   	inc    %eax
c01004b3:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01004b6:	eb 40                	jmp    c01004f8 <stab_binsearch+0xec>
        } else if (stabs[m].n_value > addr) {
c01004b8:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004bb:	89 d0                	mov    %edx,%eax
c01004bd:	01 c0                	add    %eax,%eax
c01004bf:	01 d0                	add    %edx,%eax
c01004c1:	c1 e0 02             	shl    $0x2,%eax
c01004c4:	89 c2                	mov    %eax,%edx
c01004c6:	8b 45 08             	mov    0x8(%ebp),%eax
c01004c9:	01 d0                	add    %edx,%eax
c01004cb:	8b 40 08             	mov    0x8(%eax),%eax
c01004ce:	39 45 18             	cmp    %eax,0x18(%ebp)
c01004d1:	73 14                	jae    c01004e7 <stab_binsearch+0xdb>
            *region_right = m - 1;
c01004d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004d6:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004d9:	8b 45 10             	mov    0x10(%ebp),%eax
c01004dc:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c01004de:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004e1:	48                   	dec    %eax
c01004e2:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004e5:	eb 11                	jmp    c01004f8 <stab_binsearch+0xec>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01004e7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004ea:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004ed:	89 10                	mov    %edx,(%eax)
            l = m;
c01004ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004f2:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01004f5:	ff 45 18             	incl   0x18(%ebp)
    while (l <= r) {
c01004f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01004fb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01004fe:	0f 8e 2a ff ff ff    	jle    c010042e <stab_binsearch+0x22>
        }
    }

    if (!any_matches) {
c0100504:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100508:	75 0f                	jne    c0100519 <stab_binsearch+0x10d>
        *region_right = *region_left - 1;
c010050a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010050d:	8b 00                	mov    (%eax),%eax
c010050f:	8d 50 ff             	lea    -0x1(%eax),%edx
c0100512:	8b 45 10             	mov    0x10(%ebp),%eax
c0100515:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
c0100517:	eb 3e                	jmp    c0100557 <stab_binsearch+0x14b>
        l = *region_right;
c0100519:	8b 45 10             	mov    0x10(%ebp),%eax
c010051c:	8b 00                	mov    (%eax),%eax
c010051e:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c0100521:	eb 03                	jmp    c0100526 <stab_binsearch+0x11a>
c0100523:	ff 4d fc             	decl   -0x4(%ebp)
c0100526:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100529:	8b 00                	mov    (%eax),%eax
c010052b:	39 45 fc             	cmp    %eax,-0x4(%ebp)
c010052e:	7e 1f                	jle    c010054f <stab_binsearch+0x143>
c0100530:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100533:	89 d0                	mov    %edx,%eax
c0100535:	01 c0                	add    %eax,%eax
c0100537:	01 d0                	add    %edx,%eax
c0100539:	c1 e0 02             	shl    $0x2,%eax
c010053c:	89 c2                	mov    %eax,%edx
c010053e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100541:	01 d0                	add    %edx,%eax
c0100543:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100547:	0f b6 c0             	movzbl %al,%eax
c010054a:	39 45 14             	cmp    %eax,0x14(%ebp)
c010054d:	75 d4                	jne    c0100523 <stab_binsearch+0x117>
        *region_left = l;
c010054f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100552:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100555:	89 10                	mov    %edx,(%eax)
}
c0100557:	90                   	nop
c0100558:	89 ec                	mov    %ebp,%esp
c010055a:	5d                   	pop    %ebp
c010055b:	c3                   	ret    

c010055c <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c010055c:	55                   	push   %ebp
c010055d:	89 e5                	mov    %esp,%ebp
c010055f:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c0100562:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100565:	c7 00 ac 61 10 c0    	movl   $0xc01061ac,(%eax)
    info->eip_line = 0;
c010056b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010056e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c0100575:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100578:	c7 40 08 ac 61 10 c0 	movl   $0xc01061ac,0x8(%eax)
    info->eip_fn_namelen = 9;
c010057f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100582:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c0100589:	8b 45 0c             	mov    0xc(%ebp),%eax
c010058c:	8b 55 08             	mov    0x8(%ebp),%edx
c010058f:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100592:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100595:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c010059c:	c7 45 f4 6c 74 10 c0 	movl   $0xc010746c,-0xc(%ebp)
    stab_end = __STAB_END__;
c01005a3:	c7 45 f0 ec 2c 11 c0 	movl   $0xc0112cec,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c01005aa:	c7 45 ec ed 2c 11 c0 	movl   $0xc0112ced,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c01005b1:	c7 45 e8 c3 62 11 c0 	movl   $0xc01162c3,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c01005b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01005bb:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01005be:	76 0b                	jbe    c01005cb <debuginfo_eip+0x6f>
c01005c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01005c3:	48                   	dec    %eax
c01005c4:	0f b6 00             	movzbl (%eax),%eax
c01005c7:	84 c0                	test   %al,%al
c01005c9:	74 0a                	je     c01005d5 <debuginfo_eip+0x79>
        return -1;
c01005cb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01005d0:	e9 ab 02 00 00       	jmp    c0100880 <debuginfo_eip+0x324>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01005d5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01005dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01005df:	2b 45 f4             	sub    -0xc(%ebp),%eax
c01005e2:	c1 f8 02             	sar    $0x2,%eax
c01005e5:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01005eb:	48                   	dec    %eax
c01005ec:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01005ef:	8b 45 08             	mov    0x8(%ebp),%eax
c01005f2:	89 44 24 10          	mov    %eax,0x10(%esp)
c01005f6:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01005fd:	00 
c01005fe:	8d 45 e0             	lea    -0x20(%ebp),%eax
c0100601:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100605:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c0100608:	89 44 24 04          	mov    %eax,0x4(%esp)
c010060c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010060f:	89 04 24             	mov    %eax,(%esp)
c0100612:	e8 f5 fd ff ff       	call   c010040c <stab_binsearch>
    if (lfile == 0)
c0100617:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010061a:	85 c0                	test   %eax,%eax
c010061c:	75 0a                	jne    c0100628 <debuginfo_eip+0xcc>
        return -1;
c010061e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100623:	e9 58 02 00 00       	jmp    c0100880 <debuginfo_eip+0x324>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c0100628:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010062b:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010062e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0100631:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c0100634:	8b 45 08             	mov    0x8(%ebp),%eax
c0100637:	89 44 24 10          	mov    %eax,0x10(%esp)
c010063b:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c0100642:	00 
c0100643:	8d 45 d8             	lea    -0x28(%ebp),%eax
c0100646:	89 44 24 08          	mov    %eax,0x8(%esp)
c010064a:	8d 45 dc             	lea    -0x24(%ebp),%eax
c010064d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100651:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100654:	89 04 24             	mov    %eax,(%esp)
c0100657:	e8 b0 fd ff ff       	call   c010040c <stab_binsearch>

    if (lfun <= rfun) {
c010065c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010065f:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100662:	39 c2                	cmp    %eax,%edx
c0100664:	7f 78                	jg     c01006de <debuginfo_eip+0x182>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c0100666:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100669:	89 c2                	mov    %eax,%edx
c010066b:	89 d0                	mov    %edx,%eax
c010066d:	01 c0                	add    %eax,%eax
c010066f:	01 d0                	add    %edx,%eax
c0100671:	c1 e0 02             	shl    $0x2,%eax
c0100674:	89 c2                	mov    %eax,%edx
c0100676:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100679:	01 d0                	add    %edx,%eax
c010067b:	8b 10                	mov    (%eax),%edx
c010067d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100680:	2b 45 ec             	sub    -0x14(%ebp),%eax
c0100683:	39 c2                	cmp    %eax,%edx
c0100685:	73 22                	jae    c01006a9 <debuginfo_eip+0x14d>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c0100687:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010068a:	89 c2                	mov    %eax,%edx
c010068c:	89 d0                	mov    %edx,%eax
c010068e:	01 c0                	add    %eax,%eax
c0100690:	01 d0                	add    %edx,%eax
c0100692:	c1 e0 02             	shl    $0x2,%eax
c0100695:	89 c2                	mov    %eax,%edx
c0100697:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010069a:	01 d0                	add    %edx,%eax
c010069c:	8b 10                	mov    (%eax),%edx
c010069e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01006a1:	01 c2                	add    %eax,%edx
c01006a3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006a6:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c01006a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006ac:	89 c2                	mov    %eax,%edx
c01006ae:	89 d0                	mov    %edx,%eax
c01006b0:	01 c0                	add    %eax,%eax
c01006b2:	01 d0                	add    %edx,%eax
c01006b4:	c1 e0 02             	shl    $0x2,%eax
c01006b7:	89 c2                	mov    %eax,%edx
c01006b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006bc:	01 d0                	add    %edx,%eax
c01006be:	8b 50 08             	mov    0x8(%eax),%edx
c01006c1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006c4:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c01006c7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006ca:	8b 40 10             	mov    0x10(%eax),%eax
c01006cd:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c01006d0:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006d3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c01006d6:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01006d9:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01006dc:	eb 15                	jmp    c01006f3 <debuginfo_eip+0x197>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01006de:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006e1:	8b 55 08             	mov    0x8(%ebp),%edx
c01006e4:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01006e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006ea:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01006ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006f0:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01006f3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006f6:	8b 40 08             	mov    0x8(%eax),%eax
c01006f9:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c0100700:	00 
c0100701:	89 04 24             	mov    %eax,(%esp)
c0100704:	e8 e0 56 00 00       	call   c0105de9 <strfind>
c0100709:	8b 55 0c             	mov    0xc(%ebp),%edx
c010070c:	8b 4a 08             	mov    0x8(%edx),%ecx
c010070f:	29 c8                	sub    %ecx,%eax
c0100711:	89 c2                	mov    %eax,%edx
c0100713:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100716:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c0100719:	8b 45 08             	mov    0x8(%ebp),%eax
c010071c:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100720:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c0100727:	00 
c0100728:	8d 45 d0             	lea    -0x30(%ebp),%eax
c010072b:	89 44 24 08          	mov    %eax,0x8(%esp)
c010072f:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c0100732:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100736:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100739:	89 04 24             	mov    %eax,(%esp)
c010073c:	e8 cb fc ff ff       	call   c010040c <stab_binsearch>
    if (lline <= rline) {
c0100741:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100744:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100747:	39 c2                	cmp    %eax,%edx
c0100749:	7f 23                	jg     c010076e <debuginfo_eip+0x212>
        info->eip_line = stabs[rline].n_desc;
c010074b:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010074e:	89 c2                	mov    %eax,%edx
c0100750:	89 d0                	mov    %edx,%eax
c0100752:	01 c0                	add    %eax,%eax
c0100754:	01 d0                	add    %edx,%eax
c0100756:	c1 e0 02             	shl    $0x2,%eax
c0100759:	89 c2                	mov    %eax,%edx
c010075b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010075e:	01 d0                	add    %edx,%eax
c0100760:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c0100764:	89 c2                	mov    %eax,%edx
c0100766:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100769:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c010076c:	eb 11                	jmp    c010077f <debuginfo_eip+0x223>
        return -1;
c010076e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100773:	e9 08 01 00 00       	jmp    c0100880 <debuginfo_eip+0x324>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c0100778:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010077b:	48                   	dec    %eax
c010077c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
c010077f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100782:	8b 45 e4             	mov    -0x1c(%ebp),%eax
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c0100785:	39 c2                	cmp    %eax,%edx
c0100787:	7c 56                	jl     c01007df <debuginfo_eip+0x283>
           && stabs[lline].n_type != N_SOL
c0100789:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010078c:	89 c2                	mov    %eax,%edx
c010078e:	89 d0                	mov    %edx,%eax
c0100790:	01 c0                	add    %eax,%eax
c0100792:	01 d0                	add    %edx,%eax
c0100794:	c1 e0 02             	shl    $0x2,%eax
c0100797:	89 c2                	mov    %eax,%edx
c0100799:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010079c:	01 d0                	add    %edx,%eax
c010079e:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01007a2:	3c 84                	cmp    $0x84,%al
c01007a4:	74 39                	je     c01007df <debuginfo_eip+0x283>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c01007a6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007a9:	89 c2                	mov    %eax,%edx
c01007ab:	89 d0                	mov    %edx,%eax
c01007ad:	01 c0                	add    %eax,%eax
c01007af:	01 d0                	add    %edx,%eax
c01007b1:	c1 e0 02             	shl    $0x2,%eax
c01007b4:	89 c2                	mov    %eax,%edx
c01007b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007b9:	01 d0                	add    %edx,%eax
c01007bb:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01007bf:	3c 64                	cmp    $0x64,%al
c01007c1:	75 b5                	jne    c0100778 <debuginfo_eip+0x21c>
c01007c3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007c6:	89 c2                	mov    %eax,%edx
c01007c8:	89 d0                	mov    %edx,%eax
c01007ca:	01 c0                	add    %eax,%eax
c01007cc:	01 d0                	add    %edx,%eax
c01007ce:	c1 e0 02             	shl    $0x2,%eax
c01007d1:	89 c2                	mov    %eax,%edx
c01007d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007d6:	01 d0                	add    %edx,%eax
c01007d8:	8b 40 08             	mov    0x8(%eax),%eax
c01007db:	85 c0                	test   %eax,%eax
c01007dd:	74 99                	je     c0100778 <debuginfo_eip+0x21c>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01007df:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007e5:	39 c2                	cmp    %eax,%edx
c01007e7:	7c 42                	jl     c010082b <debuginfo_eip+0x2cf>
c01007e9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007ec:	89 c2                	mov    %eax,%edx
c01007ee:	89 d0                	mov    %edx,%eax
c01007f0:	01 c0                	add    %eax,%eax
c01007f2:	01 d0                	add    %edx,%eax
c01007f4:	c1 e0 02             	shl    $0x2,%eax
c01007f7:	89 c2                	mov    %eax,%edx
c01007f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007fc:	01 d0                	add    %edx,%eax
c01007fe:	8b 10                	mov    (%eax),%edx
c0100800:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100803:	2b 45 ec             	sub    -0x14(%ebp),%eax
c0100806:	39 c2                	cmp    %eax,%edx
c0100808:	73 21                	jae    c010082b <debuginfo_eip+0x2cf>
        info->eip_file = stabstr + stabs[lline].n_strx;
c010080a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010080d:	89 c2                	mov    %eax,%edx
c010080f:	89 d0                	mov    %edx,%eax
c0100811:	01 c0                	add    %eax,%eax
c0100813:	01 d0                	add    %edx,%eax
c0100815:	c1 e0 02             	shl    $0x2,%eax
c0100818:	89 c2                	mov    %eax,%edx
c010081a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010081d:	01 d0                	add    %edx,%eax
c010081f:	8b 10                	mov    (%eax),%edx
c0100821:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100824:	01 c2                	add    %eax,%edx
c0100826:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100829:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c010082b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010082e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100831:	39 c2                	cmp    %eax,%edx
c0100833:	7d 46                	jge    c010087b <debuginfo_eip+0x31f>
        for (lline = lfun + 1;
c0100835:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100838:	40                   	inc    %eax
c0100839:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c010083c:	eb 16                	jmp    c0100854 <debuginfo_eip+0x2f8>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c010083e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100841:	8b 40 14             	mov    0x14(%eax),%eax
c0100844:	8d 50 01             	lea    0x1(%eax),%edx
c0100847:	8b 45 0c             	mov    0xc(%ebp),%eax
c010084a:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
c010084d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100850:	40                   	inc    %eax
c0100851:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100854:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100857:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010085a:	39 c2                	cmp    %eax,%edx
c010085c:	7d 1d                	jge    c010087b <debuginfo_eip+0x31f>
c010085e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100861:	89 c2                	mov    %eax,%edx
c0100863:	89 d0                	mov    %edx,%eax
c0100865:	01 c0                	add    %eax,%eax
c0100867:	01 d0                	add    %edx,%eax
c0100869:	c1 e0 02             	shl    $0x2,%eax
c010086c:	89 c2                	mov    %eax,%edx
c010086e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100871:	01 d0                	add    %edx,%eax
c0100873:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100877:	3c a0                	cmp    $0xa0,%al
c0100879:	74 c3                	je     c010083e <debuginfo_eip+0x2e2>
        }
    }
    return 0;
c010087b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100880:	89 ec                	mov    %ebp,%esp
c0100882:	5d                   	pop    %ebp
c0100883:	c3                   	ret    

c0100884 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c0100884:	55                   	push   %ebp
c0100885:	89 e5                	mov    %esp,%ebp
c0100887:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c010088a:	c7 04 24 b6 61 10 c0 	movl   $0xc01061b6,(%esp)
c0100891:	e8 cb fa ff ff       	call   c0100361 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100896:	c7 44 24 04 36 00 10 	movl   $0xc0100036,0x4(%esp)
c010089d:	c0 
c010089e:	c7 04 24 cf 61 10 c0 	movl   $0xc01061cf,(%esp)
c01008a5:	e8 b7 fa ff ff       	call   c0100361 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c01008aa:	c7 44 24 04 fd 60 10 	movl   $0xc01060fd,0x4(%esp)
c01008b1:	c0 
c01008b2:	c7 04 24 e7 61 10 c0 	movl   $0xc01061e7,(%esp)
c01008b9:	e8 a3 fa ff ff       	call   c0100361 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01008be:	c7 44 24 04 00 c0 11 	movl   $0xc011c000,0x4(%esp)
c01008c5:	c0 
c01008c6:	c7 04 24 ff 61 10 c0 	movl   $0xc01061ff,(%esp)
c01008cd:	e8 8f fa ff ff       	call   c0100361 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01008d2:	c7 44 24 04 2c cf 11 	movl   $0xc011cf2c,0x4(%esp)
c01008d9:	c0 
c01008da:	c7 04 24 17 62 10 c0 	movl   $0xc0106217,(%esp)
c01008e1:	e8 7b fa ff ff       	call   c0100361 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01008e6:	b8 2c cf 11 c0       	mov    $0xc011cf2c,%eax
c01008eb:	2d 36 00 10 c0       	sub    $0xc0100036,%eax
c01008f0:	05 ff 03 00 00       	add    $0x3ff,%eax
c01008f5:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008fb:	85 c0                	test   %eax,%eax
c01008fd:	0f 48 c2             	cmovs  %edx,%eax
c0100900:	c1 f8 0a             	sar    $0xa,%eax
c0100903:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100907:	c7 04 24 30 62 10 c0 	movl   $0xc0106230,(%esp)
c010090e:	e8 4e fa ff ff       	call   c0100361 <cprintf>
}
c0100913:	90                   	nop
c0100914:	89 ec                	mov    %ebp,%esp
c0100916:	5d                   	pop    %ebp
c0100917:	c3                   	ret    

c0100918 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c0100918:	55                   	push   %ebp
c0100919:	89 e5                	mov    %esp,%ebp
c010091b:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c0100921:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100924:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100928:	8b 45 08             	mov    0x8(%ebp),%eax
c010092b:	89 04 24             	mov    %eax,(%esp)
c010092e:	e8 29 fc ff ff       	call   c010055c <debuginfo_eip>
c0100933:	85 c0                	test   %eax,%eax
c0100935:	74 15                	je     c010094c <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c0100937:	8b 45 08             	mov    0x8(%ebp),%eax
c010093a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010093e:	c7 04 24 5a 62 10 c0 	movl   $0xc010625a,(%esp)
c0100945:	e8 17 fa ff ff       	call   c0100361 <cprintf>
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
c010094a:	eb 6c                	jmp    c01009b8 <print_debuginfo+0xa0>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c010094c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100953:	eb 1b                	jmp    c0100970 <print_debuginfo+0x58>
            fnname[j] = info.eip_fn_name[j];
c0100955:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100958:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010095b:	01 d0                	add    %edx,%eax
c010095d:	0f b6 10             	movzbl (%eax),%edx
c0100960:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100966:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100969:	01 c8                	add    %ecx,%eax
c010096b:	88 10                	mov    %dl,(%eax)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c010096d:	ff 45 f4             	incl   -0xc(%ebp)
c0100970:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100973:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0100976:	7c dd                	jl     c0100955 <print_debuginfo+0x3d>
        fnname[j] = '\0';
c0100978:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c010097e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100981:	01 d0                	add    %edx,%eax
c0100983:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
c0100986:	8b 55 ec             	mov    -0x14(%ebp),%edx
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100989:	8b 45 08             	mov    0x8(%ebp),%eax
c010098c:	29 d0                	sub    %edx,%eax
c010098e:	89 c1                	mov    %eax,%ecx
c0100990:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100993:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100996:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c010099a:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c01009a0:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01009a4:	89 54 24 08          	mov    %edx,0x8(%esp)
c01009a8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009ac:	c7 04 24 76 62 10 c0 	movl   $0xc0106276,(%esp)
c01009b3:	e8 a9 f9 ff ff       	call   c0100361 <cprintf>
}
c01009b8:	90                   	nop
c01009b9:	89 ec                	mov    %ebp,%esp
c01009bb:	5d                   	pop    %ebp
c01009bc:	c3                   	ret    

c01009bd <read_eip>:

static __noinline uint32_t
read_eip(void) {
c01009bd:	55                   	push   %ebp
c01009be:	89 e5                	mov    %esp,%ebp
c01009c0:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c01009c3:	8b 45 04             	mov    0x4(%ebp),%eax
c01009c6:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c01009c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01009cc:	89 ec                	mov    %ebp,%esp
c01009ce:	5d                   	pop    %ebp
c01009cf:	c3                   	ret    

c01009d0 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c01009d0:	55                   	push   %ebp
c01009d1:	89 e5                	mov    %esp,%ebp
c01009d3:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c01009d6:	89 e8                	mov    %ebp,%eax
c01009d8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return ebp;
c01009db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp=read_ebp();
c01009de:	89 45 f4             	mov    %eax,-0xc(%ebp)
    uint32_t eip=read_eip();
c01009e1:	e8 d7 ff ff ff       	call   c01009bd <read_eip>
c01009e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    for(int i=0;i<STACKFRAME_DEPTH && ebp!=0;i++){
c01009e9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01009f0:	e9 a0 00 00 00       	jmp    c0100a95 <print_stackframe+0xc5>
    cprintf("ebp:0x%08x",ebp);
c01009f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009f8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009fc:	c7 04 24 88 62 10 c0 	movl   $0xc0106288,(%esp)
c0100a03:	e8 59 f9 ff ff       	call   c0100361 <cprintf>
    cprintf(" eip:0x%08x",eip);
c0100a08:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100a0b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a0f:	c7 04 24 93 62 10 c0 	movl   $0xc0106293,(%esp)
c0100a16:	e8 46 f9 ff ff       	call   c0100361 <cprintf>
    cprintf(" args:");
c0100a1b:	c7 04 24 9f 62 10 c0 	movl   $0xc010629f,(%esp)
c0100a22:	e8 3a f9 ff ff       	call   c0100361 <cprintf>
    for(int j=1;j<5;j++){
c0100a27:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
c0100a2e:	eb 31                	jmp    c0100a61 <print_stackframe+0x91>
        cprintf("0x%08x",*(uint32_t*)(ebp + 4*j + 4));
c0100a30:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a33:	c1 e0 02             	shl    $0x2,%eax
c0100a36:	89 c2                	mov    %eax,%edx
c0100a38:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a3b:	01 d0                	add    %edx,%eax
c0100a3d:	83 c0 04             	add    $0x4,%eax
c0100a40:	8b 00                	mov    (%eax),%eax
c0100a42:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a46:	c7 04 24 a6 62 10 c0 	movl   $0xc01062a6,(%esp)
c0100a4d:	e8 0f f9 ff ff       	call   c0100361 <cprintf>
        cprintf(" ");
c0100a52:	c7 04 24 ad 62 10 c0 	movl   $0xc01062ad,(%esp)
c0100a59:	e8 03 f9 ff ff       	call   c0100361 <cprintf>
    for(int j=1;j<5;j++){
c0100a5e:	ff 45 e8             	incl   -0x18(%ebp)
c0100a61:	83 7d e8 04          	cmpl   $0x4,-0x18(%ebp)
c0100a65:	7e c9                	jle    c0100a30 <print_stackframe+0x60>
    }
    cprintf("\n");
c0100a67:	c7 04 24 af 62 10 c0 	movl   $0xc01062af,(%esp)
c0100a6e:	e8 ee f8 ff ff       	call   c0100361 <cprintf>
    print_debuginfo(eip-1);
c0100a73:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100a76:	48                   	dec    %eax
c0100a77:	89 04 24             	mov    %eax,(%esp)
c0100a7a:	e8 99 fe ff ff       	call   c0100918 <print_debuginfo>
    eip=*(uint32_t*)(ebp+4);
c0100a7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a82:	83 c0 04             	add    $0x4,%eax
c0100a85:	8b 00                	mov    (%eax),%eax
c0100a87:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ebp=*(uint32_t*)(ebp);
c0100a8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a8d:	8b 00                	mov    (%eax),%eax
c0100a8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for(int i=0;i<STACKFRAME_DEPTH && ebp!=0;i++){
c0100a92:	ff 45 ec             	incl   -0x14(%ebp)
c0100a95:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100a99:	7f 0a                	jg     c0100aa5 <print_stackframe+0xd5>
c0100a9b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100a9f:	0f 85 50 ff ff ff    	jne    c01009f5 <print_stackframe+0x25>
    }
}
c0100aa5:	90                   	nop
c0100aa6:	89 ec                	mov    %ebp,%esp
c0100aa8:	5d                   	pop    %ebp
c0100aa9:	c3                   	ret    

c0100aaa <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100aaa:	55                   	push   %ebp
c0100aab:	89 e5                	mov    %esp,%ebp
c0100aad:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100ab0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100ab7:	eb 0c                	jmp    c0100ac5 <parse+0x1b>
            *buf ++ = '\0';
c0100ab9:	8b 45 08             	mov    0x8(%ebp),%eax
c0100abc:	8d 50 01             	lea    0x1(%eax),%edx
c0100abf:	89 55 08             	mov    %edx,0x8(%ebp)
c0100ac2:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100ac5:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ac8:	0f b6 00             	movzbl (%eax),%eax
c0100acb:	84 c0                	test   %al,%al
c0100acd:	74 1d                	je     c0100aec <parse+0x42>
c0100acf:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ad2:	0f b6 00             	movzbl (%eax),%eax
c0100ad5:	0f be c0             	movsbl %al,%eax
c0100ad8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100adc:	c7 04 24 34 63 10 c0 	movl   $0xc0106334,(%esp)
c0100ae3:	e8 cd 52 00 00       	call   c0105db5 <strchr>
c0100ae8:	85 c0                	test   %eax,%eax
c0100aea:	75 cd                	jne    c0100ab9 <parse+0xf>
        }
        if (*buf == '\0') {
c0100aec:	8b 45 08             	mov    0x8(%ebp),%eax
c0100aef:	0f b6 00             	movzbl (%eax),%eax
c0100af2:	84 c0                	test   %al,%al
c0100af4:	74 65                	je     c0100b5b <parse+0xb1>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100af6:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100afa:	75 14                	jne    c0100b10 <parse+0x66>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100afc:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100b03:	00 
c0100b04:	c7 04 24 39 63 10 c0 	movl   $0xc0106339,(%esp)
c0100b0b:	e8 51 f8 ff ff       	call   c0100361 <cprintf>
        }
        argv[argc ++] = buf;
c0100b10:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b13:	8d 50 01             	lea    0x1(%eax),%edx
c0100b16:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100b19:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100b20:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100b23:	01 c2                	add    %eax,%edx
c0100b25:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b28:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b2a:	eb 03                	jmp    c0100b2f <parse+0x85>
            buf ++;
c0100b2c:	ff 45 08             	incl   0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b2f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b32:	0f b6 00             	movzbl (%eax),%eax
c0100b35:	84 c0                	test   %al,%al
c0100b37:	74 8c                	je     c0100ac5 <parse+0x1b>
c0100b39:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b3c:	0f b6 00             	movzbl (%eax),%eax
c0100b3f:	0f be c0             	movsbl %al,%eax
c0100b42:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b46:	c7 04 24 34 63 10 c0 	movl   $0xc0106334,(%esp)
c0100b4d:	e8 63 52 00 00       	call   c0105db5 <strchr>
c0100b52:	85 c0                	test   %eax,%eax
c0100b54:	74 d6                	je     c0100b2c <parse+0x82>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b56:	e9 6a ff ff ff       	jmp    c0100ac5 <parse+0x1b>
            break;
c0100b5b:	90                   	nop
        }
    }
    return argc;
c0100b5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100b5f:	89 ec                	mov    %ebp,%esp
c0100b61:	5d                   	pop    %ebp
c0100b62:	c3                   	ret    

c0100b63 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100b63:	55                   	push   %ebp
c0100b64:	89 e5                	mov    %esp,%ebp
c0100b66:	83 ec 68             	sub    $0x68,%esp
c0100b69:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100b6c:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100b6f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b73:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b76:	89 04 24             	mov    %eax,(%esp)
c0100b79:	e8 2c ff ff ff       	call   c0100aaa <parse>
c0100b7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100b81:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100b85:	75 0a                	jne    c0100b91 <runcmd+0x2e>
        return 0;
c0100b87:	b8 00 00 00 00       	mov    $0x0,%eax
c0100b8c:	e9 83 00 00 00       	jmp    c0100c14 <runcmd+0xb1>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100b91:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100b98:	eb 5a                	jmp    c0100bf4 <runcmd+0x91>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100b9a:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0100b9d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
c0100ba0:	89 c8                	mov    %ecx,%eax
c0100ba2:	01 c0                	add    %eax,%eax
c0100ba4:	01 c8                	add    %ecx,%eax
c0100ba6:	c1 e0 02             	shl    $0x2,%eax
c0100ba9:	05 00 90 11 c0       	add    $0xc0119000,%eax
c0100bae:	8b 00                	mov    (%eax),%eax
c0100bb0:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100bb4:	89 04 24             	mov    %eax,(%esp)
c0100bb7:	e8 5d 51 00 00       	call   c0105d19 <strcmp>
c0100bbc:	85 c0                	test   %eax,%eax
c0100bbe:	75 31                	jne    c0100bf1 <runcmd+0x8e>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100bc0:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100bc3:	89 d0                	mov    %edx,%eax
c0100bc5:	01 c0                	add    %eax,%eax
c0100bc7:	01 d0                	add    %edx,%eax
c0100bc9:	c1 e0 02             	shl    $0x2,%eax
c0100bcc:	05 08 90 11 c0       	add    $0xc0119008,%eax
c0100bd1:	8b 10                	mov    (%eax),%edx
c0100bd3:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100bd6:	83 c0 04             	add    $0x4,%eax
c0100bd9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0100bdc:	8d 59 ff             	lea    -0x1(%ecx),%ebx
c0100bdf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c0100be2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100be6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bea:	89 1c 24             	mov    %ebx,(%esp)
c0100bed:	ff d2                	call   *%edx
c0100bef:	eb 23                	jmp    c0100c14 <runcmd+0xb1>
    for (i = 0; i < NCOMMANDS; i ++) {
c0100bf1:	ff 45 f4             	incl   -0xc(%ebp)
c0100bf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bf7:	83 f8 02             	cmp    $0x2,%eax
c0100bfa:	76 9e                	jbe    c0100b9a <runcmd+0x37>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100bfc:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100bff:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c03:	c7 04 24 57 63 10 c0 	movl   $0xc0106357,(%esp)
c0100c0a:	e8 52 f7 ff ff       	call   c0100361 <cprintf>
    return 0;
c0100c0f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100c14:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0100c17:	89 ec                	mov    %ebp,%esp
c0100c19:	5d                   	pop    %ebp
c0100c1a:	c3                   	ret    

c0100c1b <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100c1b:	55                   	push   %ebp
c0100c1c:	89 e5                	mov    %esp,%ebp
c0100c1e:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100c21:	c7 04 24 70 63 10 c0 	movl   $0xc0106370,(%esp)
c0100c28:	e8 34 f7 ff ff       	call   c0100361 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100c2d:	c7 04 24 98 63 10 c0 	movl   $0xc0106398,(%esp)
c0100c34:	e8 28 f7 ff ff       	call   c0100361 <cprintf>

    if (tf != NULL) {
c0100c39:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100c3d:	74 0b                	je     c0100c4a <kmonitor+0x2f>
        print_trapframe(tf);
c0100c3f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c42:	89 04 24             	mov    %eax,(%esp)
c0100c45:	e8 ee 0e 00 00       	call   c0101b38 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100c4a:	c7 04 24 bd 63 10 c0 	movl   $0xc01063bd,(%esp)
c0100c51:	e8 fc f5 ff ff       	call   c0100252 <readline>
c0100c56:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100c59:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100c5d:	74 eb                	je     c0100c4a <kmonitor+0x2f>
            if (runcmd(buf, tf) < 0) {
c0100c5f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c62:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c66:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c69:	89 04 24             	mov    %eax,(%esp)
c0100c6c:	e8 f2 fe ff ff       	call   c0100b63 <runcmd>
c0100c71:	85 c0                	test   %eax,%eax
c0100c73:	78 02                	js     c0100c77 <kmonitor+0x5c>
        if ((buf = readline("K> ")) != NULL) {
c0100c75:	eb d3                	jmp    c0100c4a <kmonitor+0x2f>
                break;
c0100c77:	90                   	nop
            }
        }
    }
}
c0100c78:	90                   	nop
c0100c79:	89 ec                	mov    %ebp,%esp
c0100c7b:	5d                   	pop    %ebp
c0100c7c:	c3                   	ret    

c0100c7d <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100c7d:	55                   	push   %ebp
c0100c7e:	89 e5                	mov    %esp,%ebp
c0100c80:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c83:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c8a:	eb 3d                	jmp    c0100cc9 <mon_help+0x4c>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100c8c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c8f:	89 d0                	mov    %edx,%eax
c0100c91:	01 c0                	add    %eax,%eax
c0100c93:	01 d0                	add    %edx,%eax
c0100c95:	c1 e0 02             	shl    $0x2,%eax
c0100c98:	05 04 90 11 c0       	add    $0xc0119004,%eax
c0100c9d:	8b 10                	mov    (%eax),%edx
c0100c9f:	8b 4d f4             	mov    -0xc(%ebp),%ecx
c0100ca2:	89 c8                	mov    %ecx,%eax
c0100ca4:	01 c0                	add    %eax,%eax
c0100ca6:	01 c8                	add    %ecx,%eax
c0100ca8:	c1 e0 02             	shl    $0x2,%eax
c0100cab:	05 00 90 11 c0       	add    $0xc0119000,%eax
c0100cb0:	8b 00                	mov    (%eax),%eax
c0100cb2:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100cb6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100cba:	c7 04 24 c1 63 10 c0 	movl   $0xc01063c1,(%esp)
c0100cc1:	e8 9b f6 ff ff       	call   c0100361 <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
c0100cc6:	ff 45 f4             	incl   -0xc(%ebp)
c0100cc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ccc:	83 f8 02             	cmp    $0x2,%eax
c0100ccf:	76 bb                	jbe    c0100c8c <mon_help+0xf>
    }
    return 0;
c0100cd1:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cd6:	89 ec                	mov    %ebp,%esp
c0100cd8:	5d                   	pop    %ebp
c0100cd9:	c3                   	ret    

c0100cda <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100cda:	55                   	push   %ebp
c0100cdb:	89 e5                	mov    %esp,%ebp
c0100cdd:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100ce0:	e8 9f fb ff ff       	call   c0100884 <print_kerninfo>
    return 0;
c0100ce5:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cea:	89 ec                	mov    %ebp,%esp
c0100cec:	5d                   	pop    %ebp
c0100ced:	c3                   	ret    

c0100cee <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100cee:	55                   	push   %ebp
c0100cef:	89 e5                	mov    %esp,%ebp
c0100cf1:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100cf4:	e8 d7 fc ff ff       	call   c01009d0 <print_stackframe>
    return 0;
c0100cf9:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cfe:	89 ec                	mov    %ebp,%esp
c0100d00:	5d                   	pop    %ebp
c0100d01:	c3                   	ret    

c0100d02 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100d02:	55                   	push   %ebp
c0100d03:	89 e5                	mov    %esp,%ebp
c0100d05:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c0100d08:	a1 20 c4 11 c0       	mov    0xc011c420,%eax
c0100d0d:	85 c0                	test   %eax,%eax
c0100d0f:	75 5b                	jne    c0100d6c <__panic+0x6a>
        goto panic_dead;
    }
    is_panic = 1;
c0100d11:	c7 05 20 c4 11 c0 01 	movl   $0x1,0xc011c420
c0100d18:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100d1b:	8d 45 14             	lea    0x14(%ebp),%eax
c0100d1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100d21:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100d24:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100d28:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d2b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d2f:	c7 04 24 ca 63 10 c0 	movl   $0xc01063ca,(%esp)
c0100d36:	e8 26 f6 ff ff       	call   c0100361 <cprintf>
    vcprintf(fmt, ap);
c0100d3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d3e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d42:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d45:	89 04 24             	mov    %eax,(%esp)
c0100d48:	e8 df f5 ff ff       	call   c010032c <vcprintf>
    cprintf("\n");
c0100d4d:	c7 04 24 e6 63 10 c0 	movl   $0xc01063e6,(%esp)
c0100d54:	e8 08 f6 ff ff       	call   c0100361 <cprintf>
    
    cprintf("stack trackback:\n");
c0100d59:	c7 04 24 e8 63 10 c0 	movl   $0xc01063e8,(%esp)
c0100d60:	e8 fc f5 ff ff       	call   c0100361 <cprintf>
    print_stackframe();
c0100d65:	e8 66 fc ff ff       	call   c01009d0 <print_stackframe>
c0100d6a:	eb 01                	jmp    c0100d6d <__panic+0x6b>
        goto panic_dead;
c0100d6c:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
c0100d6d:	e8 e9 09 00 00       	call   c010175b <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100d72:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100d79:	e8 9d fe ff ff       	call   c0100c1b <kmonitor>
c0100d7e:	eb f2                	jmp    c0100d72 <__panic+0x70>

c0100d80 <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100d80:	55                   	push   %ebp
c0100d81:	89 e5                	mov    %esp,%ebp
c0100d83:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c0100d86:	8d 45 14             	lea    0x14(%ebp),%eax
c0100d89:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100d8c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100d8f:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100d93:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d96:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d9a:	c7 04 24 fa 63 10 c0 	movl   $0xc01063fa,(%esp)
c0100da1:	e8 bb f5 ff ff       	call   c0100361 <cprintf>
    vcprintf(fmt, ap);
c0100da6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100da9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100dad:	8b 45 10             	mov    0x10(%ebp),%eax
c0100db0:	89 04 24             	mov    %eax,(%esp)
c0100db3:	e8 74 f5 ff ff       	call   c010032c <vcprintf>
    cprintf("\n");
c0100db8:	c7 04 24 e6 63 10 c0 	movl   $0xc01063e6,(%esp)
c0100dbf:	e8 9d f5 ff ff       	call   c0100361 <cprintf>
    va_end(ap);
}
c0100dc4:	90                   	nop
c0100dc5:	89 ec                	mov    %ebp,%esp
c0100dc7:	5d                   	pop    %ebp
c0100dc8:	c3                   	ret    

c0100dc9 <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100dc9:	55                   	push   %ebp
c0100dca:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100dcc:	a1 20 c4 11 c0       	mov    0xc011c420,%eax
}
c0100dd1:	5d                   	pop    %ebp
c0100dd2:	c3                   	ret    

c0100dd3 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100dd3:	55                   	push   %ebp
c0100dd4:	89 e5                	mov    %esp,%ebp
c0100dd6:	83 ec 28             	sub    $0x28,%esp
c0100dd9:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
c0100ddf:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100de3:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100de7:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100deb:	ee                   	out    %al,(%dx)
}
c0100dec:	90                   	nop
c0100ded:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100df3:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100df7:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100dfb:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100dff:	ee                   	out    %al,(%dx)
}
c0100e00:	90                   	nop
c0100e01:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
c0100e07:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100e0b:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100e0f:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100e13:	ee                   	out    %al,(%dx)
}
c0100e14:	90                   	nop
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100e15:	c7 05 24 c4 11 c0 00 	movl   $0x0,0xc011c424
c0100e1c:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100e1f:	c7 04 24 18 64 10 c0 	movl   $0xc0106418,(%esp)
c0100e26:	e8 36 f5 ff ff       	call   c0100361 <cprintf>
    pic_enable(IRQ_TIMER);
c0100e2b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100e32:	e8 89 09 00 00       	call   c01017c0 <pic_enable>
}
c0100e37:	90                   	nop
c0100e38:	89 ec                	mov    %ebp,%esp
c0100e3a:	5d                   	pop    %ebp
c0100e3b:	c3                   	ret    

c0100e3c <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100e3c:	55                   	push   %ebp
c0100e3d:	89 e5                	mov    %esp,%ebp
c0100e3f:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100e42:	9c                   	pushf  
c0100e43:	58                   	pop    %eax
c0100e44:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100e47:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100e4a:	25 00 02 00 00       	and    $0x200,%eax
c0100e4f:	85 c0                	test   %eax,%eax
c0100e51:	74 0c                	je     c0100e5f <__intr_save+0x23>
        intr_disable();
c0100e53:	e8 03 09 00 00       	call   c010175b <intr_disable>
        return 1;
c0100e58:	b8 01 00 00 00       	mov    $0x1,%eax
c0100e5d:	eb 05                	jmp    c0100e64 <__intr_save+0x28>
    }
    return 0;
c0100e5f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e64:	89 ec                	mov    %ebp,%esp
c0100e66:	5d                   	pop    %ebp
c0100e67:	c3                   	ret    

c0100e68 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100e68:	55                   	push   %ebp
c0100e69:	89 e5                	mov    %esp,%ebp
c0100e6b:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100e6e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e72:	74 05                	je     c0100e79 <__intr_restore+0x11>
        intr_enable();
c0100e74:	e8 da 08 00 00       	call   c0101753 <intr_enable>
    }
}
c0100e79:	90                   	nop
c0100e7a:	89 ec                	mov    %ebp,%esp
c0100e7c:	5d                   	pop    %ebp
c0100e7d:	c3                   	ret    

c0100e7e <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100e7e:	55                   	push   %ebp
c0100e7f:	89 e5                	mov    %esp,%ebp
c0100e81:	83 ec 10             	sub    $0x10,%esp
c0100e84:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e8a:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100e8e:	89 c2                	mov    %eax,%edx
c0100e90:	ec                   	in     (%dx),%al
c0100e91:	88 45 f1             	mov    %al,-0xf(%ebp)
c0100e94:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100e9a:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e9e:	89 c2                	mov    %eax,%edx
c0100ea0:	ec                   	in     (%dx),%al
c0100ea1:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100ea4:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100eaa:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100eae:	89 c2                	mov    %eax,%edx
c0100eb0:	ec                   	in     (%dx),%al
c0100eb1:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100eb4:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
c0100eba:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100ebe:	89 c2                	mov    %eax,%edx
c0100ec0:	ec                   	in     (%dx),%al
c0100ec1:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100ec4:	90                   	nop
c0100ec5:	89 ec                	mov    %ebp,%esp
c0100ec7:	5d                   	pop    %ebp
c0100ec8:	c3                   	ret    

c0100ec9 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100ec9:	55                   	push   %ebp
c0100eca:	89 e5                	mov    %esp,%ebp
c0100ecc:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100ecf:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100ed6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ed9:	0f b7 00             	movzwl (%eax),%eax
c0100edc:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100ee0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ee3:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100ee8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100eeb:	0f b7 00             	movzwl (%eax),%eax
c0100eee:	0f b7 c0             	movzwl %ax,%eax
c0100ef1:	3d 5a a5 00 00       	cmp    $0xa55a,%eax
c0100ef6:	74 12                	je     c0100f0a <cga_init+0x41>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100ef8:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100eff:	66 c7 05 46 c4 11 c0 	movw   $0x3b4,0xc011c446
c0100f06:	b4 03 
c0100f08:	eb 13                	jmp    c0100f1d <cga_init+0x54>
    } else {
        *cp = was;
c0100f0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f0d:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100f11:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100f14:	66 c7 05 46 c4 11 c0 	movw   $0x3d4,0xc011c446
c0100f1b:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100f1d:	0f b7 05 46 c4 11 c0 	movzwl 0xc011c446,%eax
c0100f24:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c0100f28:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f2c:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100f30:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100f34:	ee                   	out    %al,(%dx)
}
c0100f35:	90                   	nop
    pos = inb(addr_6845 + 1) << 8;
c0100f36:	0f b7 05 46 c4 11 c0 	movzwl 0xc011c446,%eax
c0100f3d:	40                   	inc    %eax
c0100f3e:	0f b7 c0             	movzwl %ax,%eax
c0100f41:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f45:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100f49:	89 c2                	mov    %eax,%edx
c0100f4b:	ec                   	in     (%dx),%al
c0100f4c:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
c0100f4f:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f53:	0f b6 c0             	movzbl %al,%eax
c0100f56:	c1 e0 08             	shl    $0x8,%eax
c0100f59:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100f5c:	0f b7 05 46 c4 11 c0 	movzwl 0xc011c446,%eax
c0100f63:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0100f67:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f6b:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f6f:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100f73:	ee                   	out    %al,(%dx)
}
c0100f74:	90                   	nop
    pos |= inb(addr_6845 + 1);
c0100f75:	0f b7 05 46 c4 11 c0 	movzwl 0xc011c446,%eax
c0100f7c:	40                   	inc    %eax
c0100f7d:	0f b7 c0             	movzwl %ax,%eax
c0100f80:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f84:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100f88:	89 c2                	mov    %eax,%edx
c0100f8a:	ec                   	in     (%dx),%al
c0100f8b:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
c0100f8e:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100f92:	0f b6 c0             	movzbl %al,%eax
c0100f95:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100f98:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f9b:	a3 40 c4 11 c0       	mov    %eax,0xc011c440
    crt_pos = pos;
c0100fa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100fa3:	0f b7 c0             	movzwl %ax,%eax
c0100fa6:	66 a3 44 c4 11 c0    	mov    %ax,0xc011c444
}
c0100fac:	90                   	nop
c0100fad:	89 ec                	mov    %ebp,%esp
c0100faf:	5d                   	pop    %ebp
c0100fb0:	c3                   	ret    

c0100fb1 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100fb1:	55                   	push   %ebp
c0100fb2:	89 e5                	mov    %esp,%ebp
c0100fb4:	83 ec 48             	sub    $0x48,%esp
c0100fb7:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
c0100fbd:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100fc1:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0100fc5:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0100fc9:	ee                   	out    %al,(%dx)
}
c0100fca:	90                   	nop
c0100fcb:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
c0100fd1:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100fd5:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0100fd9:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0100fdd:	ee                   	out    %al,(%dx)
}
c0100fde:	90                   	nop
c0100fdf:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
c0100fe5:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100fe9:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0100fed:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0100ff1:	ee                   	out    %al,(%dx)
}
c0100ff2:	90                   	nop
c0100ff3:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0100ff9:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ffd:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101001:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101005:	ee                   	out    %al,(%dx)
}
c0101006:	90                   	nop
c0101007:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
c010100d:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101011:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101015:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101019:	ee                   	out    %al,(%dx)
}
c010101a:	90                   	nop
c010101b:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
c0101021:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101025:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101029:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c010102d:	ee                   	out    %al,(%dx)
}
c010102e:	90                   	nop
c010102f:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0101035:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101039:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c010103d:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101041:	ee                   	out    %al,(%dx)
}
c0101042:	90                   	nop
c0101043:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101049:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c010104d:	89 c2                	mov    %eax,%edx
c010104f:	ec                   	in     (%dx),%al
c0101050:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0101053:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0101057:	3c ff                	cmp    $0xff,%al
c0101059:	0f 95 c0             	setne  %al
c010105c:	0f b6 c0             	movzbl %al,%eax
c010105f:	a3 48 c4 11 c0       	mov    %eax,0xc011c448
c0101064:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010106a:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c010106e:	89 c2                	mov    %eax,%edx
c0101070:	ec                   	in     (%dx),%al
c0101071:	88 45 f1             	mov    %al,-0xf(%ebp)
c0101074:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c010107a:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010107e:	89 c2                	mov    %eax,%edx
c0101080:	ec                   	in     (%dx),%al
c0101081:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c0101084:	a1 48 c4 11 c0       	mov    0xc011c448,%eax
c0101089:	85 c0                	test   %eax,%eax
c010108b:	74 0c                	je     c0101099 <serial_init+0xe8>
        pic_enable(IRQ_COM1);
c010108d:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0101094:	e8 27 07 00 00       	call   c01017c0 <pic_enable>
    }
}
c0101099:	90                   	nop
c010109a:	89 ec                	mov    %ebp,%esp
c010109c:	5d                   	pop    %ebp
c010109d:	c3                   	ret    

c010109e <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c010109e:	55                   	push   %ebp
c010109f:	89 e5                	mov    %esp,%ebp
c01010a1:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c01010a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01010ab:	eb 08                	jmp    c01010b5 <lpt_putc_sub+0x17>
        delay();
c01010ad:	e8 cc fd ff ff       	call   c0100e7e <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c01010b2:	ff 45 fc             	incl   -0x4(%ebp)
c01010b5:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c01010bb:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01010bf:	89 c2                	mov    %eax,%edx
c01010c1:	ec                   	in     (%dx),%al
c01010c2:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01010c5:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01010c9:	84 c0                	test   %al,%al
c01010cb:	78 09                	js     c01010d6 <lpt_putc_sub+0x38>
c01010cd:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c01010d4:	7e d7                	jle    c01010ad <lpt_putc_sub+0xf>
    }
    outb(LPTPORT + 0, c);
c01010d6:	8b 45 08             	mov    0x8(%ebp),%eax
c01010d9:	0f b6 c0             	movzbl %al,%eax
c01010dc:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
c01010e2:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01010e5:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01010e9:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01010ed:	ee                   	out    %al,(%dx)
}
c01010ee:	90                   	nop
c01010ef:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c01010f5:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01010f9:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01010fd:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101101:	ee                   	out    %al,(%dx)
}
c0101102:	90                   	nop
c0101103:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
c0101109:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010110d:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101111:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101115:	ee                   	out    %al,(%dx)
}
c0101116:	90                   	nop
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c0101117:	90                   	nop
c0101118:	89 ec                	mov    %ebp,%esp
c010111a:	5d                   	pop    %ebp
c010111b:	c3                   	ret    

c010111c <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c010111c:	55                   	push   %ebp
c010111d:	89 e5                	mov    %esp,%ebp
c010111f:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c0101122:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101126:	74 0d                	je     c0101135 <lpt_putc+0x19>
        lpt_putc_sub(c);
c0101128:	8b 45 08             	mov    0x8(%ebp),%eax
c010112b:	89 04 24             	mov    %eax,(%esp)
c010112e:	e8 6b ff ff ff       	call   c010109e <lpt_putc_sub>
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
c0101133:	eb 24                	jmp    c0101159 <lpt_putc+0x3d>
        lpt_putc_sub('\b');
c0101135:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010113c:	e8 5d ff ff ff       	call   c010109e <lpt_putc_sub>
        lpt_putc_sub(' ');
c0101141:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0101148:	e8 51 ff ff ff       	call   c010109e <lpt_putc_sub>
        lpt_putc_sub('\b');
c010114d:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101154:	e8 45 ff ff ff       	call   c010109e <lpt_putc_sub>
}
c0101159:	90                   	nop
c010115a:	89 ec                	mov    %ebp,%esp
c010115c:	5d                   	pop    %ebp
c010115d:	c3                   	ret    

c010115e <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c010115e:	55                   	push   %ebp
c010115f:	89 e5                	mov    %esp,%ebp
c0101161:	83 ec 38             	sub    $0x38,%esp
c0101164:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    // set black on white
    if (!(c & ~0xFF)) {
c0101167:	8b 45 08             	mov    0x8(%ebp),%eax
c010116a:	25 00 ff ff ff       	and    $0xffffff00,%eax
c010116f:	85 c0                	test   %eax,%eax
c0101171:	75 07                	jne    c010117a <cga_putc+0x1c>
        c |= 0x0700;
c0101173:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c010117a:	8b 45 08             	mov    0x8(%ebp),%eax
c010117d:	0f b6 c0             	movzbl %al,%eax
c0101180:	83 f8 0d             	cmp    $0xd,%eax
c0101183:	74 72                	je     c01011f7 <cga_putc+0x99>
c0101185:	83 f8 0d             	cmp    $0xd,%eax
c0101188:	0f 8f a3 00 00 00    	jg     c0101231 <cga_putc+0xd3>
c010118e:	83 f8 08             	cmp    $0x8,%eax
c0101191:	74 0a                	je     c010119d <cga_putc+0x3f>
c0101193:	83 f8 0a             	cmp    $0xa,%eax
c0101196:	74 4c                	je     c01011e4 <cga_putc+0x86>
c0101198:	e9 94 00 00 00       	jmp    c0101231 <cga_putc+0xd3>
    case '\b':
        if (crt_pos > 0) {
c010119d:	0f b7 05 44 c4 11 c0 	movzwl 0xc011c444,%eax
c01011a4:	85 c0                	test   %eax,%eax
c01011a6:	0f 84 af 00 00 00    	je     c010125b <cga_putc+0xfd>
            crt_pos --;
c01011ac:	0f b7 05 44 c4 11 c0 	movzwl 0xc011c444,%eax
c01011b3:	48                   	dec    %eax
c01011b4:	0f b7 c0             	movzwl %ax,%eax
c01011b7:	66 a3 44 c4 11 c0    	mov    %ax,0xc011c444
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c01011bd:	8b 45 08             	mov    0x8(%ebp),%eax
c01011c0:	98                   	cwtl   
c01011c1:	25 00 ff ff ff       	and    $0xffffff00,%eax
c01011c6:	98                   	cwtl   
c01011c7:	83 c8 20             	or     $0x20,%eax
c01011ca:	98                   	cwtl   
c01011cb:	8b 0d 40 c4 11 c0    	mov    0xc011c440,%ecx
c01011d1:	0f b7 15 44 c4 11 c0 	movzwl 0xc011c444,%edx
c01011d8:	01 d2                	add    %edx,%edx
c01011da:	01 ca                	add    %ecx,%edx
c01011dc:	0f b7 c0             	movzwl %ax,%eax
c01011df:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c01011e2:	eb 77                	jmp    c010125b <cga_putc+0xfd>
    case '\n':
        crt_pos += CRT_COLS;
c01011e4:	0f b7 05 44 c4 11 c0 	movzwl 0xc011c444,%eax
c01011eb:	83 c0 50             	add    $0x50,%eax
c01011ee:	0f b7 c0             	movzwl %ax,%eax
c01011f1:	66 a3 44 c4 11 c0    	mov    %ax,0xc011c444
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c01011f7:	0f b7 1d 44 c4 11 c0 	movzwl 0xc011c444,%ebx
c01011fe:	0f b7 0d 44 c4 11 c0 	movzwl 0xc011c444,%ecx
c0101205:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
c010120a:	89 c8                	mov    %ecx,%eax
c010120c:	f7 e2                	mul    %edx
c010120e:	c1 ea 06             	shr    $0x6,%edx
c0101211:	89 d0                	mov    %edx,%eax
c0101213:	c1 e0 02             	shl    $0x2,%eax
c0101216:	01 d0                	add    %edx,%eax
c0101218:	c1 e0 04             	shl    $0x4,%eax
c010121b:	29 c1                	sub    %eax,%ecx
c010121d:	89 ca                	mov    %ecx,%edx
c010121f:	0f b7 d2             	movzwl %dx,%edx
c0101222:	89 d8                	mov    %ebx,%eax
c0101224:	29 d0                	sub    %edx,%eax
c0101226:	0f b7 c0             	movzwl %ax,%eax
c0101229:	66 a3 44 c4 11 c0    	mov    %ax,0xc011c444
        break;
c010122f:	eb 2b                	jmp    c010125c <cga_putc+0xfe>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c0101231:	8b 0d 40 c4 11 c0    	mov    0xc011c440,%ecx
c0101237:	0f b7 05 44 c4 11 c0 	movzwl 0xc011c444,%eax
c010123e:	8d 50 01             	lea    0x1(%eax),%edx
c0101241:	0f b7 d2             	movzwl %dx,%edx
c0101244:	66 89 15 44 c4 11 c0 	mov    %dx,0xc011c444
c010124b:	01 c0                	add    %eax,%eax
c010124d:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c0101250:	8b 45 08             	mov    0x8(%ebp),%eax
c0101253:	0f b7 c0             	movzwl %ax,%eax
c0101256:	66 89 02             	mov    %ax,(%edx)
        break;
c0101259:	eb 01                	jmp    c010125c <cga_putc+0xfe>
        break;
c010125b:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c010125c:	0f b7 05 44 c4 11 c0 	movzwl 0xc011c444,%eax
c0101263:	3d cf 07 00 00       	cmp    $0x7cf,%eax
c0101268:	76 5e                	jbe    c01012c8 <cga_putc+0x16a>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c010126a:	a1 40 c4 11 c0       	mov    0xc011c440,%eax
c010126f:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c0101275:	a1 40 c4 11 c0       	mov    0xc011c440,%eax
c010127a:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c0101281:	00 
c0101282:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101286:	89 04 24             	mov    %eax,(%esp)
c0101289:	e8 25 4d 00 00       	call   c0105fb3 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c010128e:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c0101295:	eb 15                	jmp    c01012ac <cga_putc+0x14e>
            crt_buf[i] = 0x0700 | ' ';
c0101297:	8b 15 40 c4 11 c0    	mov    0xc011c440,%edx
c010129d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01012a0:	01 c0                	add    %eax,%eax
c01012a2:	01 d0                	add    %edx,%eax
c01012a4:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c01012a9:	ff 45 f4             	incl   -0xc(%ebp)
c01012ac:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c01012b3:	7e e2                	jle    c0101297 <cga_putc+0x139>
        }
        crt_pos -= CRT_COLS;
c01012b5:	0f b7 05 44 c4 11 c0 	movzwl 0xc011c444,%eax
c01012bc:	83 e8 50             	sub    $0x50,%eax
c01012bf:	0f b7 c0             	movzwl %ax,%eax
c01012c2:	66 a3 44 c4 11 c0    	mov    %ax,0xc011c444
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c01012c8:	0f b7 05 46 c4 11 c0 	movzwl 0xc011c446,%eax
c01012cf:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c01012d3:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01012d7:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01012db:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01012df:	ee                   	out    %al,(%dx)
}
c01012e0:	90                   	nop
    outb(addr_6845 + 1, crt_pos >> 8);
c01012e1:	0f b7 05 44 c4 11 c0 	movzwl 0xc011c444,%eax
c01012e8:	c1 e8 08             	shr    $0x8,%eax
c01012eb:	0f b7 c0             	movzwl %ax,%eax
c01012ee:	0f b6 c0             	movzbl %al,%eax
c01012f1:	0f b7 15 46 c4 11 c0 	movzwl 0xc011c446,%edx
c01012f8:	42                   	inc    %edx
c01012f9:	0f b7 d2             	movzwl %dx,%edx
c01012fc:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101300:	88 45 e9             	mov    %al,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101303:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101307:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c010130b:	ee                   	out    %al,(%dx)
}
c010130c:	90                   	nop
    outb(addr_6845, 15);
c010130d:	0f b7 05 46 c4 11 c0 	movzwl 0xc011c446,%eax
c0101314:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101318:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010131c:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101320:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101324:	ee                   	out    %al,(%dx)
}
c0101325:	90                   	nop
    outb(addr_6845 + 1, crt_pos);
c0101326:	0f b7 05 44 c4 11 c0 	movzwl 0xc011c444,%eax
c010132d:	0f b6 c0             	movzbl %al,%eax
c0101330:	0f b7 15 46 c4 11 c0 	movzwl 0xc011c446,%edx
c0101337:	42                   	inc    %edx
c0101338:	0f b7 d2             	movzwl %dx,%edx
c010133b:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
c010133f:	88 45 f1             	mov    %al,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101342:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101346:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010134a:	ee                   	out    %al,(%dx)
}
c010134b:	90                   	nop
}
c010134c:	90                   	nop
c010134d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0101350:	89 ec                	mov    %ebp,%esp
c0101352:	5d                   	pop    %ebp
c0101353:	c3                   	ret    

c0101354 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c0101354:	55                   	push   %ebp
c0101355:	89 e5                	mov    %esp,%ebp
c0101357:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c010135a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101361:	eb 08                	jmp    c010136b <serial_putc_sub+0x17>
        delay();
c0101363:	e8 16 fb ff ff       	call   c0100e7e <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c0101368:	ff 45 fc             	incl   -0x4(%ebp)
c010136b:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101371:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101375:	89 c2                	mov    %eax,%edx
c0101377:	ec                   	in     (%dx),%al
c0101378:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c010137b:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c010137f:	0f b6 c0             	movzbl %al,%eax
c0101382:	83 e0 20             	and    $0x20,%eax
c0101385:	85 c0                	test   %eax,%eax
c0101387:	75 09                	jne    c0101392 <serial_putc_sub+0x3e>
c0101389:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101390:	7e d1                	jle    c0101363 <serial_putc_sub+0xf>
    }
    outb(COM1 + COM_TX, c);
c0101392:	8b 45 08             	mov    0x8(%ebp),%eax
c0101395:	0f b6 c0             	movzbl %al,%eax
c0101398:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c010139e:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01013a1:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c01013a5:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c01013a9:	ee                   	out    %al,(%dx)
}
c01013aa:	90                   	nop
}
c01013ab:	90                   	nop
c01013ac:	89 ec                	mov    %ebp,%esp
c01013ae:	5d                   	pop    %ebp
c01013af:	c3                   	ret    

c01013b0 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c01013b0:	55                   	push   %ebp
c01013b1:	89 e5                	mov    %esp,%ebp
c01013b3:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c01013b6:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01013ba:	74 0d                	je     c01013c9 <serial_putc+0x19>
        serial_putc_sub(c);
c01013bc:	8b 45 08             	mov    0x8(%ebp),%eax
c01013bf:	89 04 24             	mov    %eax,(%esp)
c01013c2:	e8 8d ff ff ff       	call   c0101354 <serial_putc_sub>
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
c01013c7:	eb 24                	jmp    c01013ed <serial_putc+0x3d>
        serial_putc_sub('\b');
c01013c9:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01013d0:	e8 7f ff ff ff       	call   c0101354 <serial_putc_sub>
        serial_putc_sub(' ');
c01013d5:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01013dc:	e8 73 ff ff ff       	call   c0101354 <serial_putc_sub>
        serial_putc_sub('\b');
c01013e1:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01013e8:	e8 67 ff ff ff       	call   c0101354 <serial_putc_sub>
}
c01013ed:	90                   	nop
c01013ee:	89 ec                	mov    %ebp,%esp
c01013f0:	5d                   	pop    %ebp
c01013f1:	c3                   	ret    

c01013f2 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c01013f2:	55                   	push   %ebp
c01013f3:	89 e5                	mov    %esp,%ebp
c01013f5:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c01013f8:	eb 33                	jmp    c010142d <cons_intr+0x3b>
        if (c != 0) {
c01013fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01013fe:	74 2d                	je     c010142d <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c0101400:	a1 64 c6 11 c0       	mov    0xc011c664,%eax
c0101405:	8d 50 01             	lea    0x1(%eax),%edx
c0101408:	89 15 64 c6 11 c0    	mov    %edx,0xc011c664
c010140e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101411:	88 90 60 c4 11 c0    	mov    %dl,-0x3fee3ba0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c0101417:	a1 64 c6 11 c0       	mov    0xc011c664,%eax
c010141c:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101421:	75 0a                	jne    c010142d <cons_intr+0x3b>
                cons.wpos = 0;
c0101423:	c7 05 64 c6 11 c0 00 	movl   $0x0,0xc011c664
c010142a:	00 00 00 
    while ((c = (*proc)()) != -1) {
c010142d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101430:	ff d0                	call   *%eax
c0101432:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101435:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c0101439:	75 bf                	jne    c01013fa <cons_intr+0x8>
            }
        }
    }
}
c010143b:	90                   	nop
c010143c:	90                   	nop
c010143d:	89 ec                	mov    %ebp,%esp
c010143f:	5d                   	pop    %ebp
c0101440:	c3                   	ret    

c0101441 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c0101441:	55                   	push   %ebp
c0101442:	89 e5                	mov    %esp,%ebp
c0101444:	83 ec 10             	sub    $0x10,%esp
c0101447:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010144d:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101451:	89 c2                	mov    %eax,%edx
c0101453:	ec                   	in     (%dx),%al
c0101454:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101457:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c010145b:	0f b6 c0             	movzbl %al,%eax
c010145e:	83 e0 01             	and    $0x1,%eax
c0101461:	85 c0                	test   %eax,%eax
c0101463:	75 07                	jne    c010146c <serial_proc_data+0x2b>
        return -1;
c0101465:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010146a:	eb 2a                	jmp    c0101496 <serial_proc_data+0x55>
c010146c:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101472:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101476:	89 c2                	mov    %eax,%edx
c0101478:	ec                   	in     (%dx),%al
c0101479:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c010147c:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c0101480:	0f b6 c0             	movzbl %al,%eax
c0101483:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c0101486:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c010148a:	75 07                	jne    c0101493 <serial_proc_data+0x52>
        c = '\b';
c010148c:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c0101493:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0101496:	89 ec                	mov    %ebp,%esp
c0101498:	5d                   	pop    %ebp
c0101499:	c3                   	ret    

c010149a <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c010149a:	55                   	push   %ebp
c010149b:	89 e5                	mov    %esp,%ebp
c010149d:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c01014a0:	a1 48 c4 11 c0       	mov    0xc011c448,%eax
c01014a5:	85 c0                	test   %eax,%eax
c01014a7:	74 0c                	je     c01014b5 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c01014a9:	c7 04 24 41 14 10 c0 	movl   $0xc0101441,(%esp)
c01014b0:	e8 3d ff ff ff       	call   c01013f2 <cons_intr>
    }
}
c01014b5:	90                   	nop
c01014b6:	89 ec                	mov    %ebp,%esp
c01014b8:	5d                   	pop    %ebp
c01014b9:	c3                   	ret    

c01014ba <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c01014ba:	55                   	push   %ebp
c01014bb:	89 e5                	mov    %esp,%ebp
c01014bd:	83 ec 38             	sub    $0x38,%esp
c01014c0:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01014c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01014c9:	89 c2                	mov    %eax,%edx
c01014cb:	ec                   	in     (%dx),%al
c01014cc:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c01014cf:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c01014d3:	0f b6 c0             	movzbl %al,%eax
c01014d6:	83 e0 01             	and    $0x1,%eax
c01014d9:	85 c0                	test   %eax,%eax
c01014db:	75 0a                	jne    c01014e7 <kbd_proc_data+0x2d>
        return -1;
c01014dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01014e2:	e9 56 01 00 00       	jmp    c010163d <kbd_proc_data+0x183>
c01014e7:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01014ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01014f0:	89 c2                	mov    %eax,%edx
c01014f2:	ec                   	in     (%dx),%al
c01014f3:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c01014f6:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c01014fa:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c01014fd:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c0101501:	75 17                	jne    c010151a <kbd_proc_data+0x60>
        // E0 escape character
        shift |= E0ESC;
c0101503:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c0101508:	83 c8 40             	or     $0x40,%eax
c010150b:	a3 68 c6 11 c0       	mov    %eax,0xc011c668
        return 0;
c0101510:	b8 00 00 00 00       	mov    $0x0,%eax
c0101515:	e9 23 01 00 00       	jmp    c010163d <kbd_proc_data+0x183>
    } else if (data & 0x80) {
c010151a:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010151e:	84 c0                	test   %al,%al
c0101520:	79 45                	jns    c0101567 <kbd_proc_data+0xad>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c0101522:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c0101527:	83 e0 40             	and    $0x40,%eax
c010152a:	85 c0                	test   %eax,%eax
c010152c:	75 08                	jne    c0101536 <kbd_proc_data+0x7c>
c010152e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101532:	24 7f                	and    $0x7f,%al
c0101534:	eb 04                	jmp    c010153a <kbd_proc_data+0x80>
c0101536:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010153a:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c010153d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101541:	0f b6 80 40 90 11 c0 	movzbl -0x3fee6fc0(%eax),%eax
c0101548:	0c 40                	or     $0x40,%al
c010154a:	0f b6 c0             	movzbl %al,%eax
c010154d:	f7 d0                	not    %eax
c010154f:	89 c2                	mov    %eax,%edx
c0101551:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c0101556:	21 d0                	and    %edx,%eax
c0101558:	a3 68 c6 11 c0       	mov    %eax,0xc011c668
        return 0;
c010155d:	b8 00 00 00 00       	mov    $0x0,%eax
c0101562:	e9 d6 00 00 00       	jmp    c010163d <kbd_proc_data+0x183>
    } else if (shift & E0ESC) {
c0101567:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c010156c:	83 e0 40             	and    $0x40,%eax
c010156f:	85 c0                	test   %eax,%eax
c0101571:	74 11                	je     c0101584 <kbd_proc_data+0xca>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c0101573:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c0101577:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c010157c:	83 e0 bf             	and    $0xffffffbf,%eax
c010157f:	a3 68 c6 11 c0       	mov    %eax,0xc011c668
    }

    shift |= shiftcode[data];
c0101584:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101588:	0f b6 80 40 90 11 c0 	movzbl -0x3fee6fc0(%eax),%eax
c010158f:	0f b6 d0             	movzbl %al,%edx
c0101592:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c0101597:	09 d0                	or     %edx,%eax
c0101599:	a3 68 c6 11 c0       	mov    %eax,0xc011c668
    shift ^= togglecode[data];
c010159e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01015a2:	0f b6 80 40 91 11 c0 	movzbl -0x3fee6ec0(%eax),%eax
c01015a9:	0f b6 d0             	movzbl %al,%edx
c01015ac:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c01015b1:	31 d0                	xor    %edx,%eax
c01015b3:	a3 68 c6 11 c0       	mov    %eax,0xc011c668

    c = charcode[shift & (CTL | SHIFT)][data];
c01015b8:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c01015bd:	83 e0 03             	and    $0x3,%eax
c01015c0:	8b 14 85 40 95 11 c0 	mov    -0x3fee6ac0(,%eax,4),%edx
c01015c7:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01015cb:	01 d0                	add    %edx,%eax
c01015cd:	0f b6 00             	movzbl (%eax),%eax
c01015d0:	0f b6 c0             	movzbl %al,%eax
c01015d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c01015d6:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c01015db:	83 e0 08             	and    $0x8,%eax
c01015de:	85 c0                	test   %eax,%eax
c01015e0:	74 22                	je     c0101604 <kbd_proc_data+0x14a>
        if ('a' <= c && c <= 'z')
c01015e2:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c01015e6:	7e 0c                	jle    c01015f4 <kbd_proc_data+0x13a>
c01015e8:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c01015ec:	7f 06                	jg     c01015f4 <kbd_proc_data+0x13a>
            c += 'A' - 'a';
c01015ee:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c01015f2:	eb 10                	jmp    c0101604 <kbd_proc_data+0x14a>
        else if ('A' <= c && c <= 'Z')
c01015f4:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c01015f8:	7e 0a                	jle    c0101604 <kbd_proc_data+0x14a>
c01015fa:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c01015fe:	7f 04                	jg     c0101604 <kbd_proc_data+0x14a>
            c += 'a' - 'A';
c0101600:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c0101604:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c0101609:	f7 d0                	not    %eax
c010160b:	83 e0 06             	and    $0x6,%eax
c010160e:	85 c0                	test   %eax,%eax
c0101610:	75 28                	jne    c010163a <kbd_proc_data+0x180>
c0101612:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c0101619:	75 1f                	jne    c010163a <kbd_proc_data+0x180>
        cprintf("Rebooting!\n");
c010161b:	c7 04 24 33 64 10 c0 	movl   $0xc0106433,(%esp)
c0101622:	e8 3a ed ff ff       	call   c0100361 <cprintf>
c0101627:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c010162d:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101631:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c0101635:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0101638:	ee                   	out    %al,(%dx)
}
c0101639:	90                   	nop
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c010163a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010163d:	89 ec                	mov    %ebp,%esp
c010163f:	5d                   	pop    %ebp
c0101640:	c3                   	ret    

c0101641 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c0101641:	55                   	push   %ebp
c0101642:	89 e5                	mov    %esp,%ebp
c0101644:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c0101647:	c7 04 24 ba 14 10 c0 	movl   $0xc01014ba,(%esp)
c010164e:	e8 9f fd ff ff       	call   c01013f2 <cons_intr>
}
c0101653:	90                   	nop
c0101654:	89 ec                	mov    %ebp,%esp
c0101656:	5d                   	pop    %ebp
c0101657:	c3                   	ret    

c0101658 <kbd_init>:

static void
kbd_init(void) {
c0101658:	55                   	push   %ebp
c0101659:	89 e5                	mov    %esp,%ebp
c010165b:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c010165e:	e8 de ff ff ff       	call   c0101641 <kbd_intr>
    pic_enable(IRQ_KBD);
c0101663:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010166a:	e8 51 01 00 00       	call   c01017c0 <pic_enable>
}
c010166f:	90                   	nop
c0101670:	89 ec                	mov    %ebp,%esp
c0101672:	5d                   	pop    %ebp
c0101673:	c3                   	ret    

c0101674 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c0101674:	55                   	push   %ebp
c0101675:	89 e5                	mov    %esp,%ebp
c0101677:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c010167a:	e8 4a f8 ff ff       	call   c0100ec9 <cga_init>
    serial_init();
c010167f:	e8 2d f9 ff ff       	call   c0100fb1 <serial_init>
    kbd_init();
c0101684:	e8 cf ff ff ff       	call   c0101658 <kbd_init>
    if (!serial_exists) {
c0101689:	a1 48 c4 11 c0       	mov    0xc011c448,%eax
c010168e:	85 c0                	test   %eax,%eax
c0101690:	75 0c                	jne    c010169e <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c0101692:	c7 04 24 3f 64 10 c0 	movl   $0xc010643f,(%esp)
c0101699:	e8 c3 ec ff ff       	call   c0100361 <cprintf>
    }
}
c010169e:	90                   	nop
c010169f:	89 ec                	mov    %ebp,%esp
c01016a1:	5d                   	pop    %ebp
c01016a2:	c3                   	ret    

c01016a3 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c01016a3:	55                   	push   %ebp
c01016a4:	89 e5                	mov    %esp,%ebp
c01016a6:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c01016a9:	e8 8e f7 ff ff       	call   c0100e3c <__intr_save>
c01016ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c01016b1:	8b 45 08             	mov    0x8(%ebp),%eax
c01016b4:	89 04 24             	mov    %eax,(%esp)
c01016b7:	e8 60 fa ff ff       	call   c010111c <lpt_putc>
        cga_putc(c);
c01016bc:	8b 45 08             	mov    0x8(%ebp),%eax
c01016bf:	89 04 24             	mov    %eax,(%esp)
c01016c2:	e8 97 fa ff ff       	call   c010115e <cga_putc>
        serial_putc(c);
c01016c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01016ca:	89 04 24             	mov    %eax,(%esp)
c01016cd:	e8 de fc ff ff       	call   c01013b0 <serial_putc>
    }
    local_intr_restore(intr_flag);
c01016d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01016d5:	89 04 24             	mov    %eax,(%esp)
c01016d8:	e8 8b f7 ff ff       	call   c0100e68 <__intr_restore>
}
c01016dd:	90                   	nop
c01016de:	89 ec                	mov    %ebp,%esp
c01016e0:	5d                   	pop    %ebp
c01016e1:	c3                   	ret    

c01016e2 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c01016e2:	55                   	push   %ebp
c01016e3:	89 e5                	mov    %esp,%ebp
c01016e5:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c01016e8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c01016ef:	e8 48 f7 ff ff       	call   c0100e3c <__intr_save>
c01016f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c01016f7:	e8 9e fd ff ff       	call   c010149a <serial_intr>
        kbd_intr();
c01016fc:	e8 40 ff ff ff       	call   c0101641 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c0101701:	8b 15 60 c6 11 c0    	mov    0xc011c660,%edx
c0101707:	a1 64 c6 11 c0       	mov    0xc011c664,%eax
c010170c:	39 c2                	cmp    %eax,%edx
c010170e:	74 31                	je     c0101741 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c0101710:	a1 60 c6 11 c0       	mov    0xc011c660,%eax
c0101715:	8d 50 01             	lea    0x1(%eax),%edx
c0101718:	89 15 60 c6 11 c0    	mov    %edx,0xc011c660
c010171e:	0f b6 80 60 c4 11 c0 	movzbl -0x3fee3ba0(%eax),%eax
c0101725:	0f b6 c0             	movzbl %al,%eax
c0101728:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c010172b:	a1 60 c6 11 c0       	mov    0xc011c660,%eax
c0101730:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101735:	75 0a                	jne    c0101741 <cons_getc+0x5f>
                cons.rpos = 0;
c0101737:	c7 05 60 c6 11 c0 00 	movl   $0x0,0xc011c660
c010173e:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c0101741:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101744:	89 04 24             	mov    %eax,(%esp)
c0101747:	e8 1c f7 ff ff       	call   c0100e68 <__intr_restore>
    return c;
c010174c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010174f:	89 ec                	mov    %ebp,%esp
c0101751:	5d                   	pop    %ebp
c0101752:	c3                   	ret    

c0101753 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c0101753:	55                   	push   %ebp
c0101754:	89 e5                	mov    %esp,%ebp
    asm volatile ("sti");
c0101756:	fb                   	sti    
}
c0101757:	90                   	nop
    sti();
}
c0101758:	90                   	nop
c0101759:	5d                   	pop    %ebp
c010175a:	c3                   	ret    

c010175b <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c010175b:	55                   	push   %ebp
c010175c:	89 e5                	mov    %esp,%ebp
    asm volatile ("cli" ::: "memory");
c010175e:	fa                   	cli    
}
c010175f:	90                   	nop
    cli();
}
c0101760:	90                   	nop
c0101761:	5d                   	pop    %ebp
c0101762:	c3                   	ret    

c0101763 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c0101763:	55                   	push   %ebp
c0101764:	89 e5                	mov    %esp,%ebp
c0101766:	83 ec 14             	sub    $0x14,%esp
c0101769:	8b 45 08             	mov    0x8(%ebp),%eax
c010176c:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c0101770:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101773:	66 a3 50 95 11 c0    	mov    %ax,0xc0119550
    if (did_init) {
c0101779:	a1 6c c6 11 c0       	mov    0xc011c66c,%eax
c010177e:	85 c0                	test   %eax,%eax
c0101780:	74 39                	je     c01017bb <pic_setmask+0x58>
        outb(IO_PIC1 + 1, mask);
c0101782:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101785:	0f b6 c0             	movzbl %al,%eax
c0101788:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
c010178e:	88 45 f9             	mov    %al,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101791:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101795:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101799:	ee                   	out    %al,(%dx)
}
c010179a:	90                   	nop
        outb(IO_PIC2 + 1, mask >> 8);
c010179b:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c010179f:	c1 e8 08             	shr    $0x8,%eax
c01017a2:	0f b7 c0             	movzwl %ax,%eax
c01017a5:	0f b6 c0             	movzbl %al,%eax
c01017a8:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
c01017ae:	88 45 fd             	mov    %al,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01017b1:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c01017b5:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c01017b9:	ee                   	out    %al,(%dx)
}
c01017ba:	90                   	nop
    }
}
c01017bb:	90                   	nop
c01017bc:	89 ec                	mov    %ebp,%esp
c01017be:	5d                   	pop    %ebp
c01017bf:	c3                   	ret    

c01017c0 <pic_enable>:

void
pic_enable(unsigned int irq) {
c01017c0:	55                   	push   %ebp
c01017c1:	89 e5                	mov    %esp,%ebp
c01017c3:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c01017c6:	8b 45 08             	mov    0x8(%ebp),%eax
c01017c9:	ba 01 00 00 00       	mov    $0x1,%edx
c01017ce:	88 c1                	mov    %al,%cl
c01017d0:	d3 e2                	shl    %cl,%edx
c01017d2:	89 d0                	mov    %edx,%eax
c01017d4:	98                   	cwtl   
c01017d5:	f7 d0                	not    %eax
c01017d7:	0f bf d0             	movswl %ax,%edx
c01017da:	0f b7 05 50 95 11 c0 	movzwl 0xc0119550,%eax
c01017e1:	98                   	cwtl   
c01017e2:	21 d0                	and    %edx,%eax
c01017e4:	98                   	cwtl   
c01017e5:	0f b7 c0             	movzwl %ax,%eax
c01017e8:	89 04 24             	mov    %eax,(%esp)
c01017eb:	e8 73 ff ff ff       	call   c0101763 <pic_setmask>
}
c01017f0:	90                   	nop
c01017f1:	89 ec                	mov    %ebp,%esp
c01017f3:	5d                   	pop    %ebp
c01017f4:	c3                   	ret    

c01017f5 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c01017f5:	55                   	push   %ebp
c01017f6:	89 e5                	mov    %esp,%ebp
c01017f8:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c01017fb:	c7 05 6c c6 11 c0 01 	movl   $0x1,0xc011c66c
c0101802:	00 00 00 
c0101805:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
c010180b:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010180f:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c0101813:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c0101817:	ee                   	out    %al,(%dx)
}
c0101818:	90                   	nop
c0101819:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
c010181f:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101823:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c0101827:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c010182b:	ee                   	out    %al,(%dx)
}
c010182c:	90                   	nop
c010182d:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c0101833:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101837:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c010183b:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c010183f:	ee                   	out    %al,(%dx)
}
c0101840:	90                   	nop
c0101841:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
c0101847:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010184b:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c010184f:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101853:	ee                   	out    %al,(%dx)
}
c0101854:	90                   	nop
c0101855:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
c010185b:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010185f:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101863:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101867:	ee                   	out    %al,(%dx)
}
c0101868:	90                   	nop
c0101869:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
c010186f:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101873:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101877:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c010187b:	ee                   	out    %al,(%dx)
}
c010187c:	90                   	nop
c010187d:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
c0101883:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101887:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c010188b:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c010188f:	ee                   	out    %al,(%dx)
}
c0101890:	90                   	nop
c0101891:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
c0101897:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010189b:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c010189f:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01018a3:	ee                   	out    %al,(%dx)
}
c01018a4:	90                   	nop
c01018a5:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
c01018ab:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01018af:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01018b3:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01018b7:	ee                   	out    %al,(%dx)
}
c01018b8:	90                   	nop
c01018b9:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
c01018bf:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01018c3:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01018c7:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01018cb:	ee                   	out    %al,(%dx)
}
c01018cc:	90                   	nop
c01018cd:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
c01018d3:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01018d7:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01018db:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01018df:	ee                   	out    %al,(%dx)
}
c01018e0:	90                   	nop
c01018e1:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c01018e7:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01018eb:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c01018ef:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c01018f3:	ee                   	out    %al,(%dx)
}
c01018f4:	90                   	nop
c01018f5:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
c01018fb:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01018ff:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101903:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101907:	ee                   	out    %al,(%dx)
}
c0101908:	90                   	nop
c0101909:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
c010190f:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101913:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101917:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c010191b:	ee                   	out    %al,(%dx)
}
c010191c:	90                   	nop
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c010191d:	0f b7 05 50 95 11 c0 	movzwl 0xc0119550,%eax
c0101924:	3d ff ff 00 00       	cmp    $0xffff,%eax
c0101929:	74 0f                	je     c010193a <pic_init+0x145>
        pic_setmask(irq_mask);
c010192b:	0f b7 05 50 95 11 c0 	movzwl 0xc0119550,%eax
c0101932:	89 04 24             	mov    %eax,(%esp)
c0101935:	e8 29 fe ff ff       	call   c0101763 <pic_setmask>
    }
}
c010193a:	90                   	nop
c010193b:	89 ec                	mov    %ebp,%esp
c010193d:	5d                   	pop    %ebp
c010193e:	c3                   	ret    

c010193f <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c010193f:	55                   	push   %ebp
c0101940:	89 e5                	mov    %esp,%ebp
c0101942:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c0101945:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c010194c:	00 
c010194d:	c7 04 24 60 64 10 c0 	movl   $0xc0106460,(%esp)
c0101954:	e8 08 ea ff ff       	call   c0100361 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
c0101959:	c7 04 24 6a 64 10 c0 	movl   $0xc010646a,(%esp)
c0101960:	e8 fc e9 ff ff       	call   c0100361 <cprintf>
    panic("EOT: kernel seems ok.");
c0101965:	c7 44 24 08 78 64 10 	movl   $0xc0106478,0x8(%esp)
c010196c:	c0 
c010196d:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
c0101974:	00 
c0101975:	c7 04 24 8e 64 10 c0 	movl   $0xc010648e,(%esp)
c010197c:	e8 81 f3 ff ff       	call   c0100d02 <__panic>

c0101981 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c0101981:	55                   	push   %ebp
c0101982:	89 e5                	mov    %esp,%ebp
c0101984:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
     extern uintptr_t __vectors[];
     int i;
     for(i = 0; i < 256; i++){
c0101987:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c010198e:	e9 c1 00 00 00       	jmp    c0101a54 <idt_init+0xd3>
        SETGATE(idt[i], 1, GD_KTEXT, __vectors[i], DPL_KERNEL);
c0101993:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101996:	8b 04 85 e0 95 11 c0 	mov    -0x3fee6a20(,%eax,4),%eax
c010199d:	0f b7 d0             	movzwl %ax,%edx
c01019a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019a3:	66 89 14 c5 80 c6 11 	mov    %dx,-0x3fee3980(,%eax,8)
c01019aa:	c0 
c01019ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019ae:	66 c7 04 c5 82 c6 11 	movw   $0x8,-0x3fee397e(,%eax,8)
c01019b5:	c0 08 00 
c01019b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019bb:	0f b6 14 c5 84 c6 11 	movzbl -0x3fee397c(,%eax,8),%edx
c01019c2:	c0 
c01019c3:	80 e2 e0             	and    $0xe0,%dl
c01019c6:	88 14 c5 84 c6 11 c0 	mov    %dl,-0x3fee397c(,%eax,8)
c01019cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019d0:	0f b6 14 c5 84 c6 11 	movzbl -0x3fee397c(,%eax,8),%edx
c01019d7:	c0 
c01019d8:	80 e2 1f             	and    $0x1f,%dl
c01019db:	88 14 c5 84 c6 11 c0 	mov    %dl,-0x3fee397c(,%eax,8)
c01019e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019e5:	0f b6 14 c5 85 c6 11 	movzbl -0x3fee397b(,%eax,8),%edx
c01019ec:	c0 
c01019ed:	80 ca 0f             	or     $0xf,%dl
c01019f0:	88 14 c5 85 c6 11 c0 	mov    %dl,-0x3fee397b(,%eax,8)
c01019f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019fa:	0f b6 14 c5 85 c6 11 	movzbl -0x3fee397b(,%eax,8),%edx
c0101a01:	c0 
c0101a02:	80 e2 ef             	and    $0xef,%dl
c0101a05:	88 14 c5 85 c6 11 c0 	mov    %dl,-0x3fee397b(,%eax,8)
c0101a0c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a0f:	0f b6 14 c5 85 c6 11 	movzbl -0x3fee397b(,%eax,8),%edx
c0101a16:	c0 
c0101a17:	80 e2 9f             	and    $0x9f,%dl
c0101a1a:	88 14 c5 85 c6 11 c0 	mov    %dl,-0x3fee397b(,%eax,8)
c0101a21:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a24:	0f b6 14 c5 85 c6 11 	movzbl -0x3fee397b(,%eax,8),%edx
c0101a2b:	c0 
c0101a2c:	80 ca 80             	or     $0x80,%dl
c0101a2f:	88 14 c5 85 c6 11 c0 	mov    %dl,-0x3fee397b(,%eax,8)
c0101a36:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a39:	8b 04 85 e0 95 11 c0 	mov    -0x3fee6a20(,%eax,4),%eax
c0101a40:	c1 e8 10             	shr    $0x10,%eax
c0101a43:	0f b7 d0             	movzwl %ax,%edx
c0101a46:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a49:	66 89 14 c5 86 c6 11 	mov    %dx,-0x3fee397a(,%eax,8)
c0101a50:	c0 
     for(i = 0; i < 256; i++){
c0101a51:	ff 45 fc             	incl   -0x4(%ebp)
c0101a54:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
c0101a5b:	0f 8e 32 ff ff ff    	jle    c0101993 <idt_init+0x12>
     }
     SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
c0101a61:	a1 c4 97 11 c0       	mov    0xc01197c4,%eax
c0101a66:	0f b7 c0             	movzwl %ax,%eax
c0101a69:	66 a3 48 ca 11 c0    	mov    %ax,0xc011ca48
c0101a6f:	66 c7 05 4a ca 11 c0 	movw   $0x8,0xc011ca4a
c0101a76:	08 00 
c0101a78:	0f b6 05 4c ca 11 c0 	movzbl 0xc011ca4c,%eax
c0101a7f:	24 e0                	and    $0xe0,%al
c0101a81:	a2 4c ca 11 c0       	mov    %al,0xc011ca4c
c0101a86:	0f b6 05 4c ca 11 c0 	movzbl 0xc011ca4c,%eax
c0101a8d:	24 1f                	and    $0x1f,%al
c0101a8f:	a2 4c ca 11 c0       	mov    %al,0xc011ca4c
c0101a94:	0f b6 05 4d ca 11 c0 	movzbl 0xc011ca4d,%eax
c0101a9b:	24 f0                	and    $0xf0,%al
c0101a9d:	0c 0e                	or     $0xe,%al
c0101a9f:	a2 4d ca 11 c0       	mov    %al,0xc011ca4d
c0101aa4:	0f b6 05 4d ca 11 c0 	movzbl 0xc011ca4d,%eax
c0101aab:	24 ef                	and    $0xef,%al
c0101aad:	a2 4d ca 11 c0       	mov    %al,0xc011ca4d
c0101ab2:	0f b6 05 4d ca 11 c0 	movzbl 0xc011ca4d,%eax
c0101ab9:	0c 60                	or     $0x60,%al
c0101abb:	a2 4d ca 11 c0       	mov    %al,0xc011ca4d
c0101ac0:	0f b6 05 4d ca 11 c0 	movzbl 0xc011ca4d,%eax
c0101ac7:	0c 80                	or     $0x80,%al
c0101ac9:	a2 4d ca 11 c0       	mov    %al,0xc011ca4d
c0101ace:	a1 c4 97 11 c0       	mov    0xc01197c4,%eax
c0101ad3:	c1 e8 10             	shr    $0x10,%eax
c0101ad6:	0f b7 c0             	movzwl %ax,%eax
c0101ad9:	66 a3 4e ca 11 c0    	mov    %ax,0xc011ca4e
c0101adf:	c7 45 f8 60 95 11 c0 	movl   $0xc0119560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c0101ae6:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101ae9:	0f 01 18             	lidtl  (%eax)
}
c0101aec:	90                   	nop
     //SETGATE(idt[T_SWITCH_TOU], 0, GD_KTEXT, __vectors[T_SWITCH_TOU], DPL_KERNEL);
     lidt(&idt_pd);
}
c0101aed:	90                   	nop
c0101aee:	89 ec                	mov    %ebp,%esp
c0101af0:	5d                   	pop    %ebp
c0101af1:	c3                   	ret    

c0101af2 <trapname>:

static const char *
trapname(int trapno) {
c0101af2:	55                   	push   %ebp
c0101af3:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c0101af5:	8b 45 08             	mov    0x8(%ebp),%eax
c0101af8:	83 f8 13             	cmp    $0x13,%eax
c0101afb:	77 0c                	ja     c0101b09 <trapname+0x17>
        return excnames[trapno];
c0101afd:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b00:	8b 04 85 e0 67 10 c0 	mov    -0x3fef9820(,%eax,4),%eax
c0101b07:	eb 18                	jmp    c0101b21 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0101b09:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0101b0d:	7e 0d                	jle    c0101b1c <trapname+0x2a>
c0101b0f:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0101b13:	7f 07                	jg     c0101b1c <trapname+0x2a>
        return "Hardware Interrupt";
c0101b15:	b8 9f 64 10 c0       	mov    $0xc010649f,%eax
c0101b1a:	eb 05                	jmp    c0101b21 <trapname+0x2f>
    }
    return "(unknown trap)";
c0101b1c:	b8 b2 64 10 c0       	mov    $0xc01064b2,%eax
}
c0101b21:	5d                   	pop    %ebp
c0101b22:	c3                   	ret    

c0101b23 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c0101b23:	55                   	push   %ebp
c0101b24:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c0101b26:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b29:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101b2d:	83 f8 08             	cmp    $0x8,%eax
c0101b30:	0f 94 c0             	sete   %al
c0101b33:	0f b6 c0             	movzbl %al,%eax
}
c0101b36:	5d                   	pop    %ebp
c0101b37:	c3                   	ret    

c0101b38 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0101b38:	55                   	push   %ebp
c0101b39:	89 e5                	mov    %esp,%ebp
c0101b3b:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c0101b3e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b41:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b45:	c7 04 24 f3 64 10 c0 	movl   $0xc01064f3,(%esp)
c0101b4c:	e8 10 e8 ff ff       	call   c0100361 <cprintf>
    print_regs(&tf->tf_regs);
c0101b51:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b54:	89 04 24             	mov    %eax,(%esp)
c0101b57:	e8 8f 01 00 00       	call   c0101ceb <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101b5c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b5f:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101b63:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b67:	c7 04 24 04 65 10 c0 	movl   $0xc0106504,(%esp)
c0101b6e:	e8 ee e7 ff ff       	call   c0100361 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101b73:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b76:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101b7a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b7e:	c7 04 24 17 65 10 c0 	movl   $0xc0106517,(%esp)
c0101b85:	e8 d7 e7 ff ff       	call   c0100361 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101b8a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b8d:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101b91:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b95:	c7 04 24 2a 65 10 c0 	movl   $0xc010652a,(%esp)
c0101b9c:	e8 c0 e7 ff ff       	call   c0100361 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101ba1:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ba4:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101ba8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bac:	c7 04 24 3d 65 10 c0 	movl   $0xc010653d,(%esp)
c0101bb3:	e8 a9 e7 ff ff       	call   c0100361 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0101bb8:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bbb:	8b 40 30             	mov    0x30(%eax),%eax
c0101bbe:	89 04 24             	mov    %eax,(%esp)
c0101bc1:	e8 2c ff ff ff       	call   c0101af2 <trapname>
c0101bc6:	8b 55 08             	mov    0x8(%ebp),%edx
c0101bc9:	8b 52 30             	mov    0x30(%edx),%edx
c0101bcc:	89 44 24 08          	mov    %eax,0x8(%esp)
c0101bd0:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101bd4:	c7 04 24 50 65 10 c0 	movl   $0xc0106550,(%esp)
c0101bdb:	e8 81 e7 ff ff       	call   c0100361 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101be0:	8b 45 08             	mov    0x8(%ebp),%eax
c0101be3:	8b 40 34             	mov    0x34(%eax),%eax
c0101be6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bea:	c7 04 24 62 65 10 c0 	movl   $0xc0106562,(%esp)
c0101bf1:	e8 6b e7 ff ff       	call   c0100361 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101bf6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bf9:	8b 40 38             	mov    0x38(%eax),%eax
c0101bfc:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c00:	c7 04 24 71 65 10 c0 	movl   $0xc0106571,(%esp)
c0101c07:	e8 55 e7 ff ff       	call   c0100361 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101c0c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c0f:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101c13:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c17:	c7 04 24 80 65 10 c0 	movl   $0xc0106580,(%esp)
c0101c1e:	e8 3e e7 ff ff       	call   c0100361 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101c23:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c26:	8b 40 40             	mov    0x40(%eax),%eax
c0101c29:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c2d:	c7 04 24 93 65 10 c0 	movl   $0xc0106593,(%esp)
c0101c34:	e8 28 e7 ff ff       	call   c0100361 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101c39:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101c40:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101c47:	eb 3d                	jmp    c0101c86 <print_trapframe+0x14e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0101c49:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c4c:	8b 50 40             	mov    0x40(%eax),%edx
c0101c4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101c52:	21 d0                	and    %edx,%eax
c0101c54:	85 c0                	test   %eax,%eax
c0101c56:	74 28                	je     c0101c80 <print_trapframe+0x148>
c0101c58:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c5b:	8b 04 85 80 95 11 c0 	mov    -0x3fee6a80(,%eax,4),%eax
c0101c62:	85 c0                	test   %eax,%eax
c0101c64:	74 1a                	je     c0101c80 <print_trapframe+0x148>
            cprintf("%s,", IA32flags[i]);
c0101c66:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c69:	8b 04 85 80 95 11 c0 	mov    -0x3fee6a80(,%eax,4),%eax
c0101c70:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c74:	c7 04 24 a2 65 10 c0 	movl   $0xc01065a2,(%esp)
c0101c7b:	e8 e1 e6 ff ff       	call   c0100361 <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101c80:	ff 45 f4             	incl   -0xc(%ebp)
c0101c83:	d1 65 f0             	shll   -0x10(%ebp)
c0101c86:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c89:	83 f8 17             	cmp    $0x17,%eax
c0101c8c:	76 bb                	jbe    c0101c49 <print_trapframe+0x111>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101c8e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c91:	8b 40 40             	mov    0x40(%eax),%eax
c0101c94:	c1 e8 0c             	shr    $0xc,%eax
c0101c97:	83 e0 03             	and    $0x3,%eax
c0101c9a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c9e:	c7 04 24 a6 65 10 c0 	movl   $0xc01065a6,(%esp)
c0101ca5:	e8 b7 e6 ff ff       	call   c0100361 <cprintf>

    if (!trap_in_kernel(tf)) {
c0101caa:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cad:	89 04 24             	mov    %eax,(%esp)
c0101cb0:	e8 6e fe ff ff       	call   c0101b23 <trap_in_kernel>
c0101cb5:	85 c0                	test   %eax,%eax
c0101cb7:	75 2d                	jne    c0101ce6 <print_trapframe+0x1ae>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0101cb9:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cbc:	8b 40 44             	mov    0x44(%eax),%eax
c0101cbf:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cc3:	c7 04 24 af 65 10 c0 	movl   $0xc01065af,(%esp)
c0101cca:	e8 92 e6 ff ff       	call   c0100361 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101ccf:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cd2:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101cd6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cda:	c7 04 24 be 65 10 c0 	movl   $0xc01065be,(%esp)
c0101ce1:	e8 7b e6 ff ff       	call   c0100361 <cprintf>
    }
}
c0101ce6:	90                   	nop
c0101ce7:	89 ec                	mov    %ebp,%esp
c0101ce9:	5d                   	pop    %ebp
c0101cea:	c3                   	ret    

c0101ceb <print_regs>:

void
print_regs(struct pushregs *regs) {
c0101ceb:	55                   	push   %ebp
c0101cec:	89 e5                	mov    %esp,%ebp
c0101cee:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0101cf1:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cf4:	8b 00                	mov    (%eax),%eax
c0101cf6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cfa:	c7 04 24 d1 65 10 c0 	movl   $0xc01065d1,(%esp)
c0101d01:	e8 5b e6 ff ff       	call   c0100361 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101d06:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d09:	8b 40 04             	mov    0x4(%eax),%eax
c0101d0c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d10:	c7 04 24 e0 65 10 c0 	movl   $0xc01065e0,(%esp)
c0101d17:	e8 45 e6 ff ff       	call   c0100361 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101d1c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d1f:	8b 40 08             	mov    0x8(%eax),%eax
c0101d22:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d26:	c7 04 24 ef 65 10 c0 	movl   $0xc01065ef,(%esp)
c0101d2d:	e8 2f e6 ff ff       	call   c0100361 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101d32:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d35:	8b 40 0c             	mov    0xc(%eax),%eax
c0101d38:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d3c:	c7 04 24 fe 65 10 c0 	movl   $0xc01065fe,(%esp)
c0101d43:	e8 19 e6 ff ff       	call   c0100361 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101d48:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d4b:	8b 40 10             	mov    0x10(%eax),%eax
c0101d4e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d52:	c7 04 24 0d 66 10 c0 	movl   $0xc010660d,(%esp)
c0101d59:	e8 03 e6 ff ff       	call   c0100361 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101d5e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d61:	8b 40 14             	mov    0x14(%eax),%eax
c0101d64:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d68:	c7 04 24 1c 66 10 c0 	movl   $0xc010661c,(%esp)
c0101d6f:	e8 ed e5 ff ff       	call   c0100361 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101d74:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d77:	8b 40 18             	mov    0x18(%eax),%eax
c0101d7a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d7e:	c7 04 24 2b 66 10 c0 	movl   $0xc010662b,(%esp)
c0101d85:	e8 d7 e5 ff ff       	call   c0100361 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101d8a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d8d:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101d90:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d94:	c7 04 24 3a 66 10 c0 	movl   $0xc010663a,(%esp)
c0101d9b:	e8 c1 e5 ff ff       	call   c0100361 <cprintf>
}
c0101da0:	90                   	nop
c0101da1:	89 ec                	mov    %ebp,%esp
c0101da3:	5d                   	pop    %ebp
c0101da4:	c3                   	ret    

c0101da5 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
c0101da5:	55                   	push   %ebp
c0101da6:	89 e5                	mov    %esp,%ebp
c0101da8:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
c0101dab:	8b 45 08             	mov    0x8(%ebp),%eax
c0101dae:	8b 40 30             	mov    0x30(%eax),%eax
c0101db1:	83 f8 79             	cmp    $0x79,%eax
c0101db4:	0f 87 e6 00 00 00    	ja     c0101ea0 <trap_dispatch+0xfb>
c0101dba:	83 f8 78             	cmp    $0x78,%eax
c0101dbd:	0f 83 c1 00 00 00    	jae    c0101e84 <trap_dispatch+0xdf>
c0101dc3:	83 f8 2f             	cmp    $0x2f,%eax
c0101dc6:	0f 87 d4 00 00 00    	ja     c0101ea0 <trap_dispatch+0xfb>
c0101dcc:	83 f8 2e             	cmp    $0x2e,%eax
c0101dcf:	0f 83 00 01 00 00    	jae    c0101ed5 <trap_dispatch+0x130>
c0101dd5:	83 f8 24             	cmp    $0x24,%eax
c0101dd8:	74 5e                	je     c0101e38 <trap_dispatch+0x93>
c0101dda:	83 f8 24             	cmp    $0x24,%eax
c0101ddd:	0f 87 bd 00 00 00    	ja     c0101ea0 <trap_dispatch+0xfb>
c0101de3:	83 f8 20             	cmp    $0x20,%eax
c0101de6:	74 0a                	je     c0101df2 <trap_dispatch+0x4d>
c0101de8:	83 f8 21             	cmp    $0x21,%eax
c0101deb:	74 71                	je     c0101e5e <trap_dispatch+0xb9>
c0101ded:	e9 ae 00 00 00       	jmp    c0101ea0 <trap_dispatch+0xfb>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks++;
c0101df2:	a1 24 c4 11 c0       	mov    0xc011c424,%eax
c0101df7:	40                   	inc    %eax
c0101df8:	a3 24 c4 11 c0       	mov    %eax,0xc011c424
        if (ticks % TICK_NUM == 0){
c0101dfd:	8b 0d 24 c4 11 c0    	mov    0xc011c424,%ecx
c0101e03:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c0101e08:	89 c8                	mov    %ecx,%eax
c0101e0a:	f7 e2                	mul    %edx
c0101e0c:	c1 ea 05             	shr    $0x5,%edx
c0101e0f:	89 d0                	mov    %edx,%eax
c0101e11:	c1 e0 02             	shl    $0x2,%eax
c0101e14:	01 d0                	add    %edx,%eax
c0101e16:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0101e1d:	01 d0                	add    %edx,%eax
c0101e1f:	c1 e0 02             	shl    $0x2,%eax
c0101e22:	29 c1                	sub    %eax,%ecx
c0101e24:	89 ca                	mov    %ecx,%edx
c0101e26:	85 d2                	test   %edx,%edx
c0101e28:	0f 85 aa 00 00 00    	jne    c0101ed8 <trap_dispatch+0x133>
            print_ticks();
c0101e2e:	e8 0c fb ff ff       	call   c010193f <print_ticks>
        }
        break;
c0101e33:	e9 a0 00 00 00       	jmp    c0101ed8 <trap_dispatch+0x133>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0101e38:	e8 a5 f8 ff ff       	call   c01016e2 <cons_getc>
c0101e3d:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101e40:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101e44:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101e48:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101e4c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101e50:	c7 04 24 49 66 10 c0 	movl   $0xc0106649,(%esp)
c0101e57:	e8 05 e5 ff ff       	call   c0100361 <cprintf>
        break;
c0101e5c:	eb 7b                	jmp    c0101ed9 <trap_dispatch+0x134>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0101e5e:	e8 7f f8 ff ff       	call   c01016e2 <cons_getc>
c0101e63:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0101e66:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101e6a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101e6e:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101e72:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101e76:	c7 04 24 5b 66 10 c0 	movl   $0xc010665b,(%esp)
c0101e7d:	e8 df e4 ff ff       	call   c0100361 <cprintf>
        break;
c0101e82:	eb 55                	jmp    c0101ed9 <trap_dispatch+0x134>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c0101e84:	c7 44 24 08 6a 66 10 	movl   $0xc010666a,0x8(%esp)
c0101e8b:	c0 
c0101e8c:	c7 44 24 04 ae 00 00 	movl   $0xae,0x4(%esp)
c0101e93:	00 
c0101e94:	c7 04 24 8e 64 10 c0 	movl   $0xc010648e,(%esp)
c0101e9b:	e8 62 ee ff ff       	call   c0100d02 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0101ea0:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ea3:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101ea7:	83 e0 03             	and    $0x3,%eax
c0101eaa:	85 c0                	test   %eax,%eax
c0101eac:	75 2b                	jne    c0101ed9 <trap_dispatch+0x134>
            print_trapframe(tf);
c0101eae:	8b 45 08             	mov    0x8(%ebp),%eax
c0101eb1:	89 04 24             	mov    %eax,(%esp)
c0101eb4:	e8 7f fc ff ff       	call   c0101b38 <print_trapframe>
            panic("unexpected trap in kernel.\n");
c0101eb9:	c7 44 24 08 7a 66 10 	movl   $0xc010667a,0x8(%esp)
c0101ec0:	c0 
c0101ec1:	c7 44 24 04 b8 00 00 	movl   $0xb8,0x4(%esp)
c0101ec8:	00 
c0101ec9:	c7 04 24 8e 64 10 c0 	movl   $0xc010648e,(%esp)
c0101ed0:	e8 2d ee ff ff       	call   c0100d02 <__panic>
        break;
c0101ed5:	90                   	nop
c0101ed6:	eb 01                	jmp    c0101ed9 <trap_dispatch+0x134>
        break;
c0101ed8:	90                   	nop
        }
    }
}
c0101ed9:	90                   	nop
c0101eda:	89 ec                	mov    %ebp,%esp
c0101edc:	5d                   	pop    %ebp
c0101edd:	c3                   	ret    

c0101ede <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0101ede:	55                   	push   %ebp
c0101edf:	89 e5                	mov    %esp,%ebp
c0101ee1:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0101ee4:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ee7:	89 04 24             	mov    %eax,(%esp)
c0101eea:	e8 b6 fe ff ff       	call   c0101da5 <trap_dispatch>
}
c0101eef:	90                   	nop
c0101ef0:	89 ec                	mov    %ebp,%esp
c0101ef2:	5d                   	pop    %ebp
c0101ef3:	c3                   	ret    

c0101ef4 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0101ef4:	1e                   	push   %ds
    pushl %es
c0101ef5:	06                   	push   %es
    pushl %fs
c0101ef6:	0f a0                	push   %fs
    pushl %gs
c0101ef8:	0f a8                	push   %gs
    pushal
c0101efa:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0101efb:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0101f00:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0101f02:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0101f04:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0101f05:	e8 d4 ff ff ff       	call   c0101ede <trap>

    # pop the pushed stack pointer
    popl %esp
c0101f0a:	5c                   	pop    %esp

c0101f0b <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0101f0b:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0101f0c:	0f a9                	pop    %gs
    popl %fs
c0101f0e:	0f a1                	pop    %fs
    popl %es
c0101f10:	07                   	pop    %es
    popl %ds
c0101f11:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0101f12:	83 c4 08             	add    $0x8,%esp
    iret
c0101f15:	cf                   	iret   

c0101f16 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0101f16:	6a 00                	push   $0x0
  pushl $0
c0101f18:	6a 00                	push   $0x0
  jmp __alltraps
c0101f1a:	e9 d5 ff ff ff       	jmp    c0101ef4 <__alltraps>

c0101f1f <vector1>:
.globl vector1
vector1:
  pushl $0
c0101f1f:	6a 00                	push   $0x0
  pushl $1
c0101f21:	6a 01                	push   $0x1
  jmp __alltraps
c0101f23:	e9 cc ff ff ff       	jmp    c0101ef4 <__alltraps>

c0101f28 <vector2>:
.globl vector2
vector2:
  pushl $0
c0101f28:	6a 00                	push   $0x0
  pushl $2
c0101f2a:	6a 02                	push   $0x2
  jmp __alltraps
c0101f2c:	e9 c3 ff ff ff       	jmp    c0101ef4 <__alltraps>

c0101f31 <vector3>:
.globl vector3
vector3:
  pushl $0
c0101f31:	6a 00                	push   $0x0
  pushl $3
c0101f33:	6a 03                	push   $0x3
  jmp __alltraps
c0101f35:	e9 ba ff ff ff       	jmp    c0101ef4 <__alltraps>

c0101f3a <vector4>:
.globl vector4
vector4:
  pushl $0
c0101f3a:	6a 00                	push   $0x0
  pushl $4
c0101f3c:	6a 04                	push   $0x4
  jmp __alltraps
c0101f3e:	e9 b1 ff ff ff       	jmp    c0101ef4 <__alltraps>

c0101f43 <vector5>:
.globl vector5
vector5:
  pushl $0
c0101f43:	6a 00                	push   $0x0
  pushl $5
c0101f45:	6a 05                	push   $0x5
  jmp __alltraps
c0101f47:	e9 a8 ff ff ff       	jmp    c0101ef4 <__alltraps>

c0101f4c <vector6>:
.globl vector6
vector6:
  pushl $0
c0101f4c:	6a 00                	push   $0x0
  pushl $6
c0101f4e:	6a 06                	push   $0x6
  jmp __alltraps
c0101f50:	e9 9f ff ff ff       	jmp    c0101ef4 <__alltraps>

c0101f55 <vector7>:
.globl vector7
vector7:
  pushl $0
c0101f55:	6a 00                	push   $0x0
  pushl $7
c0101f57:	6a 07                	push   $0x7
  jmp __alltraps
c0101f59:	e9 96 ff ff ff       	jmp    c0101ef4 <__alltraps>

c0101f5e <vector8>:
.globl vector8
vector8:
  pushl $8
c0101f5e:	6a 08                	push   $0x8
  jmp __alltraps
c0101f60:	e9 8f ff ff ff       	jmp    c0101ef4 <__alltraps>

c0101f65 <vector9>:
.globl vector9
vector9:
  pushl $0
c0101f65:	6a 00                	push   $0x0
  pushl $9
c0101f67:	6a 09                	push   $0x9
  jmp __alltraps
c0101f69:	e9 86 ff ff ff       	jmp    c0101ef4 <__alltraps>

c0101f6e <vector10>:
.globl vector10
vector10:
  pushl $10
c0101f6e:	6a 0a                	push   $0xa
  jmp __alltraps
c0101f70:	e9 7f ff ff ff       	jmp    c0101ef4 <__alltraps>

c0101f75 <vector11>:
.globl vector11
vector11:
  pushl $11
c0101f75:	6a 0b                	push   $0xb
  jmp __alltraps
c0101f77:	e9 78 ff ff ff       	jmp    c0101ef4 <__alltraps>

c0101f7c <vector12>:
.globl vector12
vector12:
  pushl $12
c0101f7c:	6a 0c                	push   $0xc
  jmp __alltraps
c0101f7e:	e9 71 ff ff ff       	jmp    c0101ef4 <__alltraps>

c0101f83 <vector13>:
.globl vector13
vector13:
  pushl $13
c0101f83:	6a 0d                	push   $0xd
  jmp __alltraps
c0101f85:	e9 6a ff ff ff       	jmp    c0101ef4 <__alltraps>

c0101f8a <vector14>:
.globl vector14
vector14:
  pushl $14
c0101f8a:	6a 0e                	push   $0xe
  jmp __alltraps
c0101f8c:	e9 63 ff ff ff       	jmp    c0101ef4 <__alltraps>

c0101f91 <vector15>:
.globl vector15
vector15:
  pushl $0
c0101f91:	6a 00                	push   $0x0
  pushl $15
c0101f93:	6a 0f                	push   $0xf
  jmp __alltraps
c0101f95:	e9 5a ff ff ff       	jmp    c0101ef4 <__alltraps>

c0101f9a <vector16>:
.globl vector16
vector16:
  pushl $0
c0101f9a:	6a 00                	push   $0x0
  pushl $16
c0101f9c:	6a 10                	push   $0x10
  jmp __alltraps
c0101f9e:	e9 51 ff ff ff       	jmp    c0101ef4 <__alltraps>

c0101fa3 <vector17>:
.globl vector17
vector17:
  pushl $17
c0101fa3:	6a 11                	push   $0x11
  jmp __alltraps
c0101fa5:	e9 4a ff ff ff       	jmp    c0101ef4 <__alltraps>

c0101faa <vector18>:
.globl vector18
vector18:
  pushl $0
c0101faa:	6a 00                	push   $0x0
  pushl $18
c0101fac:	6a 12                	push   $0x12
  jmp __alltraps
c0101fae:	e9 41 ff ff ff       	jmp    c0101ef4 <__alltraps>

c0101fb3 <vector19>:
.globl vector19
vector19:
  pushl $0
c0101fb3:	6a 00                	push   $0x0
  pushl $19
c0101fb5:	6a 13                	push   $0x13
  jmp __alltraps
c0101fb7:	e9 38 ff ff ff       	jmp    c0101ef4 <__alltraps>

c0101fbc <vector20>:
.globl vector20
vector20:
  pushl $0
c0101fbc:	6a 00                	push   $0x0
  pushl $20
c0101fbe:	6a 14                	push   $0x14
  jmp __alltraps
c0101fc0:	e9 2f ff ff ff       	jmp    c0101ef4 <__alltraps>

c0101fc5 <vector21>:
.globl vector21
vector21:
  pushl $0
c0101fc5:	6a 00                	push   $0x0
  pushl $21
c0101fc7:	6a 15                	push   $0x15
  jmp __alltraps
c0101fc9:	e9 26 ff ff ff       	jmp    c0101ef4 <__alltraps>

c0101fce <vector22>:
.globl vector22
vector22:
  pushl $0
c0101fce:	6a 00                	push   $0x0
  pushl $22
c0101fd0:	6a 16                	push   $0x16
  jmp __alltraps
c0101fd2:	e9 1d ff ff ff       	jmp    c0101ef4 <__alltraps>

c0101fd7 <vector23>:
.globl vector23
vector23:
  pushl $0
c0101fd7:	6a 00                	push   $0x0
  pushl $23
c0101fd9:	6a 17                	push   $0x17
  jmp __alltraps
c0101fdb:	e9 14 ff ff ff       	jmp    c0101ef4 <__alltraps>

c0101fe0 <vector24>:
.globl vector24
vector24:
  pushl $0
c0101fe0:	6a 00                	push   $0x0
  pushl $24
c0101fe2:	6a 18                	push   $0x18
  jmp __alltraps
c0101fe4:	e9 0b ff ff ff       	jmp    c0101ef4 <__alltraps>

c0101fe9 <vector25>:
.globl vector25
vector25:
  pushl $0
c0101fe9:	6a 00                	push   $0x0
  pushl $25
c0101feb:	6a 19                	push   $0x19
  jmp __alltraps
c0101fed:	e9 02 ff ff ff       	jmp    c0101ef4 <__alltraps>

c0101ff2 <vector26>:
.globl vector26
vector26:
  pushl $0
c0101ff2:	6a 00                	push   $0x0
  pushl $26
c0101ff4:	6a 1a                	push   $0x1a
  jmp __alltraps
c0101ff6:	e9 f9 fe ff ff       	jmp    c0101ef4 <__alltraps>

c0101ffb <vector27>:
.globl vector27
vector27:
  pushl $0
c0101ffb:	6a 00                	push   $0x0
  pushl $27
c0101ffd:	6a 1b                	push   $0x1b
  jmp __alltraps
c0101fff:	e9 f0 fe ff ff       	jmp    c0101ef4 <__alltraps>

c0102004 <vector28>:
.globl vector28
vector28:
  pushl $0
c0102004:	6a 00                	push   $0x0
  pushl $28
c0102006:	6a 1c                	push   $0x1c
  jmp __alltraps
c0102008:	e9 e7 fe ff ff       	jmp    c0101ef4 <__alltraps>

c010200d <vector29>:
.globl vector29
vector29:
  pushl $0
c010200d:	6a 00                	push   $0x0
  pushl $29
c010200f:	6a 1d                	push   $0x1d
  jmp __alltraps
c0102011:	e9 de fe ff ff       	jmp    c0101ef4 <__alltraps>

c0102016 <vector30>:
.globl vector30
vector30:
  pushl $0
c0102016:	6a 00                	push   $0x0
  pushl $30
c0102018:	6a 1e                	push   $0x1e
  jmp __alltraps
c010201a:	e9 d5 fe ff ff       	jmp    c0101ef4 <__alltraps>

c010201f <vector31>:
.globl vector31
vector31:
  pushl $0
c010201f:	6a 00                	push   $0x0
  pushl $31
c0102021:	6a 1f                	push   $0x1f
  jmp __alltraps
c0102023:	e9 cc fe ff ff       	jmp    c0101ef4 <__alltraps>

c0102028 <vector32>:
.globl vector32
vector32:
  pushl $0
c0102028:	6a 00                	push   $0x0
  pushl $32
c010202a:	6a 20                	push   $0x20
  jmp __alltraps
c010202c:	e9 c3 fe ff ff       	jmp    c0101ef4 <__alltraps>

c0102031 <vector33>:
.globl vector33
vector33:
  pushl $0
c0102031:	6a 00                	push   $0x0
  pushl $33
c0102033:	6a 21                	push   $0x21
  jmp __alltraps
c0102035:	e9 ba fe ff ff       	jmp    c0101ef4 <__alltraps>

c010203a <vector34>:
.globl vector34
vector34:
  pushl $0
c010203a:	6a 00                	push   $0x0
  pushl $34
c010203c:	6a 22                	push   $0x22
  jmp __alltraps
c010203e:	e9 b1 fe ff ff       	jmp    c0101ef4 <__alltraps>

c0102043 <vector35>:
.globl vector35
vector35:
  pushl $0
c0102043:	6a 00                	push   $0x0
  pushl $35
c0102045:	6a 23                	push   $0x23
  jmp __alltraps
c0102047:	e9 a8 fe ff ff       	jmp    c0101ef4 <__alltraps>

c010204c <vector36>:
.globl vector36
vector36:
  pushl $0
c010204c:	6a 00                	push   $0x0
  pushl $36
c010204e:	6a 24                	push   $0x24
  jmp __alltraps
c0102050:	e9 9f fe ff ff       	jmp    c0101ef4 <__alltraps>

c0102055 <vector37>:
.globl vector37
vector37:
  pushl $0
c0102055:	6a 00                	push   $0x0
  pushl $37
c0102057:	6a 25                	push   $0x25
  jmp __alltraps
c0102059:	e9 96 fe ff ff       	jmp    c0101ef4 <__alltraps>

c010205e <vector38>:
.globl vector38
vector38:
  pushl $0
c010205e:	6a 00                	push   $0x0
  pushl $38
c0102060:	6a 26                	push   $0x26
  jmp __alltraps
c0102062:	e9 8d fe ff ff       	jmp    c0101ef4 <__alltraps>

c0102067 <vector39>:
.globl vector39
vector39:
  pushl $0
c0102067:	6a 00                	push   $0x0
  pushl $39
c0102069:	6a 27                	push   $0x27
  jmp __alltraps
c010206b:	e9 84 fe ff ff       	jmp    c0101ef4 <__alltraps>

c0102070 <vector40>:
.globl vector40
vector40:
  pushl $0
c0102070:	6a 00                	push   $0x0
  pushl $40
c0102072:	6a 28                	push   $0x28
  jmp __alltraps
c0102074:	e9 7b fe ff ff       	jmp    c0101ef4 <__alltraps>

c0102079 <vector41>:
.globl vector41
vector41:
  pushl $0
c0102079:	6a 00                	push   $0x0
  pushl $41
c010207b:	6a 29                	push   $0x29
  jmp __alltraps
c010207d:	e9 72 fe ff ff       	jmp    c0101ef4 <__alltraps>

c0102082 <vector42>:
.globl vector42
vector42:
  pushl $0
c0102082:	6a 00                	push   $0x0
  pushl $42
c0102084:	6a 2a                	push   $0x2a
  jmp __alltraps
c0102086:	e9 69 fe ff ff       	jmp    c0101ef4 <__alltraps>

c010208b <vector43>:
.globl vector43
vector43:
  pushl $0
c010208b:	6a 00                	push   $0x0
  pushl $43
c010208d:	6a 2b                	push   $0x2b
  jmp __alltraps
c010208f:	e9 60 fe ff ff       	jmp    c0101ef4 <__alltraps>

c0102094 <vector44>:
.globl vector44
vector44:
  pushl $0
c0102094:	6a 00                	push   $0x0
  pushl $44
c0102096:	6a 2c                	push   $0x2c
  jmp __alltraps
c0102098:	e9 57 fe ff ff       	jmp    c0101ef4 <__alltraps>

c010209d <vector45>:
.globl vector45
vector45:
  pushl $0
c010209d:	6a 00                	push   $0x0
  pushl $45
c010209f:	6a 2d                	push   $0x2d
  jmp __alltraps
c01020a1:	e9 4e fe ff ff       	jmp    c0101ef4 <__alltraps>

c01020a6 <vector46>:
.globl vector46
vector46:
  pushl $0
c01020a6:	6a 00                	push   $0x0
  pushl $46
c01020a8:	6a 2e                	push   $0x2e
  jmp __alltraps
c01020aa:	e9 45 fe ff ff       	jmp    c0101ef4 <__alltraps>

c01020af <vector47>:
.globl vector47
vector47:
  pushl $0
c01020af:	6a 00                	push   $0x0
  pushl $47
c01020b1:	6a 2f                	push   $0x2f
  jmp __alltraps
c01020b3:	e9 3c fe ff ff       	jmp    c0101ef4 <__alltraps>

c01020b8 <vector48>:
.globl vector48
vector48:
  pushl $0
c01020b8:	6a 00                	push   $0x0
  pushl $48
c01020ba:	6a 30                	push   $0x30
  jmp __alltraps
c01020bc:	e9 33 fe ff ff       	jmp    c0101ef4 <__alltraps>

c01020c1 <vector49>:
.globl vector49
vector49:
  pushl $0
c01020c1:	6a 00                	push   $0x0
  pushl $49
c01020c3:	6a 31                	push   $0x31
  jmp __alltraps
c01020c5:	e9 2a fe ff ff       	jmp    c0101ef4 <__alltraps>

c01020ca <vector50>:
.globl vector50
vector50:
  pushl $0
c01020ca:	6a 00                	push   $0x0
  pushl $50
c01020cc:	6a 32                	push   $0x32
  jmp __alltraps
c01020ce:	e9 21 fe ff ff       	jmp    c0101ef4 <__alltraps>

c01020d3 <vector51>:
.globl vector51
vector51:
  pushl $0
c01020d3:	6a 00                	push   $0x0
  pushl $51
c01020d5:	6a 33                	push   $0x33
  jmp __alltraps
c01020d7:	e9 18 fe ff ff       	jmp    c0101ef4 <__alltraps>

c01020dc <vector52>:
.globl vector52
vector52:
  pushl $0
c01020dc:	6a 00                	push   $0x0
  pushl $52
c01020de:	6a 34                	push   $0x34
  jmp __alltraps
c01020e0:	e9 0f fe ff ff       	jmp    c0101ef4 <__alltraps>

c01020e5 <vector53>:
.globl vector53
vector53:
  pushl $0
c01020e5:	6a 00                	push   $0x0
  pushl $53
c01020e7:	6a 35                	push   $0x35
  jmp __alltraps
c01020e9:	e9 06 fe ff ff       	jmp    c0101ef4 <__alltraps>

c01020ee <vector54>:
.globl vector54
vector54:
  pushl $0
c01020ee:	6a 00                	push   $0x0
  pushl $54
c01020f0:	6a 36                	push   $0x36
  jmp __alltraps
c01020f2:	e9 fd fd ff ff       	jmp    c0101ef4 <__alltraps>

c01020f7 <vector55>:
.globl vector55
vector55:
  pushl $0
c01020f7:	6a 00                	push   $0x0
  pushl $55
c01020f9:	6a 37                	push   $0x37
  jmp __alltraps
c01020fb:	e9 f4 fd ff ff       	jmp    c0101ef4 <__alltraps>

c0102100 <vector56>:
.globl vector56
vector56:
  pushl $0
c0102100:	6a 00                	push   $0x0
  pushl $56
c0102102:	6a 38                	push   $0x38
  jmp __alltraps
c0102104:	e9 eb fd ff ff       	jmp    c0101ef4 <__alltraps>

c0102109 <vector57>:
.globl vector57
vector57:
  pushl $0
c0102109:	6a 00                	push   $0x0
  pushl $57
c010210b:	6a 39                	push   $0x39
  jmp __alltraps
c010210d:	e9 e2 fd ff ff       	jmp    c0101ef4 <__alltraps>

c0102112 <vector58>:
.globl vector58
vector58:
  pushl $0
c0102112:	6a 00                	push   $0x0
  pushl $58
c0102114:	6a 3a                	push   $0x3a
  jmp __alltraps
c0102116:	e9 d9 fd ff ff       	jmp    c0101ef4 <__alltraps>

c010211b <vector59>:
.globl vector59
vector59:
  pushl $0
c010211b:	6a 00                	push   $0x0
  pushl $59
c010211d:	6a 3b                	push   $0x3b
  jmp __alltraps
c010211f:	e9 d0 fd ff ff       	jmp    c0101ef4 <__alltraps>

c0102124 <vector60>:
.globl vector60
vector60:
  pushl $0
c0102124:	6a 00                	push   $0x0
  pushl $60
c0102126:	6a 3c                	push   $0x3c
  jmp __alltraps
c0102128:	e9 c7 fd ff ff       	jmp    c0101ef4 <__alltraps>

c010212d <vector61>:
.globl vector61
vector61:
  pushl $0
c010212d:	6a 00                	push   $0x0
  pushl $61
c010212f:	6a 3d                	push   $0x3d
  jmp __alltraps
c0102131:	e9 be fd ff ff       	jmp    c0101ef4 <__alltraps>

c0102136 <vector62>:
.globl vector62
vector62:
  pushl $0
c0102136:	6a 00                	push   $0x0
  pushl $62
c0102138:	6a 3e                	push   $0x3e
  jmp __alltraps
c010213a:	e9 b5 fd ff ff       	jmp    c0101ef4 <__alltraps>

c010213f <vector63>:
.globl vector63
vector63:
  pushl $0
c010213f:	6a 00                	push   $0x0
  pushl $63
c0102141:	6a 3f                	push   $0x3f
  jmp __alltraps
c0102143:	e9 ac fd ff ff       	jmp    c0101ef4 <__alltraps>

c0102148 <vector64>:
.globl vector64
vector64:
  pushl $0
c0102148:	6a 00                	push   $0x0
  pushl $64
c010214a:	6a 40                	push   $0x40
  jmp __alltraps
c010214c:	e9 a3 fd ff ff       	jmp    c0101ef4 <__alltraps>

c0102151 <vector65>:
.globl vector65
vector65:
  pushl $0
c0102151:	6a 00                	push   $0x0
  pushl $65
c0102153:	6a 41                	push   $0x41
  jmp __alltraps
c0102155:	e9 9a fd ff ff       	jmp    c0101ef4 <__alltraps>

c010215a <vector66>:
.globl vector66
vector66:
  pushl $0
c010215a:	6a 00                	push   $0x0
  pushl $66
c010215c:	6a 42                	push   $0x42
  jmp __alltraps
c010215e:	e9 91 fd ff ff       	jmp    c0101ef4 <__alltraps>

c0102163 <vector67>:
.globl vector67
vector67:
  pushl $0
c0102163:	6a 00                	push   $0x0
  pushl $67
c0102165:	6a 43                	push   $0x43
  jmp __alltraps
c0102167:	e9 88 fd ff ff       	jmp    c0101ef4 <__alltraps>

c010216c <vector68>:
.globl vector68
vector68:
  pushl $0
c010216c:	6a 00                	push   $0x0
  pushl $68
c010216e:	6a 44                	push   $0x44
  jmp __alltraps
c0102170:	e9 7f fd ff ff       	jmp    c0101ef4 <__alltraps>

c0102175 <vector69>:
.globl vector69
vector69:
  pushl $0
c0102175:	6a 00                	push   $0x0
  pushl $69
c0102177:	6a 45                	push   $0x45
  jmp __alltraps
c0102179:	e9 76 fd ff ff       	jmp    c0101ef4 <__alltraps>

c010217e <vector70>:
.globl vector70
vector70:
  pushl $0
c010217e:	6a 00                	push   $0x0
  pushl $70
c0102180:	6a 46                	push   $0x46
  jmp __alltraps
c0102182:	e9 6d fd ff ff       	jmp    c0101ef4 <__alltraps>

c0102187 <vector71>:
.globl vector71
vector71:
  pushl $0
c0102187:	6a 00                	push   $0x0
  pushl $71
c0102189:	6a 47                	push   $0x47
  jmp __alltraps
c010218b:	e9 64 fd ff ff       	jmp    c0101ef4 <__alltraps>

c0102190 <vector72>:
.globl vector72
vector72:
  pushl $0
c0102190:	6a 00                	push   $0x0
  pushl $72
c0102192:	6a 48                	push   $0x48
  jmp __alltraps
c0102194:	e9 5b fd ff ff       	jmp    c0101ef4 <__alltraps>

c0102199 <vector73>:
.globl vector73
vector73:
  pushl $0
c0102199:	6a 00                	push   $0x0
  pushl $73
c010219b:	6a 49                	push   $0x49
  jmp __alltraps
c010219d:	e9 52 fd ff ff       	jmp    c0101ef4 <__alltraps>

c01021a2 <vector74>:
.globl vector74
vector74:
  pushl $0
c01021a2:	6a 00                	push   $0x0
  pushl $74
c01021a4:	6a 4a                	push   $0x4a
  jmp __alltraps
c01021a6:	e9 49 fd ff ff       	jmp    c0101ef4 <__alltraps>

c01021ab <vector75>:
.globl vector75
vector75:
  pushl $0
c01021ab:	6a 00                	push   $0x0
  pushl $75
c01021ad:	6a 4b                	push   $0x4b
  jmp __alltraps
c01021af:	e9 40 fd ff ff       	jmp    c0101ef4 <__alltraps>

c01021b4 <vector76>:
.globl vector76
vector76:
  pushl $0
c01021b4:	6a 00                	push   $0x0
  pushl $76
c01021b6:	6a 4c                	push   $0x4c
  jmp __alltraps
c01021b8:	e9 37 fd ff ff       	jmp    c0101ef4 <__alltraps>

c01021bd <vector77>:
.globl vector77
vector77:
  pushl $0
c01021bd:	6a 00                	push   $0x0
  pushl $77
c01021bf:	6a 4d                	push   $0x4d
  jmp __alltraps
c01021c1:	e9 2e fd ff ff       	jmp    c0101ef4 <__alltraps>

c01021c6 <vector78>:
.globl vector78
vector78:
  pushl $0
c01021c6:	6a 00                	push   $0x0
  pushl $78
c01021c8:	6a 4e                	push   $0x4e
  jmp __alltraps
c01021ca:	e9 25 fd ff ff       	jmp    c0101ef4 <__alltraps>

c01021cf <vector79>:
.globl vector79
vector79:
  pushl $0
c01021cf:	6a 00                	push   $0x0
  pushl $79
c01021d1:	6a 4f                	push   $0x4f
  jmp __alltraps
c01021d3:	e9 1c fd ff ff       	jmp    c0101ef4 <__alltraps>

c01021d8 <vector80>:
.globl vector80
vector80:
  pushl $0
c01021d8:	6a 00                	push   $0x0
  pushl $80
c01021da:	6a 50                	push   $0x50
  jmp __alltraps
c01021dc:	e9 13 fd ff ff       	jmp    c0101ef4 <__alltraps>

c01021e1 <vector81>:
.globl vector81
vector81:
  pushl $0
c01021e1:	6a 00                	push   $0x0
  pushl $81
c01021e3:	6a 51                	push   $0x51
  jmp __alltraps
c01021e5:	e9 0a fd ff ff       	jmp    c0101ef4 <__alltraps>

c01021ea <vector82>:
.globl vector82
vector82:
  pushl $0
c01021ea:	6a 00                	push   $0x0
  pushl $82
c01021ec:	6a 52                	push   $0x52
  jmp __alltraps
c01021ee:	e9 01 fd ff ff       	jmp    c0101ef4 <__alltraps>

c01021f3 <vector83>:
.globl vector83
vector83:
  pushl $0
c01021f3:	6a 00                	push   $0x0
  pushl $83
c01021f5:	6a 53                	push   $0x53
  jmp __alltraps
c01021f7:	e9 f8 fc ff ff       	jmp    c0101ef4 <__alltraps>

c01021fc <vector84>:
.globl vector84
vector84:
  pushl $0
c01021fc:	6a 00                	push   $0x0
  pushl $84
c01021fe:	6a 54                	push   $0x54
  jmp __alltraps
c0102200:	e9 ef fc ff ff       	jmp    c0101ef4 <__alltraps>

c0102205 <vector85>:
.globl vector85
vector85:
  pushl $0
c0102205:	6a 00                	push   $0x0
  pushl $85
c0102207:	6a 55                	push   $0x55
  jmp __alltraps
c0102209:	e9 e6 fc ff ff       	jmp    c0101ef4 <__alltraps>

c010220e <vector86>:
.globl vector86
vector86:
  pushl $0
c010220e:	6a 00                	push   $0x0
  pushl $86
c0102210:	6a 56                	push   $0x56
  jmp __alltraps
c0102212:	e9 dd fc ff ff       	jmp    c0101ef4 <__alltraps>

c0102217 <vector87>:
.globl vector87
vector87:
  pushl $0
c0102217:	6a 00                	push   $0x0
  pushl $87
c0102219:	6a 57                	push   $0x57
  jmp __alltraps
c010221b:	e9 d4 fc ff ff       	jmp    c0101ef4 <__alltraps>

c0102220 <vector88>:
.globl vector88
vector88:
  pushl $0
c0102220:	6a 00                	push   $0x0
  pushl $88
c0102222:	6a 58                	push   $0x58
  jmp __alltraps
c0102224:	e9 cb fc ff ff       	jmp    c0101ef4 <__alltraps>

c0102229 <vector89>:
.globl vector89
vector89:
  pushl $0
c0102229:	6a 00                	push   $0x0
  pushl $89
c010222b:	6a 59                	push   $0x59
  jmp __alltraps
c010222d:	e9 c2 fc ff ff       	jmp    c0101ef4 <__alltraps>

c0102232 <vector90>:
.globl vector90
vector90:
  pushl $0
c0102232:	6a 00                	push   $0x0
  pushl $90
c0102234:	6a 5a                	push   $0x5a
  jmp __alltraps
c0102236:	e9 b9 fc ff ff       	jmp    c0101ef4 <__alltraps>

c010223b <vector91>:
.globl vector91
vector91:
  pushl $0
c010223b:	6a 00                	push   $0x0
  pushl $91
c010223d:	6a 5b                	push   $0x5b
  jmp __alltraps
c010223f:	e9 b0 fc ff ff       	jmp    c0101ef4 <__alltraps>

c0102244 <vector92>:
.globl vector92
vector92:
  pushl $0
c0102244:	6a 00                	push   $0x0
  pushl $92
c0102246:	6a 5c                	push   $0x5c
  jmp __alltraps
c0102248:	e9 a7 fc ff ff       	jmp    c0101ef4 <__alltraps>

c010224d <vector93>:
.globl vector93
vector93:
  pushl $0
c010224d:	6a 00                	push   $0x0
  pushl $93
c010224f:	6a 5d                	push   $0x5d
  jmp __alltraps
c0102251:	e9 9e fc ff ff       	jmp    c0101ef4 <__alltraps>

c0102256 <vector94>:
.globl vector94
vector94:
  pushl $0
c0102256:	6a 00                	push   $0x0
  pushl $94
c0102258:	6a 5e                	push   $0x5e
  jmp __alltraps
c010225a:	e9 95 fc ff ff       	jmp    c0101ef4 <__alltraps>

c010225f <vector95>:
.globl vector95
vector95:
  pushl $0
c010225f:	6a 00                	push   $0x0
  pushl $95
c0102261:	6a 5f                	push   $0x5f
  jmp __alltraps
c0102263:	e9 8c fc ff ff       	jmp    c0101ef4 <__alltraps>

c0102268 <vector96>:
.globl vector96
vector96:
  pushl $0
c0102268:	6a 00                	push   $0x0
  pushl $96
c010226a:	6a 60                	push   $0x60
  jmp __alltraps
c010226c:	e9 83 fc ff ff       	jmp    c0101ef4 <__alltraps>

c0102271 <vector97>:
.globl vector97
vector97:
  pushl $0
c0102271:	6a 00                	push   $0x0
  pushl $97
c0102273:	6a 61                	push   $0x61
  jmp __alltraps
c0102275:	e9 7a fc ff ff       	jmp    c0101ef4 <__alltraps>

c010227a <vector98>:
.globl vector98
vector98:
  pushl $0
c010227a:	6a 00                	push   $0x0
  pushl $98
c010227c:	6a 62                	push   $0x62
  jmp __alltraps
c010227e:	e9 71 fc ff ff       	jmp    c0101ef4 <__alltraps>

c0102283 <vector99>:
.globl vector99
vector99:
  pushl $0
c0102283:	6a 00                	push   $0x0
  pushl $99
c0102285:	6a 63                	push   $0x63
  jmp __alltraps
c0102287:	e9 68 fc ff ff       	jmp    c0101ef4 <__alltraps>

c010228c <vector100>:
.globl vector100
vector100:
  pushl $0
c010228c:	6a 00                	push   $0x0
  pushl $100
c010228e:	6a 64                	push   $0x64
  jmp __alltraps
c0102290:	e9 5f fc ff ff       	jmp    c0101ef4 <__alltraps>

c0102295 <vector101>:
.globl vector101
vector101:
  pushl $0
c0102295:	6a 00                	push   $0x0
  pushl $101
c0102297:	6a 65                	push   $0x65
  jmp __alltraps
c0102299:	e9 56 fc ff ff       	jmp    c0101ef4 <__alltraps>

c010229e <vector102>:
.globl vector102
vector102:
  pushl $0
c010229e:	6a 00                	push   $0x0
  pushl $102
c01022a0:	6a 66                	push   $0x66
  jmp __alltraps
c01022a2:	e9 4d fc ff ff       	jmp    c0101ef4 <__alltraps>

c01022a7 <vector103>:
.globl vector103
vector103:
  pushl $0
c01022a7:	6a 00                	push   $0x0
  pushl $103
c01022a9:	6a 67                	push   $0x67
  jmp __alltraps
c01022ab:	e9 44 fc ff ff       	jmp    c0101ef4 <__alltraps>

c01022b0 <vector104>:
.globl vector104
vector104:
  pushl $0
c01022b0:	6a 00                	push   $0x0
  pushl $104
c01022b2:	6a 68                	push   $0x68
  jmp __alltraps
c01022b4:	e9 3b fc ff ff       	jmp    c0101ef4 <__alltraps>

c01022b9 <vector105>:
.globl vector105
vector105:
  pushl $0
c01022b9:	6a 00                	push   $0x0
  pushl $105
c01022bb:	6a 69                	push   $0x69
  jmp __alltraps
c01022bd:	e9 32 fc ff ff       	jmp    c0101ef4 <__alltraps>

c01022c2 <vector106>:
.globl vector106
vector106:
  pushl $0
c01022c2:	6a 00                	push   $0x0
  pushl $106
c01022c4:	6a 6a                	push   $0x6a
  jmp __alltraps
c01022c6:	e9 29 fc ff ff       	jmp    c0101ef4 <__alltraps>

c01022cb <vector107>:
.globl vector107
vector107:
  pushl $0
c01022cb:	6a 00                	push   $0x0
  pushl $107
c01022cd:	6a 6b                	push   $0x6b
  jmp __alltraps
c01022cf:	e9 20 fc ff ff       	jmp    c0101ef4 <__alltraps>

c01022d4 <vector108>:
.globl vector108
vector108:
  pushl $0
c01022d4:	6a 00                	push   $0x0
  pushl $108
c01022d6:	6a 6c                	push   $0x6c
  jmp __alltraps
c01022d8:	e9 17 fc ff ff       	jmp    c0101ef4 <__alltraps>

c01022dd <vector109>:
.globl vector109
vector109:
  pushl $0
c01022dd:	6a 00                	push   $0x0
  pushl $109
c01022df:	6a 6d                	push   $0x6d
  jmp __alltraps
c01022e1:	e9 0e fc ff ff       	jmp    c0101ef4 <__alltraps>

c01022e6 <vector110>:
.globl vector110
vector110:
  pushl $0
c01022e6:	6a 00                	push   $0x0
  pushl $110
c01022e8:	6a 6e                	push   $0x6e
  jmp __alltraps
c01022ea:	e9 05 fc ff ff       	jmp    c0101ef4 <__alltraps>

c01022ef <vector111>:
.globl vector111
vector111:
  pushl $0
c01022ef:	6a 00                	push   $0x0
  pushl $111
c01022f1:	6a 6f                	push   $0x6f
  jmp __alltraps
c01022f3:	e9 fc fb ff ff       	jmp    c0101ef4 <__alltraps>

c01022f8 <vector112>:
.globl vector112
vector112:
  pushl $0
c01022f8:	6a 00                	push   $0x0
  pushl $112
c01022fa:	6a 70                	push   $0x70
  jmp __alltraps
c01022fc:	e9 f3 fb ff ff       	jmp    c0101ef4 <__alltraps>

c0102301 <vector113>:
.globl vector113
vector113:
  pushl $0
c0102301:	6a 00                	push   $0x0
  pushl $113
c0102303:	6a 71                	push   $0x71
  jmp __alltraps
c0102305:	e9 ea fb ff ff       	jmp    c0101ef4 <__alltraps>

c010230a <vector114>:
.globl vector114
vector114:
  pushl $0
c010230a:	6a 00                	push   $0x0
  pushl $114
c010230c:	6a 72                	push   $0x72
  jmp __alltraps
c010230e:	e9 e1 fb ff ff       	jmp    c0101ef4 <__alltraps>

c0102313 <vector115>:
.globl vector115
vector115:
  pushl $0
c0102313:	6a 00                	push   $0x0
  pushl $115
c0102315:	6a 73                	push   $0x73
  jmp __alltraps
c0102317:	e9 d8 fb ff ff       	jmp    c0101ef4 <__alltraps>

c010231c <vector116>:
.globl vector116
vector116:
  pushl $0
c010231c:	6a 00                	push   $0x0
  pushl $116
c010231e:	6a 74                	push   $0x74
  jmp __alltraps
c0102320:	e9 cf fb ff ff       	jmp    c0101ef4 <__alltraps>

c0102325 <vector117>:
.globl vector117
vector117:
  pushl $0
c0102325:	6a 00                	push   $0x0
  pushl $117
c0102327:	6a 75                	push   $0x75
  jmp __alltraps
c0102329:	e9 c6 fb ff ff       	jmp    c0101ef4 <__alltraps>

c010232e <vector118>:
.globl vector118
vector118:
  pushl $0
c010232e:	6a 00                	push   $0x0
  pushl $118
c0102330:	6a 76                	push   $0x76
  jmp __alltraps
c0102332:	e9 bd fb ff ff       	jmp    c0101ef4 <__alltraps>

c0102337 <vector119>:
.globl vector119
vector119:
  pushl $0
c0102337:	6a 00                	push   $0x0
  pushl $119
c0102339:	6a 77                	push   $0x77
  jmp __alltraps
c010233b:	e9 b4 fb ff ff       	jmp    c0101ef4 <__alltraps>

c0102340 <vector120>:
.globl vector120
vector120:
  pushl $0
c0102340:	6a 00                	push   $0x0
  pushl $120
c0102342:	6a 78                	push   $0x78
  jmp __alltraps
c0102344:	e9 ab fb ff ff       	jmp    c0101ef4 <__alltraps>

c0102349 <vector121>:
.globl vector121
vector121:
  pushl $0
c0102349:	6a 00                	push   $0x0
  pushl $121
c010234b:	6a 79                	push   $0x79
  jmp __alltraps
c010234d:	e9 a2 fb ff ff       	jmp    c0101ef4 <__alltraps>

c0102352 <vector122>:
.globl vector122
vector122:
  pushl $0
c0102352:	6a 00                	push   $0x0
  pushl $122
c0102354:	6a 7a                	push   $0x7a
  jmp __alltraps
c0102356:	e9 99 fb ff ff       	jmp    c0101ef4 <__alltraps>

c010235b <vector123>:
.globl vector123
vector123:
  pushl $0
c010235b:	6a 00                	push   $0x0
  pushl $123
c010235d:	6a 7b                	push   $0x7b
  jmp __alltraps
c010235f:	e9 90 fb ff ff       	jmp    c0101ef4 <__alltraps>

c0102364 <vector124>:
.globl vector124
vector124:
  pushl $0
c0102364:	6a 00                	push   $0x0
  pushl $124
c0102366:	6a 7c                	push   $0x7c
  jmp __alltraps
c0102368:	e9 87 fb ff ff       	jmp    c0101ef4 <__alltraps>

c010236d <vector125>:
.globl vector125
vector125:
  pushl $0
c010236d:	6a 00                	push   $0x0
  pushl $125
c010236f:	6a 7d                	push   $0x7d
  jmp __alltraps
c0102371:	e9 7e fb ff ff       	jmp    c0101ef4 <__alltraps>

c0102376 <vector126>:
.globl vector126
vector126:
  pushl $0
c0102376:	6a 00                	push   $0x0
  pushl $126
c0102378:	6a 7e                	push   $0x7e
  jmp __alltraps
c010237a:	e9 75 fb ff ff       	jmp    c0101ef4 <__alltraps>

c010237f <vector127>:
.globl vector127
vector127:
  pushl $0
c010237f:	6a 00                	push   $0x0
  pushl $127
c0102381:	6a 7f                	push   $0x7f
  jmp __alltraps
c0102383:	e9 6c fb ff ff       	jmp    c0101ef4 <__alltraps>

c0102388 <vector128>:
.globl vector128
vector128:
  pushl $0
c0102388:	6a 00                	push   $0x0
  pushl $128
c010238a:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c010238f:	e9 60 fb ff ff       	jmp    c0101ef4 <__alltraps>

c0102394 <vector129>:
.globl vector129
vector129:
  pushl $0
c0102394:	6a 00                	push   $0x0
  pushl $129
c0102396:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c010239b:	e9 54 fb ff ff       	jmp    c0101ef4 <__alltraps>

c01023a0 <vector130>:
.globl vector130
vector130:
  pushl $0
c01023a0:	6a 00                	push   $0x0
  pushl $130
c01023a2:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c01023a7:	e9 48 fb ff ff       	jmp    c0101ef4 <__alltraps>

c01023ac <vector131>:
.globl vector131
vector131:
  pushl $0
c01023ac:	6a 00                	push   $0x0
  pushl $131
c01023ae:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c01023b3:	e9 3c fb ff ff       	jmp    c0101ef4 <__alltraps>

c01023b8 <vector132>:
.globl vector132
vector132:
  pushl $0
c01023b8:	6a 00                	push   $0x0
  pushl $132
c01023ba:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c01023bf:	e9 30 fb ff ff       	jmp    c0101ef4 <__alltraps>

c01023c4 <vector133>:
.globl vector133
vector133:
  pushl $0
c01023c4:	6a 00                	push   $0x0
  pushl $133
c01023c6:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c01023cb:	e9 24 fb ff ff       	jmp    c0101ef4 <__alltraps>

c01023d0 <vector134>:
.globl vector134
vector134:
  pushl $0
c01023d0:	6a 00                	push   $0x0
  pushl $134
c01023d2:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c01023d7:	e9 18 fb ff ff       	jmp    c0101ef4 <__alltraps>

c01023dc <vector135>:
.globl vector135
vector135:
  pushl $0
c01023dc:	6a 00                	push   $0x0
  pushl $135
c01023de:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c01023e3:	e9 0c fb ff ff       	jmp    c0101ef4 <__alltraps>

c01023e8 <vector136>:
.globl vector136
vector136:
  pushl $0
c01023e8:	6a 00                	push   $0x0
  pushl $136
c01023ea:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c01023ef:	e9 00 fb ff ff       	jmp    c0101ef4 <__alltraps>

c01023f4 <vector137>:
.globl vector137
vector137:
  pushl $0
c01023f4:	6a 00                	push   $0x0
  pushl $137
c01023f6:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c01023fb:	e9 f4 fa ff ff       	jmp    c0101ef4 <__alltraps>

c0102400 <vector138>:
.globl vector138
vector138:
  pushl $0
c0102400:	6a 00                	push   $0x0
  pushl $138
c0102402:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c0102407:	e9 e8 fa ff ff       	jmp    c0101ef4 <__alltraps>

c010240c <vector139>:
.globl vector139
vector139:
  pushl $0
c010240c:	6a 00                	push   $0x0
  pushl $139
c010240e:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c0102413:	e9 dc fa ff ff       	jmp    c0101ef4 <__alltraps>

c0102418 <vector140>:
.globl vector140
vector140:
  pushl $0
c0102418:	6a 00                	push   $0x0
  pushl $140
c010241a:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c010241f:	e9 d0 fa ff ff       	jmp    c0101ef4 <__alltraps>

c0102424 <vector141>:
.globl vector141
vector141:
  pushl $0
c0102424:	6a 00                	push   $0x0
  pushl $141
c0102426:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c010242b:	e9 c4 fa ff ff       	jmp    c0101ef4 <__alltraps>

c0102430 <vector142>:
.globl vector142
vector142:
  pushl $0
c0102430:	6a 00                	push   $0x0
  pushl $142
c0102432:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c0102437:	e9 b8 fa ff ff       	jmp    c0101ef4 <__alltraps>

c010243c <vector143>:
.globl vector143
vector143:
  pushl $0
c010243c:	6a 00                	push   $0x0
  pushl $143
c010243e:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c0102443:	e9 ac fa ff ff       	jmp    c0101ef4 <__alltraps>

c0102448 <vector144>:
.globl vector144
vector144:
  pushl $0
c0102448:	6a 00                	push   $0x0
  pushl $144
c010244a:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c010244f:	e9 a0 fa ff ff       	jmp    c0101ef4 <__alltraps>

c0102454 <vector145>:
.globl vector145
vector145:
  pushl $0
c0102454:	6a 00                	push   $0x0
  pushl $145
c0102456:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c010245b:	e9 94 fa ff ff       	jmp    c0101ef4 <__alltraps>

c0102460 <vector146>:
.globl vector146
vector146:
  pushl $0
c0102460:	6a 00                	push   $0x0
  pushl $146
c0102462:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c0102467:	e9 88 fa ff ff       	jmp    c0101ef4 <__alltraps>

c010246c <vector147>:
.globl vector147
vector147:
  pushl $0
c010246c:	6a 00                	push   $0x0
  pushl $147
c010246e:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c0102473:	e9 7c fa ff ff       	jmp    c0101ef4 <__alltraps>

c0102478 <vector148>:
.globl vector148
vector148:
  pushl $0
c0102478:	6a 00                	push   $0x0
  pushl $148
c010247a:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c010247f:	e9 70 fa ff ff       	jmp    c0101ef4 <__alltraps>

c0102484 <vector149>:
.globl vector149
vector149:
  pushl $0
c0102484:	6a 00                	push   $0x0
  pushl $149
c0102486:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c010248b:	e9 64 fa ff ff       	jmp    c0101ef4 <__alltraps>

c0102490 <vector150>:
.globl vector150
vector150:
  pushl $0
c0102490:	6a 00                	push   $0x0
  pushl $150
c0102492:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c0102497:	e9 58 fa ff ff       	jmp    c0101ef4 <__alltraps>

c010249c <vector151>:
.globl vector151
vector151:
  pushl $0
c010249c:	6a 00                	push   $0x0
  pushl $151
c010249e:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c01024a3:	e9 4c fa ff ff       	jmp    c0101ef4 <__alltraps>

c01024a8 <vector152>:
.globl vector152
vector152:
  pushl $0
c01024a8:	6a 00                	push   $0x0
  pushl $152
c01024aa:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c01024af:	e9 40 fa ff ff       	jmp    c0101ef4 <__alltraps>

c01024b4 <vector153>:
.globl vector153
vector153:
  pushl $0
c01024b4:	6a 00                	push   $0x0
  pushl $153
c01024b6:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c01024bb:	e9 34 fa ff ff       	jmp    c0101ef4 <__alltraps>

c01024c0 <vector154>:
.globl vector154
vector154:
  pushl $0
c01024c0:	6a 00                	push   $0x0
  pushl $154
c01024c2:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c01024c7:	e9 28 fa ff ff       	jmp    c0101ef4 <__alltraps>

c01024cc <vector155>:
.globl vector155
vector155:
  pushl $0
c01024cc:	6a 00                	push   $0x0
  pushl $155
c01024ce:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c01024d3:	e9 1c fa ff ff       	jmp    c0101ef4 <__alltraps>

c01024d8 <vector156>:
.globl vector156
vector156:
  pushl $0
c01024d8:	6a 00                	push   $0x0
  pushl $156
c01024da:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c01024df:	e9 10 fa ff ff       	jmp    c0101ef4 <__alltraps>

c01024e4 <vector157>:
.globl vector157
vector157:
  pushl $0
c01024e4:	6a 00                	push   $0x0
  pushl $157
c01024e6:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c01024eb:	e9 04 fa ff ff       	jmp    c0101ef4 <__alltraps>

c01024f0 <vector158>:
.globl vector158
vector158:
  pushl $0
c01024f0:	6a 00                	push   $0x0
  pushl $158
c01024f2:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c01024f7:	e9 f8 f9 ff ff       	jmp    c0101ef4 <__alltraps>

c01024fc <vector159>:
.globl vector159
vector159:
  pushl $0
c01024fc:	6a 00                	push   $0x0
  pushl $159
c01024fe:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c0102503:	e9 ec f9 ff ff       	jmp    c0101ef4 <__alltraps>

c0102508 <vector160>:
.globl vector160
vector160:
  pushl $0
c0102508:	6a 00                	push   $0x0
  pushl $160
c010250a:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c010250f:	e9 e0 f9 ff ff       	jmp    c0101ef4 <__alltraps>

c0102514 <vector161>:
.globl vector161
vector161:
  pushl $0
c0102514:	6a 00                	push   $0x0
  pushl $161
c0102516:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c010251b:	e9 d4 f9 ff ff       	jmp    c0101ef4 <__alltraps>

c0102520 <vector162>:
.globl vector162
vector162:
  pushl $0
c0102520:	6a 00                	push   $0x0
  pushl $162
c0102522:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c0102527:	e9 c8 f9 ff ff       	jmp    c0101ef4 <__alltraps>

c010252c <vector163>:
.globl vector163
vector163:
  pushl $0
c010252c:	6a 00                	push   $0x0
  pushl $163
c010252e:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c0102533:	e9 bc f9 ff ff       	jmp    c0101ef4 <__alltraps>

c0102538 <vector164>:
.globl vector164
vector164:
  pushl $0
c0102538:	6a 00                	push   $0x0
  pushl $164
c010253a:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c010253f:	e9 b0 f9 ff ff       	jmp    c0101ef4 <__alltraps>

c0102544 <vector165>:
.globl vector165
vector165:
  pushl $0
c0102544:	6a 00                	push   $0x0
  pushl $165
c0102546:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c010254b:	e9 a4 f9 ff ff       	jmp    c0101ef4 <__alltraps>

c0102550 <vector166>:
.globl vector166
vector166:
  pushl $0
c0102550:	6a 00                	push   $0x0
  pushl $166
c0102552:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c0102557:	e9 98 f9 ff ff       	jmp    c0101ef4 <__alltraps>

c010255c <vector167>:
.globl vector167
vector167:
  pushl $0
c010255c:	6a 00                	push   $0x0
  pushl $167
c010255e:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c0102563:	e9 8c f9 ff ff       	jmp    c0101ef4 <__alltraps>

c0102568 <vector168>:
.globl vector168
vector168:
  pushl $0
c0102568:	6a 00                	push   $0x0
  pushl $168
c010256a:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c010256f:	e9 80 f9 ff ff       	jmp    c0101ef4 <__alltraps>

c0102574 <vector169>:
.globl vector169
vector169:
  pushl $0
c0102574:	6a 00                	push   $0x0
  pushl $169
c0102576:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c010257b:	e9 74 f9 ff ff       	jmp    c0101ef4 <__alltraps>

c0102580 <vector170>:
.globl vector170
vector170:
  pushl $0
c0102580:	6a 00                	push   $0x0
  pushl $170
c0102582:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c0102587:	e9 68 f9 ff ff       	jmp    c0101ef4 <__alltraps>

c010258c <vector171>:
.globl vector171
vector171:
  pushl $0
c010258c:	6a 00                	push   $0x0
  pushl $171
c010258e:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c0102593:	e9 5c f9 ff ff       	jmp    c0101ef4 <__alltraps>

c0102598 <vector172>:
.globl vector172
vector172:
  pushl $0
c0102598:	6a 00                	push   $0x0
  pushl $172
c010259a:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c010259f:	e9 50 f9 ff ff       	jmp    c0101ef4 <__alltraps>

c01025a4 <vector173>:
.globl vector173
vector173:
  pushl $0
c01025a4:	6a 00                	push   $0x0
  pushl $173
c01025a6:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c01025ab:	e9 44 f9 ff ff       	jmp    c0101ef4 <__alltraps>

c01025b0 <vector174>:
.globl vector174
vector174:
  pushl $0
c01025b0:	6a 00                	push   $0x0
  pushl $174
c01025b2:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c01025b7:	e9 38 f9 ff ff       	jmp    c0101ef4 <__alltraps>

c01025bc <vector175>:
.globl vector175
vector175:
  pushl $0
c01025bc:	6a 00                	push   $0x0
  pushl $175
c01025be:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c01025c3:	e9 2c f9 ff ff       	jmp    c0101ef4 <__alltraps>

c01025c8 <vector176>:
.globl vector176
vector176:
  pushl $0
c01025c8:	6a 00                	push   $0x0
  pushl $176
c01025ca:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c01025cf:	e9 20 f9 ff ff       	jmp    c0101ef4 <__alltraps>

c01025d4 <vector177>:
.globl vector177
vector177:
  pushl $0
c01025d4:	6a 00                	push   $0x0
  pushl $177
c01025d6:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c01025db:	e9 14 f9 ff ff       	jmp    c0101ef4 <__alltraps>

c01025e0 <vector178>:
.globl vector178
vector178:
  pushl $0
c01025e0:	6a 00                	push   $0x0
  pushl $178
c01025e2:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c01025e7:	e9 08 f9 ff ff       	jmp    c0101ef4 <__alltraps>

c01025ec <vector179>:
.globl vector179
vector179:
  pushl $0
c01025ec:	6a 00                	push   $0x0
  pushl $179
c01025ee:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c01025f3:	e9 fc f8 ff ff       	jmp    c0101ef4 <__alltraps>

c01025f8 <vector180>:
.globl vector180
vector180:
  pushl $0
c01025f8:	6a 00                	push   $0x0
  pushl $180
c01025fa:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c01025ff:	e9 f0 f8 ff ff       	jmp    c0101ef4 <__alltraps>

c0102604 <vector181>:
.globl vector181
vector181:
  pushl $0
c0102604:	6a 00                	push   $0x0
  pushl $181
c0102606:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c010260b:	e9 e4 f8 ff ff       	jmp    c0101ef4 <__alltraps>

c0102610 <vector182>:
.globl vector182
vector182:
  pushl $0
c0102610:	6a 00                	push   $0x0
  pushl $182
c0102612:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c0102617:	e9 d8 f8 ff ff       	jmp    c0101ef4 <__alltraps>

c010261c <vector183>:
.globl vector183
vector183:
  pushl $0
c010261c:	6a 00                	push   $0x0
  pushl $183
c010261e:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c0102623:	e9 cc f8 ff ff       	jmp    c0101ef4 <__alltraps>

c0102628 <vector184>:
.globl vector184
vector184:
  pushl $0
c0102628:	6a 00                	push   $0x0
  pushl $184
c010262a:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c010262f:	e9 c0 f8 ff ff       	jmp    c0101ef4 <__alltraps>

c0102634 <vector185>:
.globl vector185
vector185:
  pushl $0
c0102634:	6a 00                	push   $0x0
  pushl $185
c0102636:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c010263b:	e9 b4 f8 ff ff       	jmp    c0101ef4 <__alltraps>

c0102640 <vector186>:
.globl vector186
vector186:
  pushl $0
c0102640:	6a 00                	push   $0x0
  pushl $186
c0102642:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c0102647:	e9 a8 f8 ff ff       	jmp    c0101ef4 <__alltraps>

c010264c <vector187>:
.globl vector187
vector187:
  pushl $0
c010264c:	6a 00                	push   $0x0
  pushl $187
c010264e:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c0102653:	e9 9c f8 ff ff       	jmp    c0101ef4 <__alltraps>

c0102658 <vector188>:
.globl vector188
vector188:
  pushl $0
c0102658:	6a 00                	push   $0x0
  pushl $188
c010265a:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c010265f:	e9 90 f8 ff ff       	jmp    c0101ef4 <__alltraps>

c0102664 <vector189>:
.globl vector189
vector189:
  pushl $0
c0102664:	6a 00                	push   $0x0
  pushl $189
c0102666:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c010266b:	e9 84 f8 ff ff       	jmp    c0101ef4 <__alltraps>

c0102670 <vector190>:
.globl vector190
vector190:
  pushl $0
c0102670:	6a 00                	push   $0x0
  pushl $190
c0102672:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c0102677:	e9 78 f8 ff ff       	jmp    c0101ef4 <__alltraps>

c010267c <vector191>:
.globl vector191
vector191:
  pushl $0
c010267c:	6a 00                	push   $0x0
  pushl $191
c010267e:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c0102683:	e9 6c f8 ff ff       	jmp    c0101ef4 <__alltraps>

c0102688 <vector192>:
.globl vector192
vector192:
  pushl $0
c0102688:	6a 00                	push   $0x0
  pushl $192
c010268a:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c010268f:	e9 60 f8 ff ff       	jmp    c0101ef4 <__alltraps>

c0102694 <vector193>:
.globl vector193
vector193:
  pushl $0
c0102694:	6a 00                	push   $0x0
  pushl $193
c0102696:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c010269b:	e9 54 f8 ff ff       	jmp    c0101ef4 <__alltraps>

c01026a0 <vector194>:
.globl vector194
vector194:
  pushl $0
c01026a0:	6a 00                	push   $0x0
  pushl $194
c01026a2:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c01026a7:	e9 48 f8 ff ff       	jmp    c0101ef4 <__alltraps>

c01026ac <vector195>:
.globl vector195
vector195:
  pushl $0
c01026ac:	6a 00                	push   $0x0
  pushl $195
c01026ae:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c01026b3:	e9 3c f8 ff ff       	jmp    c0101ef4 <__alltraps>

c01026b8 <vector196>:
.globl vector196
vector196:
  pushl $0
c01026b8:	6a 00                	push   $0x0
  pushl $196
c01026ba:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c01026bf:	e9 30 f8 ff ff       	jmp    c0101ef4 <__alltraps>

c01026c4 <vector197>:
.globl vector197
vector197:
  pushl $0
c01026c4:	6a 00                	push   $0x0
  pushl $197
c01026c6:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c01026cb:	e9 24 f8 ff ff       	jmp    c0101ef4 <__alltraps>

c01026d0 <vector198>:
.globl vector198
vector198:
  pushl $0
c01026d0:	6a 00                	push   $0x0
  pushl $198
c01026d2:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c01026d7:	e9 18 f8 ff ff       	jmp    c0101ef4 <__alltraps>

c01026dc <vector199>:
.globl vector199
vector199:
  pushl $0
c01026dc:	6a 00                	push   $0x0
  pushl $199
c01026de:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c01026e3:	e9 0c f8 ff ff       	jmp    c0101ef4 <__alltraps>

c01026e8 <vector200>:
.globl vector200
vector200:
  pushl $0
c01026e8:	6a 00                	push   $0x0
  pushl $200
c01026ea:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c01026ef:	e9 00 f8 ff ff       	jmp    c0101ef4 <__alltraps>

c01026f4 <vector201>:
.globl vector201
vector201:
  pushl $0
c01026f4:	6a 00                	push   $0x0
  pushl $201
c01026f6:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c01026fb:	e9 f4 f7 ff ff       	jmp    c0101ef4 <__alltraps>

c0102700 <vector202>:
.globl vector202
vector202:
  pushl $0
c0102700:	6a 00                	push   $0x0
  pushl $202
c0102702:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c0102707:	e9 e8 f7 ff ff       	jmp    c0101ef4 <__alltraps>

c010270c <vector203>:
.globl vector203
vector203:
  pushl $0
c010270c:	6a 00                	push   $0x0
  pushl $203
c010270e:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c0102713:	e9 dc f7 ff ff       	jmp    c0101ef4 <__alltraps>

c0102718 <vector204>:
.globl vector204
vector204:
  pushl $0
c0102718:	6a 00                	push   $0x0
  pushl $204
c010271a:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c010271f:	e9 d0 f7 ff ff       	jmp    c0101ef4 <__alltraps>

c0102724 <vector205>:
.globl vector205
vector205:
  pushl $0
c0102724:	6a 00                	push   $0x0
  pushl $205
c0102726:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c010272b:	e9 c4 f7 ff ff       	jmp    c0101ef4 <__alltraps>

c0102730 <vector206>:
.globl vector206
vector206:
  pushl $0
c0102730:	6a 00                	push   $0x0
  pushl $206
c0102732:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c0102737:	e9 b8 f7 ff ff       	jmp    c0101ef4 <__alltraps>

c010273c <vector207>:
.globl vector207
vector207:
  pushl $0
c010273c:	6a 00                	push   $0x0
  pushl $207
c010273e:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c0102743:	e9 ac f7 ff ff       	jmp    c0101ef4 <__alltraps>

c0102748 <vector208>:
.globl vector208
vector208:
  pushl $0
c0102748:	6a 00                	push   $0x0
  pushl $208
c010274a:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c010274f:	e9 a0 f7 ff ff       	jmp    c0101ef4 <__alltraps>

c0102754 <vector209>:
.globl vector209
vector209:
  pushl $0
c0102754:	6a 00                	push   $0x0
  pushl $209
c0102756:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c010275b:	e9 94 f7 ff ff       	jmp    c0101ef4 <__alltraps>

c0102760 <vector210>:
.globl vector210
vector210:
  pushl $0
c0102760:	6a 00                	push   $0x0
  pushl $210
c0102762:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c0102767:	e9 88 f7 ff ff       	jmp    c0101ef4 <__alltraps>

c010276c <vector211>:
.globl vector211
vector211:
  pushl $0
c010276c:	6a 00                	push   $0x0
  pushl $211
c010276e:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c0102773:	e9 7c f7 ff ff       	jmp    c0101ef4 <__alltraps>

c0102778 <vector212>:
.globl vector212
vector212:
  pushl $0
c0102778:	6a 00                	push   $0x0
  pushl $212
c010277a:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c010277f:	e9 70 f7 ff ff       	jmp    c0101ef4 <__alltraps>

c0102784 <vector213>:
.globl vector213
vector213:
  pushl $0
c0102784:	6a 00                	push   $0x0
  pushl $213
c0102786:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c010278b:	e9 64 f7 ff ff       	jmp    c0101ef4 <__alltraps>

c0102790 <vector214>:
.globl vector214
vector214:
  pushl $0
c0102790:	6a 00                	push   $0x0
  pushl $214
c0102792:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c0102797:	e9 58 f7 ff ff       	jmp    c0101ef4 <__alltraps>

c010279c <vector215>:
.globl vector215
vector215:
  pushl $0
c010279c:	6a 00                	push   $0x0
  pushl $215
c010279e:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c01027a3:	e9 4c f7 ff ff       	jmp    c0101ef4 <__alltraps>

c01027a8 <vector216>:
.globl vector216
vector216:
  pushl $0
c01027a8:	6a 00                	push   $0x0
  pushl $216
c01027aa:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c01027af:	e9 40 f7 ff ff       	jmp    c0101ef4 <__alltraps>

c01027b4 <vector217>:
.globl vector217
vector217:
  pushl $0
c01027b4:	6a 00                	push   $0x0
  pushl $217
c01027b6:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c01027bb:	e9 34 f7 ff ff       	jmp    c0101ef4 <__alltraps>

c01027c0 <vector218>:
.globl vector218
vector218:
  pushl $0
c01027c0:	6a 00                	push   $0x0
  pushl $218
c01027c2:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c01027c7:	e9 28 f7 ff ff       	jmp    c0101ef4 <__alltraps>

c01027cc <vector219>:
.globl vector219
vector219:
  pushl $0
c01027cc:	6a 00                	push   $0x0
  pushl $219
c01027ce:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c01027d3:	e9 1c f7 ff ff       	jmp    c0101ef4 <__alltraps>

c01027d8 <vector220>:
.globl vector220
vector220:
  pushl $0
c01027d8:	6a 00                	push   $0x0
  pushl $220
c01027da:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c01027df:	e9 10 f7 ff ff       	jmp    c0101ef4 <__alltraps>

c01027e4 <vector221>:
.globl vector221
vector221:
  pushl $0
c01027e4:	6a 00                	push   $0x0
  pushl $221
c01027e6:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c01027eb:	e9 04 f7 ff ff       	jmp    c0101ef4 <__alltraps>

c01027f0 <vector222>:
.globl vector222
vector222:
  pushl $0
c01027f0:	6a 00                	push   $0x0
  pushl $222
c01027f2:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c01027f7:	e9 f8 f6 ff ff       	jmp    c0101ef4 <__alltraps>

c01027fc <vector223>:
.globl vector223
vector223:
  pushl $0
c01027fc:	6a 00                	push   $0x0
  pushl $223
c01027fe:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c0102803:	e9 ec f6 ff ff       	jmp    c0101ef4 <__alltraps>

c0102808 <vector224>:
.globl vector224
vector224:
  pushl $0
c0102808:	6a 00                	push   $0x0
  pushl $224
c010280a:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c010280f:	e9 e0 f6 ff ff       	jmp    c0101ef4 <__alltraps>

c0102814 <vector225>:
.globl vector225
vector225:
  pushl $0
c0102814:	6a 00                	push   $0x0
  pushl $225
c0102816:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c010281b:	e9 d4 f6 ff ff       	jmp    c0101ef4 <__alltraps>

c0102820 <vector226>:
.globl vector226
vector226:
  pushl $0
c0102820:	6a 00                	push   $0x0
  pushl $226
c0102822:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c0102827:	e9 c8 f6 ff ff       	jmp    c0101ef4 <__alltraps>

c010282c <vector227>:
.globl vector227
vector227:
  pushl $0
c010282c:	6a 00                	push   $0x0
  pushl $227
c010282e:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c0102833:	e9 bc f6 ff ff       	jmp    c0101ef4 <__alltraps>

c0102838 <vector228>:
.globl vector228
vector228:
  pushl $0
c0102838:	6a 00                	push   $0x0
  pushl $228
c010283a:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c010283f:	e9 b0 f6 ff ff       	jmp    c0101ef4 <__alltraps>

c0102844 <vector229>:
.globl vector229
vector229:
  pushl $0
c0102844:	6a 00                	push   $0x0
  pushl $229
c0102846:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c010284b:	e9 a4 f6 ff ff       	jmp    c0101ef4 <__alltraps>

c0102850 <vector230>:
.globl vector230
vector230:
  pushl $0
c0102850:	6a 00                	push   $0x0
  pushl $230
c0102852:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c0102857:	e9 98 f6 ff ff       	jmp    c0101ef4 <__alltraps>

c010285c <vector231>:
.globl vector231
vector231:
  pushl $0
c010285c:	6a 00                	push   $0x0
  pushl $231
c010285e:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c0102863:	e9 8c f6 ff ff       	jmp    c0101ef4 <__alltraps>

c0102868 <vector232>:
.globl vector232
vector232:
  pushl $0
c0102868:	6a 00                	push   $0x0
  pushl $232
c010286a:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c010286f:	e9 80 f6 ff ff       	jmp    c0101ef4 <__alltraps>

c0102874 <vector233>:
.globl vector233
vector233:
  pushl $0
c0102874:	6a 00                	push   $0x0
  pushl $233
c0102876:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c010287b:	e9 74 f6 ff ff       	jmp    c0101ef4 <__alltraps>

c0102880 <vector234>:
.globl vector234
vector234:
  pushl $0
c0102880:	6a 00                	push   $0x0
  pushl $234
c0102882:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c0102887:	e9 68 f6 ff ff       	jmp    c0101ef4 <__alltraps>

c010288c <vector235>:
.globl vector235
vector235:
  pushl $0
c010288c:	6a 00                	push   $0x0
  pushl $235
c010288e:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c0102893:	e9 5c f6 ff ff       	jmp    c0101ef4 <__alltraps>

c0102898 <vector236>:
.globl vector236
vector236:
  pushl $0
c0102898:	6a 00                	push   $0x0
  pushl $236
c010289a:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c010289f:	e9 50 f6 ff ff       	jmp    c0101ef4 <__alltraps>

c01028a4 <vector237>:
.globl vector237
vector237:
  pushl $0
c01028a4:	6a 00                	push   $0x0
  pushl $237
c01028a6:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c01028ab:	e9 44 f6 ff ff       	jmp    c0101ef4 <__alltraps>

c01028b0 <vector238>:
.globl vector238
vector238:
  pushl $0
c01028b0:	6a 00                	push   $0x0
  pushl $238
c01028b2:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c01028b7:	e9 38 f6 ff ff       	jmp    c0101ef4 <__alltraps>

c01028bc <vector239>:
.globl vector239
vector239:
  pushl $0
c01028bc:	6a 00                	push   $0x0
  pushl $239
c01028be:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c01028c3:	e9 2c f6 ff ff       	jmp    c0101ef4 <__alltraps>

c01028c8 <vector240>:
.globl vector240
vector240:
  pushl $0
c01028c8:	6a 00                	push   $0x0
  pushl $240
c01028ca:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c01028cf:	e9 20 f6 ff ff       	jmp    c0101ef4 <__alltraps>

c01028d4 <vector241>:
.globl vector241
vector241:
  pushl $0
c01028d4:	6a 00                	push   $0x0
  pushl $241
c01028d6:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c01028db:	e9 14 f6 ff ff       	jmp    c0101ef4 <__alltraps>

c01028e0 <vector242>:
.globl vector242
vector242:
  pushl $0
c01028e0:	6a 00                	push   $0x0
  pushl $242
c01028e2:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c01028e7:	e9 08 f6 ff ff       	jmp    c0101ef4 <__alltraps>

c01028ec <vector243>:
.globl vector243
vector243:
  pushl $0
c01028ec:	6a 00                	push   $0x0
  pushl $243
c01028ee:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c01028f3:	e9 fc f5 ff ff       	jmp    c0101ef4 <__alltraps>

c01028f8 <vector244>:
.globl vector244
vector244:
  pushl $0
c01028f8:	6a 00                	push   $0x0
  pushl $244
c01028fa:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c01028ff:	e9 f0 f5 ff ff       	jmp    c0101ef4 <__alltraps>

c0102904 <vector245>:
.globl vector245
vector245:
  pushl $0
c0102904:	6a 00                	push   $0x0
  pushl $245
c0102906:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c010290b:	e9 e4 f5 ff ff       	jmp    c0101ef4 <__alltraps>

c0102910 <vector246>:
.globl vector246
vector246:
  pushl $0
c0102910:	6a 00                	push   $0x0
  pushl $246
c0102912:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c0102917:	e9 d8 f5 ff ff       	jmp    c0101ef4 <__alltraps>

c010291c <vector247>:
.globl vector247
vector247:
  pushl $0
c010291c:	6a 00                	push   $0x0
  pushl $247
c010291e:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c0102923:	e9 cc f5 ff ff       	jmp    c0101ef4 <__alltraps>

c0102928 <vector248>:
.globl vector248
vector248:
  pushl $0
c0102928:	6a 00                	push   $0x0
  pushl $248
c010292a:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c010292f:	e9 c0 f5 ff ff       	jmp    c0101ef4 <__alltraps>

c0102934 <vector249>:
.globl vector249
vector249:
  pushl $0
c0102934:	6a 00                	push   $0x0
  pushl $249
c0102936:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c010293b:	e9 b4 f5 ff ff       	jmp    c0101ef4 <__alltraps>

c0102940 <vector250>:
.globl vector250
vector250:
  pushl $0
c0102940:	6a 00                	push   $0x0
  pushl $250
c0102942:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c0102947:	e9 a8 f5 ff ff       	jmp    c0101ef4 <__alltraps>

c010294c <vector251>:
.globl vector251
vector251:
  pushl $0
c010294c:	6a 00                	push   $0x0
  pushl $251
c010294e:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c0102953:	e9 9c f5 ff ff       	jmp    c0101ef4 <__alltraps>

c0102958 <vector252>:
.globl vector252
vector252:
  pushl $0
c0102958:	6a 00                	push   $0x0
  pushl $252
c010295a:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c010295f:	e9 90 f5 ff ff       	jmp    c0101ef4 <__alltraps>

c0102964 <vector253>:
.globl vector253
vector253:
  pushl $0
c0102964:	6a 00                	push   $0x0
  pushl $253
c0102966:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c010296b:	e9 84 f5 ff ff       	jmp    c0101ef4 <__alltraps>

c0102970 <vector254>:
.globl vector254
vector254:
  pushl $0
c0102970:	6a 00                	push   $0x0
  pushl $254
c0102972:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c0102977:	e9 78 f5 ff ff       	jmp    c0101ef4 <__alltraps>

c010297c <vector255>:
.globl vector255
vector255:
  pushl $0
c010297c:	6a 00                	push   $0x0
  pushl $255
c010297e:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c0102983:	e9 6c f5 ff ff       	jmp    c0101ef4 <__alltraps>

c0102988 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0102988:	55                   	push   %ebp
c0102989:	89 e5                	mov    %esp,%ebp
    return page - pages;
c010298b:	8b 15 a0 ce 11 c0    	mov    0xc011cea0,%edx
c0102991:	8b 45 08             	mov    0x8(%ebp),%eax
c0102994:	29 d0                	sub    %edx,%eax
c0102996:	c1 f8 02             	sar    $0x2,%eax
c0102999:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c010299f:	5d                   	pop    %ebp
c01029a0:	c3                   	ret    

c01029a1 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c01029a1:	55                   	push   %ebp
c01029a2:	89 e5                	mov    %esp,%ebp
c01029a4:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c01029a7:	8b 45 08             	mov    0x8(%ebp),%eax
c01029aa:	89 04 24             	mov    %eax,(%esp)
c01029ad:	e8 d6 ff ff ff       	call   c0102988 <page2ppn>
c01029b2:	c1 e0 0c             	shl    $0xc,%eax
}
c01029b5:	89 ec                	mov    %ebp,%esp
c01029b7:	5d                   	pop    %ebp
c01029b8:	c3                   	ret    

c01029b9 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c01029b9:	55                   	push   %ebp
c01029ba:	89 e5                	mov    %esp,%ebp
    return page->ref;
c01029bc:	8b 45 08             	mov    0x8(%ebp),%eax
c01029bf:	8b 00                	mov    (%eax),%eax
}
c01029c1:	5d                   	pop    %ebp
c01029c2:	c3                   	ret    

c01029c3 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c01029c3:	55                   	push   %ebp
c01029c4:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c01029c6:	8b 45 08             	mov    0x8(%ebp),%eax
c01029c9:	8b 55 0c             	mov    0xc(%ebp),%edx
c01029cc:	89 10                	mov    %edx,(%eax)
}
c01029ce:	90                   	nop
c01029cf:	5d                   	pop    %ebp
c01029d0:	c3                   	ret    

c01029d1 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c01029d1:	55                   	push   %ebp
c01029d2:	89 e5                	mov    %esp,%ebp
c01029d4:	83 ec 10             	sub    $0x10,%esp
c01029d7:	c7 45 fc 80 ce 11 c0 	movl   $0xc011ce80,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01029de:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01029e1:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01029e4:	89 50 04             	mov    %edx,0x4(%eax)
c01029e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01029ea:	8b 50 04             	mov    0x4(%eax),%edx
c01029ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01029f0:	89 10                	mov    %edx,(%eax)
}
c01029f2:	90                   	nop
    list_init(&free_list);
    nr_free = 0;
c01029f3:	c7 05 88 ce 11 c0 00 	movl   $0x0,0xc011ce88
c01029fa:	00 00 00 
}
c01029fd:	90                   	nop
c01029fe:	89 ec                	mov    %ebp,%esp
c0102a00:	5d                   	pop    %ebp
c0102a01:	c3                   	ret    

c0102a02 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c0102a02:	55                   	push   %ebp
c0102a03:	89 e5                	mov    %esp,%ebp
c0102a05:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
c0102a08:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0102a0c:	75 24                	jne    c0102a32 <default_init_memmap+0x30>
c0102a0e:	c7 44 24 0c 30 68 10 	movl   $0xc0106830,0xc(%esp)
c0102a15:	c0 
c0102a16:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c0102a1d:	c0 
c0102a1e:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c0102a25:	00 
c0102a26:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c0102a2d:	e8 d0 e2 ff ff       	call   c0100d02 <__panic>
    struct Page *p = base;
c0102a32:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a35:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0102a38:	eb 7d                	jmp    c0102ab7 <default_init_memmap+0xb5>
        assert(PageReserved(p));
c0102a3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a3d:	83 c0 04             	add    $0x4,%eax
c0102a40:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0102a47:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102a4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102a4d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0102a50:	0f a3 10             	bt     %edx,(%eax)
c0102a53:	19 c0                	sbb    %eax,%eax
c0102a55:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c0102a58:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0102a5c:	0f 95 c0             	setne  %al
c0102a5f:	0f b6 c0             	movzbl %al,%eax
c0102a62:	85 c0                	test   %eax,%eax
c0102a64:	75 24                	jne    c0102a8a <default_init_memmap+0x88>
c0102a66:	c7 44 24 0c 61 68 10 	movl   $0xc0106861,0xc(%esp)
c0102a6d:	c0 
c0102a6e:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c0102a75:	c0 
c0102a76:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
c0102a7d:	00 
c0102a7e:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c0102a85:	e8 78 e2 ff ff       	call   c0100d02 <__panic>
        p->flags = p->property = 0;
c0102a8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a8d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c0102a94:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a97:	8b 50 08             	mov    0x8(%eax),%edx
c0102a9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a9d:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
c0102aa0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102aa7:	00 
c0102aa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102aab:	89 04 24             	mov    %eax,(%esp)
c0102aae:	e8 10 ff ff ff       	call   c01029c3 <set_page_ref>
    for (; p != base + n; p ++) {
c0102ab3:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0102ab7:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102aba:	89 d0                	mov    %edx,%eax
c0102abc:	c1 e0 02             	shl    $0x2,%eax
c0102abf:	01 d0                	add    %edx,%eax
c0102ac1:	c1 e0 02             	shl    $0x2,%eax
c0102ac4:	89 c2                	mov    %eax,%edx
c0102ac6:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ac9:	01 d0                	add    %edx,%eax
c0102acb:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0102ace:	0f 85 66 ff ff ff    	jne    c0102a3a <default_init_memmap+0x38>
    }
    base->property = n;
c0102ad4:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ad7:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102ada:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0102add:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ae0:	83 c0 04             	add    $0x4,%eax
c0102ae3:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
c0102aea:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102aed:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102af0:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0102af3:	0f ab 10             	bts    %edx,(%eax)
}
c0102af6:	90                   	nop
    nr_free += n;
c0102af7:	8b 15 88 ce 11 c0    	mov    0xc011ce88,%edx
c0102afd:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102b00:	01 d0                	add    %edx,%eax
c0102b02:	a3 88 ce 11 c0       	mov    %eax,0xc011ce88
    list_add(&free_list, &(base->page_link));
c0102b07:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b0a:	83 c0 0c             	add    $0xc,%eax
c0102b0d:	c7 45 e4 80 ce 11 c0 	movl   $0xc011ce80,-0x1c(%ebp)
c0102b14:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0102b17:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102b1a:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0102b1d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102b20:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0102b23:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102b26:	8b 40 04             	mov    0x4(%eax),%eax
c0102b29:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0102b2c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0102b2f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102b32:	89 55 d0             	mov    %edx,-0x30(%ebp)
c0102b35:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102b38:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102b3b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102b3e:	89 10                	mov    %edx,(%eax)
c0102b40:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102b43:	8b 10                	mov    (%eax),%edx
c0102b45:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102b48:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102b4b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102b4e:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102b51:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102b54:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102b57:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102b5a:	89 10                	mov    %edx,(%eax)
}
c0102b5c:	90                   	nop
}
c0102b5d:	90                   	nop
}
c0102b5e:	90                   	nop
}
c0102b5f:	90                   	nop
c0102b60:	89 ec                	mov    %ebp,%esp
c0102b62:	5d                   	pop    %ebp
c0102b63:	c3                   	ret    

c0102b64 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c0102b64:	55                   	push   %ebp
c0102b65:	89 e5                	mov    %esp,%ebp
c0102b67:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c0102b6a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0102b6e:	75 24                	jne    c0102b94 <default_alloc_pages+0x30>
c0102b70:	c7 44 24 0c 30 68 10 	movl   $0xc0106830,0xc(%esp)
c0102b77:	c0 
c0102b78:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c0102b7f:	c0 
c0102b80:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
c0102b87:	00 
c0102b88:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c0102b8f:	e8 6e e1 ff ff       	call   c0100d02 <__panic>
    if (n > nr_free) {
c0102b94:	a1 88 ce 11 c0       	mov    0xc011ce88,%eax
c0102b99:	39 45 08             	cmp    %eax,0x8(%ebp)
c0102b9c:	76 0a                	jbe    c0102ba8 <default_alloc_pages+0x44>
        return NULL;
c0102b9e:	b8 00 00 00 00       	mov    $0x0,%eax
c0102ba3:	e9 62 01 00 00       	jmp    c0102d0a <default_alloc_pages+0x1a6>
    }
    struct Page *page = NULL;
c0102ba8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c0102baf:	c7 45 f0 80 ce 11 c0 	movl   $0xc011ce80,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0102bb6:	eb 1c                	jmp    c0102bd4 <default_alloc_pages+0x70>
        struct Page *p = le2page(le, page_link);
c0102bb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102bbb:	83 e8 0c             	sub    $0xc,%eax
c0102bbe:	89 45 e8             	mov    %eax,-0x18(%ebp)
        if (p->property >= n) {
c0102bc1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102bc4:	8b 40 08             	mov    0x8(%eax),%eax
c0102bc7:	39 45 08             	cmp    %eax,0x8(%ebp)
c0102bca:	77 08                	ja     c0102bd4 <default_alloc_pages+0x70>
            page = p;
c0102bcc:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102bcf:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c0102bd2:	eb 18                	jmp    c0102bec <default_alloc_pages+0x88>
c0102bd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102bd7:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return listelm->next;
c0102bda:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102bdd:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c0102be0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102be3:	81 7d f0 80 ce 11 c0 	cmpl   $0xc011ce80,-0x10(%ebp)
c0102bea:	75 cc                	jne    c0102bb8 <default_alloc_pages+0x54>
        }
    }
    if (page != NULL) {
c0102bec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102bf0:	0f 84 11 01 00 00    	je     c0102d07 <default_alloc_pages+0x1a3>
        list_del(&(page->page_link));
c0102bf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102bf9:	83 c0 0c             	add    $0xc,%eax
c0102bfc:	89 45 dc             	mov    %eax,-0x24(%ebp)
    __list_del(listelm->prev, listelm->next);
c0102bff:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102c02:	8b 40 04             	mov    0x4(%eax),%eax
c0102c05:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102c08:	8b 12                	mov    (%edx),%edx
c0102c0a:	89 55 d8             	mov    %edx,-0x28(%ebp)
c0102c0d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102c10:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102c13:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102c16:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102c19:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102c1c:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0102c1f:	89 10                	mov    %edx,(%eax)
}
c0102c21:	90                   	nop
}
c0102c22:	90                   	nop
        if (page->property > n) {
c0102c23:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c26:	8b 40 08             	mov    0x8(%eax),%eax
c0102c29:	39 45 08             	cmp    %eax,0x8(%ebp)
c0102c2c:	0f 83 ae 00 00 00    	jae    c0102ce0 <default_alloc_pages+0x17c>
            struct Page *p = page + n;
c0102c32:	8b 55 08             	mov    0x8(%ebp),%edx
c0102c35:	89 d0                	mov    %edx,%eax
c0102c37:	c1 e0 02             	shl    $0x2,%eax
c0102c3a:	01 d0                	add    %edx,%eax
c0102c3c:	c1 e0 02             	shl    $0x2,%eax
c0102c3f:	89 c2                	mov    %eax,%edx
c0102c41:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c44:	01 d0                	add    %edx,%eax
c0102c46:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            p->property = page->property - n;
c0102c49:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c4c:	8b 40 08             	mov    0x8(%eax),%eax
c0102c4f:	2b 45 08             	sub    0x8(%ebp),%eax
c0102c52:	89 c2                	mov    %eax,%edx
c0102c54:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102c57:	89 50 08             	mov    %edx,0x8(%eax)
c0102c5a:	c7 45 d0 80 ce 11 c0 	movl   $0xc011ce80,-0x30(%ebp)
    return listelm->next;
c0102c61:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102c64:	8b 40 04             	mov    0x4(%eax),%eax
            //原来的代码没有实现有序链入
            //list_add(&free_list, &(p->page_link));
            
            //找到第一个比剩余内存块要大的内存块，并把剩余块插到它之前
            struct list_entry_t* it;
            for(it=list_next(&free_list);it!=&free_list && le2page(it,page_link)->property < p->property;it=list_next(it));
c0102c67:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0102c6a:	eb 0f                	jmp    c0102c7b <default_alloc_pages+0x117>
c0102c6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102c6f:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0102c72:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102c75:	8b 40 04             	mov    0x4(%eax),%eax
c0102c78:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0102c7b:	81 7d ec 80 ce 11 c0 	cmpl   $0xc011ce80,-0x14(%ebp)
c0102c82:	74 13                	je     c0102c97 <default_alloc_pages+0x133>
c0102c84:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102c87:	83 e8 0c             	sub    $0xc,%eax
c0102c8a:	8b 50 08             	mov    0x8(%eax),%edx
c0102c8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102c90:	8b 40 08             	mov    0x8(%eax),%eax
c0102c93:	39 c2                	cmp    %eax,%edx
c0102c95:	72 d5                	jb     c0102c6c <default_alloc_pages+0x108>
            list_add_before(it, &(p->page_link));
c0102c97:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102c9a:	8d 50 0c             	lea    0xc(%eax),%edx
c0102c9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102ca0:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0102ca3:	89 55 c4             	mov    %edx,-0x3c(%ebp)
    __list_add(elm, listelm->prev, listelm);
c0102ca6:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102ca9:	8b 00                	mov    (%eax),%eax
c0102cab:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102cae:	89 55 c0             	mov    %edx,-0x40(%ebp)
c0102cb1:	89 45 bc             	mov    %eax,-0x44(%ebp)
c0102cb4:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102cb7:	89 45 b8             	mov    %eax,-0x48(%ebp)
    prev->next = next->prev = elm;
c0102cba:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102cbd:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0102cc0:	89 10                	mov    %edx,(%eax)
c0102cc2:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102cc5:	8b 10                	mov    (%eax),%edx
c0102cc7:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102cca:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102ccd:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102cd0:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0102cd3:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102cd6:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102cd9:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102cdc:	89 10                	mov    %edx,(%eax)
}
c0102cde:	90                   	nop
}
c0102cdf:	90                   	nop
    }
        nr_free -= n;
c0102ce0:	a1 88 ce 11 c0       	mov    0xc011ce88,%eax
c0102ce5:	2b 45 08             	sub    0x8(%ebp),%eax
c0102ce8:	a3 88 ce 11 c0       	mov    %eax,0xc011ce88
        ClearPageProperty(page);
c0102ced:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102cf0:	83 c0 04             	add    $0x4,%eax
c0102cf3:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
c0102cfa:	89 45 b0             	mov    %eax,-0x50(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102cfd:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0102d00:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0102d03:	0f b3 10             	btr    %edx,(%eax)
}
c0102d06:	90                   	nop
    }
    return page;
c0102d07:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0102d0a:	89 ec                	mov    %ebp,%esp
c0102d0c:	5d                   	pop    %ebp
c0102d0d:	c3                   	ret    

c0102d0e <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c0102d0e:	55                   	push   %ebp
c0102d0f:	89 e5                	mov    %esp,%ebp
c0102d11:	81 ec 98 00 00 00    	sub    $0x98,%esp
    assert(n > 0);
c0102d17:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0102d1b:	75 24                	jne    c0102d41 <default_free_pages+0x33>
c0102d1d:	c7 44 24 0c 30 68 10 	movl   $0xc0106830,0xc(%esp)
c0102d24:	c0 
c0102d25:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c0102d2c:	c0 
c0102d2d:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
c0102d34:	00 
c0102d35:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c0102d3c:	e8 c1 df ff ff       	call   c0100d02 <__panic>
    struct Page *p = base;
c0102d41:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d44:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0102d47:	e9 9d 00 00 00       	jmp    c0102de9 <default_free_pages+0xdb>
        assert(!PageReserved(p) && !PageProperty(p));
c0102d4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d4f:	83 c0 04             	add    $0x4,%eax
c0102d52:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0102d59:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102d5c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102d5f:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0102d62:	0f a3 10             	bt     %edx,(%eax)
c0102d65:	19 c0                	sbb    %eax,%eax
c0102d67:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return oldbit != 0;
c0102d6a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0102d6e:	0f 95 c0             	setne  %al
c0102d71:	0f b6 c0             	movzbl %al,%eax
c0102d74:	85 c0                	test   %eax,%eax
c0102d76:	75 2c                	jne    c0102da4 <default_free_pages+0x96>
c0102d78:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d7b:	83 c0 04             	add    $0x4,%eax
c0102d7e:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
c0102d85:	89 45 d8             	mov    %eax,-0x28(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102d88:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102d8b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102d8e:	0f a3 10             	bt     %edx,(%eax)
c0102d91:	19 c0                	sbb    %eax,%eax
c0102d93:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    return oldbit != 0;
c0102d96:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c0102d9a:	0f 95 c0             	setne  %al
c0102d9d:	0f b6 c0             	movzbl %al,%eax
c0102da0:	85 c0                	test   %eax,%eax
c0102da2:	74 24                	je     c0102dc8 <default_free_pages+0xba>
c0102da4:	c7 44 24 0c 74 68 10 	movl   $0xc0106874,0xc(%esp)
c0102dab:	c0 
c0102dac:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c0102db3:	c0 
c0102db4:	c7 44 24 04 a1 00 00 	movl   $0xa1,0x4(%esp)
c0102dbb:	00 
c0102dbc:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c0102dc3:	e8 3a df ff ff       	call   c0100d02 <__panic>
        p->flags = 0;
c0102dc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102dcb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
c0102dd2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102dd9:	00 
c0102dda:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ddd:	89 04 24             	mov    %eax,(%esp)
c0102de0:	e8 de fb ff ff       	call   c01029c3 <set_page_ref>
    for (; p != base + n; p ++) {
c0102de5:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0102de9:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102dec:	89 d0                	mov    %edx,%eax
c0102dee:	c1 e0 02             	shl    $0x2,%eax
c0102df1:	01 d0                	add    %edx,%eax
c0102df3:	c1 e0 02             	shl    $0x2,%eax
c0102df6:	89 c2                	mov    %eax,%edx
c0102df8:	8b 45 08             	mov    0x8(%ebp),%eax
c0102dfb:	01 d0                	add    %edx,%eax
c0102dfd:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0102e00:	0f 85 46 ff ff ff    	jne    c0102d4c <default_free_pages+0x3e>
    }
    base->property = n;
c0102e06:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e09:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102e0c:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0102e0f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e12:	83 c0 04             	add    $0x4,%eax
c0102e15:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
c0102e1c:	89 45 c8             	mov    %eax,-0x38(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102e1f:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102e22:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102e25:	0f ab 10             	bts    %edx,(%eax)
}
c0102e28:	90                   	nop
c0102e29:	c7 45 d0 80 ce 11 c0 	movl   $0xc011ce80,-0x30(%ebp)
    return listelm->next;
c0102e30:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102e33:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
c0102e36:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c0102e39:	e9 0e 01 00 00       	jmp    c0102f4c <default_free_pages+0x23e>
        p = le2page(le, page_link);
c0102e3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102e41:	83 e8 0c             	sub    $0xc,%eax
c0102e44:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102e47:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102e4a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c0102e4d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102e50:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c0102e53:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (base + base->property == p) {
c0102e56:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e59:	8b 50 08             	mov    0x8(%eax),%edx
c0102e5c:	89 d0                	mov    %edx,%eax
c0102e5e:	c1 e0 02             	shl    $0x2,%eax
c0102e61:	01 d0                	add    %edx,%eax
c0102e63:	c1 e0 02             	shl    $0x2,%eax
c0102e66:	89 c2                	mov    %eax,%edx
c0102e68:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e6b:	01 d0                	add    %edx,%eax
c0102e6d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0102e70:	75 5d                	jne    c0102ecf <default_free_pages+0x1c1>
            base->property += p->property;
c0102e72:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e75:	8b 50 08             	mov    0x8(%eax),%edx
c0102e78:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e7b:	8b 40 08             	mov    0x8(%eax),%eax
c0102e7e:	01 c2                	add    %eax,%edx
c0102e80:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e83:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
c0102e86:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e89:	83 c0 04             	add    $0x4,%eax
c0102e8c:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
c0102e93:	89 45 b0             	mov    %eax,-0x50(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102e96:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0102e99:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0102e9c:	0f b3 10             	btr    %edx,(%eax)
}
c0102e9f:	90                   	nop
            list_del(&(p->page_link));
c0102ea0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ea3:	83 c0 0c             	add    $0xc,%eax
c0102ea6:	89 45 c0             	mov    %eax,-0x40(%ebp)
    __list_del(listelm->prev, listelm->next);
c0102ea9:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102eac:	8b 40 04             	mov    0x4(%eax),%eax
c0102eaf:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0102eb2:	8b 12                	mov    (%edx),%edx
c0102eb4:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0102eb7:	89 45 b8             	mov    %eax,-0x48(%ebp)
    prev->next = next;
c0102eba:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102ebd:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0102ec0:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102ec3:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102ec6:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102ec9:	89 10                	mov    %edx,(%eax)
}
c0102ecb:	90                   	nop
}
c0102ecc:	90                   	nop
c0102ecd:	eb 7d                	jmp    c0102f4c <default_free_pages+0x23e>
        }
        else if (p + p->property == base) {
c0102ecf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ed2:	8b 50 08             	mov    0x8(%eax),%edx
c0102ed5:	89 d0                	mov    %edx,%eax
c0102ed7:	c1 e0 02             	shl    $0x2,%eax
c0102eda:	01 d0                	add    %edx,%eax
c0102edc:	c1 e0 02             	shl    $0x2,%eax
c0102edf:	89 c2                	mov    %eax,%edx
c0102ee1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ee4:	01 d0                	add    %edx,%eax
c0102ee6:	39 45 08             	cmp    %eax,0x8(%ebp)
c0102ee9:	75 61                	jne    c0102f4c <default_free_pages+0x23e>
            p->property += base->property;
c0102eeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102eee:	8b 50 08             	mov    0x8(%eax),%edx
c0102ef1:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ef4:	8b 40 08             	mov    0x8(%eax),%eax
c0102ef7:	01 c2                	add    %eax,%edx
c0102ef9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102efc:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
c0102eff:	8b 45 08             	mov    0x8(%ebp),%eax
c0102f02:	83 c0 04             	add    $0x4,%eax
c0102f05:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c0102f0c:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102f0f:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0102f12:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0102f15:	0f b3 10             	btr    %edx,(%eax)
}
c0102f18:	90                   	nop
            base = p;
c0102f19:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f1c:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
c0102f1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f22:	83 c0 0c             	add    $0xc,%eax
c0102f25:	89 45 ac             	mov    %eax,-0x54(%ebp)
    __list_del(listelm->prev, listelm->next);
c0102f28:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0102f2b:	8b 40 04             	mov    0x4(%eax),%eax
c0102f2e:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0102f31:	8b 12                	mov    (%edx),%edx
c0102f33:	89 55 a8             	mov    %edx,-0x58(%ebp)
c0102f36:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    prev->next = next;
c0102f39:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0102f3c:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0102f3f:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102f42:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0102f45:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0102f48:	89 10                	mov    %edx,(%eax)
}
c0102f4a:	90                   	nop
}
c0102f4b:	90                   	nop
    while (le != &free_list) {
c0102f4c:	81 7d f0 80 ce 11 c0 	cmpl   $0xc011ce80,-0x10(%ebp)
c0102f53:	0f 85 e5 fe ff ff    	jne    c0102e3e <default_free_pages+0x130>
        }
    }
    nr_free += n;
c0102f59:	8b 15 88 ce 11 c0    	mov    0xc011ce88,%edx
c0102f5f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102f62:	01 d0                	add    %edx,%eax
c0102f64:	a3 88 ce 11 c0       	mov    %eax,0xc011ce88
c0102f69:	c7 45 98 80 ce 11 c0 	movl   $0xc011ce80,-0x68(%ebp)
    return listelm->next;
c0102f70:	8b 45 98             	mov    -0x68(%ebp),%eax
c0102f73:	8b 40 04             	mov    0x4(%eax),%eax
    struct list_entry_t* it;
    for(it=list_next(&free_list);it!=&free_list && le2page(it,page_link)->property < base->property;it=list_next(it));
c0102f76:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0102f79:	eb 0f                	jmp    c0102f8a <default_free_pages+0x27c>
c0102f7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102f7e:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0102f81:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0102f84:	8b 40 04             	mov    0x4(%eax),%eax
c0102f87:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0102f8a:	81 7d ec 80 ce 11 c0 	cmpl   $0xc011ce80,-0x14(%ebp)
c0102f91:	74 13                	je     c0102fa6 <default_free_pages+0x298>
c0102f93:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102f96:	83 e8 0c             	sub    $0xc,%eax
c0102f99:	8b 50 08             	mov    0x8(%eax),%edx
c0102f9c:	8b 45 08             	mov    0x8(%ebp),%eax
c0102f9f:	8b 40 08             	mov    0x8(%eax),%eax
c0102fa2:	39 c2                	cmp    %eax,%edx
c0102fa4:	72 d5                	jb     c0102f7b <default_free_pages+0x26d>
    list_add_before(it, &(base->page_link));
c0102fa6:	8b 45 08             	mov    0x8(%ebp),%eax
c0102fa9:	8d 50 0c             	lea    0xc(%eax),%edx
c0102fac:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102faf:	89 45 90             	mov    %eax,-0x70(%ebp)
c0102fb2:	89 55 8c             	mov    %edx,-0x74(%ebp)
    __list_add(elm, listelm->prev, listelm);
c0102fb5:	8b 45 90             	mov    -0x70(%ebp),%eax
c0102fb8:	8b 00                	mov    (%eax),%eax
c0102fba:	8b 55 8c             	mov    -0x74(%ebp),%edx
c0102fbd:	89 55 88             	mov    %edx,-0x78(%ebp)
c0102fc0:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0102fc3:	8b 45 90             	mov    -0x70(%ebp),%eax
c0102fc6:	89 45 80             	mov    %eax,-0x80(%ebp)
    prev->next = next->prev = elm;
c0102fc9:	8b 45 80             	mov    -0x80(%ebp),%eax
c0102fcc:	8b 55 88             	mov    -0x78(%ebp),%edx
c0102fcf:	89 10                	mov    %edx,(%eax)
c0102fd1:	8b 45 80             	mov    -0x80(%ebp),%eax
c0102fd4:	8b 10                	mov    (%eax),%edx
c0102fd6:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0102fd9:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102fdc:	8b 45 88             	mov    -0x78(%ebp),%eax
c0102fdf:	8b 55 80             	mov    -0x80(%ebp),%edx
c0102fe2:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102fe5:	8b 45 88             	mov    -0x78(%ebp),%eax
c0102fe8:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0102feb:	89 10                	mov    %edx,(%eax)
}
c0102fed:	90                   	nop
}
c0102fee:	90                   	nop
    
    //原来的代码没有实现有序链入
    //list_add(&free_list, &(base->page_link));
}
c0102fef:	90                   	nop
c0102ff0:	89 ec                	mov    %ebp,%esp
c0102ff2:	5d                   	pop    %ebp
c0102ff3:	c3                   	ret    

c0102ff4 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c0102ff4:	55                   	push   %ebp
c0102ff5:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0102ff7:	a1 88 ce 11 c0       	mov    0xc011ce88,%eax
}
c0102ffc:	5d                   	pop    %ebp
c0102ffd:	c3                   	ret    

c0102ffe <basic_check>:

static void
basic_check(void) {
c0102ffe:	55                   	push   %ebp
c0102fff:	89 e5                	mov    %esp,%ebp
c0103001:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0103004:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010300b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010300e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103011:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103014:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0103017:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010301e:	e8 ed 0e 00 00       	call   c0103f10 <alloc_pages>
c0103023:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103026:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c010302a:	75 24                	jne    c0103050 <basic_check+0x52>
c010302c:	c7 44 24 0c 99 68 10 	movl   $0xc0106899,0xc(%esp)
c0103033:	c0 
c0103034:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c010303b:	c0 
c010303c:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
c0103043:	00 
c0103044:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c010304b:	e8 b2 dc ff ff       	call   c0100d02 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0103050:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103057:	e8 b4 0e 00 00       	call   c0103f10 <alloc_pages>
c010305c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010305f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103063:	75 24                	jne    c0103089 <basic_check+0x8b>
c0103065:	c7 44 24 0c b5 68 10 	movl   $0xc01068b5,0xc(%esp)
c010306c:	c0 
c010306d:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c0103074:	c0 
c0103075:	c7 44 24 04 ca 00 00 	movl   $0xca,0x4(%esp)
c010307c:	00 
c010307d:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c0103084:	e8 79 dc ff ff       	call   c0100d02 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0103089:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103090:	e8 7b 0e 00 00       	call   c0103f10 <alloc_pages>
c0103095:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103098:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010309c:	75 24                	jne    c01030c2 <basic_check+0xc4>
c010309e:	c7 44 24 0c d1 68 10 	movl   $0xc01068d1,0xc(%esp)
c01030a5:	c0 
c01030a6:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c01030ad:	c0 
c01030ae:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
c01030b5:	00 
c01030b6:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c01030bd:	e8 40 dc ff ff       	call   c0100d02 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c01030c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01030c5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01030c8:	74 10                	je     c01030da <basic_check+0xdc>
c01030ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01030cd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01030d0:	74 08                	je     c01030da <basic_check+0xdc>
c01030d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01030d5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01030d8:	75 24                	jne    c01030fe <basic_check+0x100>
c01030da:	c7 44 24 0c f0 68 10 	movl   $0xc01068f0,0xc(%esp)
c01030e1:	c0 
c01030e2:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c01030e9:	c0 
c01030ea:	c7 44 24 04 cd 00 00 	movl   $0xcd,0x4(%esp)
c01030f1:	00 
c01030f2:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c01030f9:	e8 04 dc ff ff       	call   c0100d02 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c01030fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103101:	89 04 24             	mov    %eax,(%esp)
c0103104:	e8 b0 f8 ff ff       	call   c01029b9 <page_ref>
c0103109:	85 c0                	test   %eax,%eax
c010310b:	75 1e                	jne    c010312b <basic_check+0x12d>
c010310d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103110:	89 04 24             	mov    %eax,(%esp)
c0103113:	e8 a1 f8 ff ff       	call   c01029b9 <page_ref>
c0103118:	85 c0                	test   %eax,%eax
c010311a:	75 0f                	jne    c010312b <basic_check+0x12d>
c010311c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010311f:	89 04 24             	mov    %eax,(%esp)
c0103122:	e8 92 f8 ff ff       	call   c01029b9 <page_ref>
c0103127:	85 c0                	test   %eax,%eax
c0103129:	74 24                	je     c010314f <basic_check+0x151>
c010312b:	c7 44 24 0c 14 69 10 	movl   $0xc0106914,0xc(%esp)
c0103132:	c0 
c0103133:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c010313a:	c0 
c010313b:	c7 44 24 04 ce 00 00 	movl   $0xce,0x4(%esp)
c0103142:	00 
c0103143:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c010314a:	e8 b3 db ff ff       	call   c0100d02 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c010314f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103152:	89 04 24             	mov    %eax,(%esp)
c0103155:	e8 47 f8 ff ff       	call   c01029a1 <page2pa>
c010315a:	8b 15 a4 ce 11 c0    	mov    0xc011cea4,%edx
c0103160:	c1 e2 0c             	shl    $0xc,%edx
c0103163:	39 d0                	cmp    %edx,%eax
c0103165:	72 24                	jb     c010318b <basic_check+0x18d>
c0103167:	c7 44 24 0c 50 69 10 	movl   $0xc0106950,0xc(%esp)
c010316e:	c0 
c010316f:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c0103176:	c0 
c0103177:	c7 44 24 04 d0 00 00 	movl   $0xd0,0x4(%esp)
c010317e:	00 
c010317f:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c0103186:	e8 77 db ff ff       	call   c0100d02 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c010318b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010318e:	89 04 24             	mov    %eax,(%esp)
c0103191:	e8 0b f8 ff ff       	call   c01029a1 <page2pa>
c0103196:	8b 15 a4 ce 11 c0    	mov    0xc011cea4,%edx
c010319c:	c1 e2 0c             	shl    $0xc,%edx
c010319f:	39 d0                	cmp    %edx,%eax
c01031a1:	72 24                	jb     c01031c7 <basic_check+0x1c9>
c01031a3:	c7 44 24 0c 6d 69 10 	movl   $0xc010696d,0xc(%esp)
c01031aa:	c0 
c01031ab:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c01031b2:	c0 
c01031b3:	c7 44 24 04 d1 00 00 	movl   $0xd1,0x4(%esp)
c01031ba:	00 
c01031bb:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c01031c2:	e8 3b db ff ff       	call   c0100d02 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c01031c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01031ca:	89 04 24             	mov    %eax,(%esp)
c01031cd:	e8 cf f7 ff ff       	call   c01029a1 <page2pa>
c01031d2:	8b 15 a4 ce 11 c0    	mov    0xc011cea4,%edx
c01031d8:	c1 e2 0c             	shl    $0xc,%edx
c01031db:	39 d0                	cmp    %edx,%eax
c01031dd:	72 24                	jb     c0103203 <basic_check+0x205>
c01031df:	c7 44 24 0c 8a 69 10 	movl   $0xc010698a,0xc(%esp)
c01031e6:	c0 
c01031e7:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c01031ee:	c0 
c01031ef:	c7 44 24 04 d2 00 00 	movl   $0xd2,0x4(%esp)
c01031f6:	00 
c01031f7:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c01031fe:	e8 ff da ff ff       	call   c0100d02 <__panic>

    list_entry_t free_list_store = free_list;
c0103203:	a1 80 ce 11 c0       	mov    0xc011ce80,%eax
c0103208:	8b 15 84 ce 11 c0    	mov    0xc011ce84,%edx
c010320e:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103211:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103214:	c7 45 dc 80 ce 11 c0 	movl   $0xc011ce80,-0x24(%ebp)
    elm->prev = elm->next = elm;
c010321b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010321e:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103221:	89 50 04             	mov    %edx,0x4(%eax)
c0103224:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103227:	8b 50 04             	mov    0x4(%eax),%edx
c010322a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010322d:	89 10                	mov    %edx,(%eax)
}
c010322f:	90                   	nop
c0103230:	c7 45 e0 80 ce 11 c0 	movl   $0xc011ce80,-0x20(%ebp)
    return list->next == list;
c0103237:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010323a:	8b 40 04             	mov    0x4(%eax),%eax
c010323d:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0103240:	0f 94 c0             	sete   %al
c0103243:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0103246:	85 c0                	test   %eax,%eax
c0103248:	75 24                	jne    c010326e <basic_check+0x270>
c010324a:	c7 44 24 0c a7 69 10 	movl   $0xc01069a7,0xc(%esp)
c0103251:	c0 
c0103252:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c0103259:	c0 
c010325a:	c7 44 24 04 d6 00 00 	movl   $0xd6,0x4(%esp)
c0103261:	00 
c0103262:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c0103269:	e8 94 da ff ff       	call   c0100d02 <__panic>

    unsigned int nr_free_store = nr_free;
c010326e:	a1 88 ce 11 c0       	mov    0xc011ce88,%eax
c0103273:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c0103276:	c7 05 88 ce 11 c0 00 	movl   $0x0,0xc011ce88
c010327d:	00 00 00 

    assert(alloc_page() == NULL);
c0103280:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103287:	e8 84 0c 00 00       	call   c0103f10 <alloc_pages>
c010328c:	85 c0                	test   %eax,%eax
c010328e:	74 24                	je     c01032b4 <basic_check+0x2b6>
c0103290:	c7 44 24 0c be 69 10 	movl   $0xc01069be,0xc(%esp)
c0103297:	c0 
c0103298:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c010329f:	c0 
c01032a0:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
c01032a7:	00 
c01032a8:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c01032af:	e8 4e da ff ff       	call   c0100d02 <__panic>

    free_page(p0);
c01032b4:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01032bb:	00 
c01032bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01032bf:	89 04 24             	mov    %eax,(%esp)
c01032c2:	e8 83 0c 00 00       	call   c0103f4a <free_pages>
    free_page(p1);
c01032c7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01032ce:	00 
c01032cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01032d2:	89 04 24             	mov    %eax,(%esp)
c01032d5:	e8 70 0c 00 00       	call   c0103f4a <free_pages>
    free_page(p2);
c01032da:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01032e1:	00 
c01032e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01032e5:	89 04 24             	mov    %eax,(%esp)
c01032e8:	e8 5d 0c 00 00       	call   c0103f4a <free_pages>
    assert(nr_free == 3);
c01032ed:	a1 88 ce 11 c0       	mov    0xc011ce88,%eax
c01032f2:	83 f8 03             	cmp    $0x3,%eax
c01032f5:	74 24                	je     c010331b <basic_check+0x31d>
c01032f7:	c7 44 24 0c d3 69 10 	movl   $0xc01069d3,0xc(%esp)
c01032fe:	c0 
c01032ff:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c0103306:	c0 
c0103307:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
c010330e:	00 
c010330f:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c0103316:	e8 e7 d9 ff ff       	call   c0100d02 <__panic>

    assert((p0 = alloc_page()) != NULL);
c010331b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103322:	e8 e9 0b 00 00       	call   c0103f10 <alloc_pages>
c0103327:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010332a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c010332e:	75 24                	jne    c0103354 <basic_check+0x356>
c0103330:	c7 44 24 0c 99 68 10 	movl   $0xc0106899,0xc(%esp)
c0103337:	c0 
c0103338:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c010333f:	c0 
c0103340:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
c0103347:	00 
c0103348:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c010334f:	e8 ae d9 ff ff       	call   c0100d02 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0103354:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010335b:	e8 b0 0b 00 00       	call   c0103f10 <alloc_pages>
c0103360:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103363:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103367:	75 24                	jne    c010338d <basic_check+0x38f>
c0103369:	c7 44 24 0c b5 68 10 	movl   $0xc01068b5,0xc(%esp)
c0103370:	c0 
c0103371:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c0103378:	c0 
c0103379:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
c0103380:	00 
c0103381:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c0103388:	e8 75 d9 ff ff       	call   c0100d02 <__panic>
    assert((p2 = alloc_page()) != NULL);
c010338d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103394:	e8 77 0b 00 00       	call   c0103f10 <alloc_pages>
c0103399:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010339c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01033a0:	75 24                	jne    c01033c6 <basic_check+0x3c8>
c01033a2:	c7 44 24 0c d1 68 10 	movl   $0xc01068d1,0xc(%esp)
c01033a9:	c0 
c01033aa:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c01033b1:	c0 
c01033b2:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
c01033b9:	00 
c01033ba:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c01033c1:	e8 3c d9 ff ff       	call   c0100d02 <__panic>

    assert(alloc_page() == NULL);
c01033c6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01033cd:	e8 3e 0b 00 00       	call   c0103f10 <alloc_pages>
c01033d2:	85 c0                	test   %eax,%eax
c01033d4:	74 24                	je     c01033fa <basic_check+0x3fc>
c01033d6:	c7 44 24 0c be 69 10 	movl   $0xc01069be,0xc(%esp)
c01033dd:	c0 
c01033de:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c01033e5:	c0 
c01033e6:	c7 44 24 04 e6 00 00 	movl   $0xe6,0x4(%esp)
c01033ed:	00 
c01033ee:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c01033f5:	e8 08 d9 ff ff       	call   c0100d02 <__panic>

    free_page(p0);
c01033fa:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103401:	00 
c0103402:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103405:	89 04 24             	mov    %eax,(%esp)
c0103408:	e8 3d 0b 00 00       	call   c0103f4a <free_pages>
c010340d:	c7 45 d8 80 ce 11 c0 	movl   $0xc011ce80,-0x28(%ebp)
c0103414:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103417:	8b 40 04             	mov    0x4(%eax),%eax
c010341a:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c010341d:	0f 94 c0             	sete   %al
c0103420:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c0103423:	85 c0                	test   %eax,%eax
c0103425:	74 24                	je     c010344b <basic_check+0x44d>
c0103427:	c7 44 24 0c e0 69 10 	movl   $0xc01069e0,0xc(%esp)
c010342e:	c0 
c010342f:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c0103436:	c0 
c0103437:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
c010343e:	00 
c010343f:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c0103446:	e8 b7 d8 ff ff       	call   c0100d02 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c010344b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103452:	e8 b9 0a 00 00       	call   c0103f10 <alloc_pages>
c0103457:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010345a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010345d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103460:	74 24                	je     c0103486 <basic_check+0x488>
c0103462:	c7 44 24 0c f8 69 10 	movl   $0xc01069f8,0xc(%esp)
c0103469:	c0 
c010346a:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c0103471:	c0 
c0103472:	c7 44 24 04 ec 00 00 	movl   $0xec,0x4(%esp)
c0103479:	00 
c010347a:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c0103481:	e8 7c d8 ff ff       	call   c0100d02 <__panic>
    assert(alloc_page() == NULL);
c0103486:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010348d:	e8 7e 0a 00 00       	call   c0103f10 <alloc_pages>
c0103492:	85 c0                	test   %eax,%eax
c0103494:	74 24                	je     c01034ba <basic_check+0x4bc>
c0103496:	c7 44 24 0c be 69 10 	movl   $0xc01069be,0xc(%esp)
c010349d:	c0 
c010349e:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c01034a5:	c0 
c01034a6:	c7 44 24 04 ed 00 00 	movl   $0xed,0x4(%esp)
c01034ad:	00 
c01034ae:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c01034b5:	e8 48 d8 ff ff       	call   c0100d02 <__panic>

    assert(nr_free == 0);
c01034ba:	a1 88 ce 11 c0       	mov    0xc011ce88,%eax
c01034bf:	85 c0                	test   %eax,%eax
c01034c1:	74 24                	je     c01034e7 <basic_check+0x4e9>
c01034c3:	c7 44 24 0c 11 6a 10 	movl   $0xc0106a11,0xc(%esp)
c01034ca:	c0 
c01034cb:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c01034d2:	c0 
c01034d3:	c7 44 24 04 ef 00 00 	movl   $0xef,0x4(%esp)
c01034da:	00 
c01034db:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c01034e2:	e8 1b d8 ff ff       	call   c0100d02 <__panic>
    free_list = free_list_store;
c01034e7:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01034ea:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01034ed:	a3 80 ce 11 c0       	mov    %eax,0xc011ce80
c01034f2:	89 15 84 ce 11 c0    	mov    %edx,0xc011ce84
    nr_free = nr_free_store;
c01034f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01034fb:	a3 88 ce 11 c0       	mov    %eax,0xc011ce88

    free_page(p);
c0103500:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103507:	00 
c0103508:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010350b:	89 04 24             	mov    %eax,(%esp)
c010350e:	e8 37 0a 00 00       	call   c0103f4a <free_pages>
    free_page(p1);
c0103513:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010351a:	00 
c010351b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010351e:	89 04 24             	mov    %eax,(%esp)
c0103521:	e8 24 0a 00 00       	call   c0103f4a <free_pages>
    free_page(p2);
c0103526:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010352d:	00 
c010352e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103531:	89 04 24             	mov    %eax,(%esp)
c0103534:	e8 11 0a 00 00       	call   c0103f4a <free_pages>
}
c0103539:	90                   	nop
c010353a:	89 ec                	mov    %ebp,%esp
c010353c:	5d                   	pop    %ebp
c010353d:	c3                   	ret    

c010353e <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c010353e:	55                   	push   %ebp
c010353f:	89 e5                	mov    %esp,%ebp
c0103541:	81 ec 98 00 00 00    	sub    $0x98,%esp
    int count = 0, total = 0;
c0103547:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010354e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0103555:	c7 45 ec 80 ce 11 c0 	movl   $0xc011ce80,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c010355c:	eb 6a                	jmp    c01035c8 <default_check+0x8a>
        struct Page *p = le2page(le, page_link);
c010355e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103561:	83 e8 0c             	sub    $0xc,%eax
c0103564:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(PageProperty(p));
c0103567:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010356a:	83 c0 04             	add    $0x4,%eax
c010356d:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0103574:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103577:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010357a:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010357d:	0f a3 10             	bt     %edx,(%eax)
c0103580:	19 c0                	sbb    %eax,%eax
c0103582:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c0103585:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0103589:	0f 95 c0             	setne  %al
c010358c:	0f b6 c0             	movzbl %al,%eax
c010358f:	85 c0                	test   %eax,%eax
c0103591:	75 24                	jne    c01035b7 <default_check+0x79>
c0103593:	c7 44 24 0c 1e 6a 10 	movl   $0xc0106a1e,0xc(%esp)
c010359a:	c0 
c010359b:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c01035a2:	c0 
c01035a3:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
c01035aa:	00 
c01035ab:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c01035b2:	e8 4b d7 ff ff       	call   c0100d02 <__panic>
        count ++, total += p->property;
c01035b7:	ff 45 f4             	incl   -0xc(%ebp)
c01035ba:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01035bd:	8b 50 08             	mov    0x8(%eax),%edx
c01035c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01035c3:	01 d0                	add    %edx,%eax
c01035c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01035c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01035cb:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
c01035ce:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01035d1:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c01035d4:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01035d7:	81 7d ec 80 ce 11 c0 	cmpl   $0xc011ce80,-0x14(%ebp)
c01035de:	0f 85 7a ff ff ff    	jne    c010355e <default_check+0x20>
    }
    assert(total == nr_free_pages());
c01035e4:	e8 96 09 00 00       	call   c0103f7f <nr_free_pages>
c01035e9:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01035ec:	39 d0                	cmp    %edx,%eax
c01035ee:	74 24                	je     c0103614 <default_check+0xd6>
c01035f0:	c7 44 24 0c 2e 6a 10 	movl   $0xc0106a2e,0xc(%esp)
c01035f7:	c0 
c01035f8:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c01035ff:	c0 
c0103600:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
c0103607:	00 
c0103608:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c010360f:	e8 ee d6 ff ff       	call   c0100d02 <__panic>

    basic_check();
c0103614:	e8 e5 f9 ff ff       	call   c0102ffe <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0103619:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0103620:	e8 eb 08 00 00       	call   c0103f10 <alloc_pages>
c0103625:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(p0 != NULL);
c0103628:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010362c:	75 24                	jne    c0103652 <default_check+0x114>
c010362e:	c7 44 24 0c 47 6a 10 	movl   $0xc0106a47,0xc(%esp)
c0103635:	c0 
c0103636:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c010363d:	c0 
c010363e:	c7 44 24 04 08 01 00 	movl   $0x108,0x4(%esp)
c0103645:	00 
c0103646:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c010364d:	e8 b0 d6 ff ff       	call   c0100d02 <__panic>
    assert(!PageProperty(p0));
c0103652:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103655:	83 c0 04             	add    $0x4,%eax
c0103658:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c010365f:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103662:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103665:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0103668:	0f a3 10             	bt     %edx,(%eax)
c010366b:	19 c0                	sbb    %eax,%eax
c010366d:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c0103670:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0103674:	0f 95 c0             	setne  %al
c0103677:	0f b6 c0             	movzbl %al,%eax
c010367a:	85 c0                	test   %eax,%eax
c010367c:	74 24                	je     c01036a2 <default_check+0x164>
c010367e:	c7 44 24 0c 52 6a 10 	movl   $0xc0106a52,0xc(%esp)
c0103685:	c0 
c0103686:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c010368d:	c0 
c010368e:	c7 44 24 04 09 01 00 	movl   $0x109,0x4(%esp)
c0103695:	00 
c0103696:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c010369d:	e8 60 d6 ff ff       	call   c0100d02 <__panic>

    list_entry_t free_list_store = free_list;
c01036a2:	a1 80 ce 11 c0       	mov    0xc011ce80,%eax
c01036a7:	8b 15 84 ce 11 c0    	mov    0xc011ce84,%edx
c01036ad:	89 45 80             	mov    %eax,-0x80(%ebp)
c01036b0:	89 55 84             	mov    %edx,-0x7c(%ebp)
c01036b3:	c7 45 b0 80 ce 11 c0 	movl   $0xc011ce80,-0x50(%ebp)
    elm->prev = elm->next = elm;
c01036ba:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01036bd:	8b 55 b0             	mov    -0x50(%ebp),%edx
c01036c0:	89 50 04             	mov    %edx,0x4(%eax)
c01036c3:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01036c6:	8b 50 04             	mov    0x4(%eax),%edx
c01036c9:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01036cc:	89 10                	mov    %edx,(%eax)
}
c01036ce:	90                   	nop
c01036cf:	c7 45 b4 80 ce 11 c0 	movl   $0xc011ce80,-0x4c(%ebp)
    return list->next == list;
c01036d6:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01036d9:	8b 40 04             	mov    0x4(%eax),%eax
c01036dc:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
c01036df:	0f 94 c0             	sete   %al
c01036e2:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c01036e5:	85 c0                	test   %eax,%eax
c01036e7:	75 24                	jne    c010370d <default_check+0x1cf>
c01036e9:	c7 44 24 0c a7 69 10 	movl   $0xc01069a7,0xc(%esp)
c01036f0:	c0 
c01036f1:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c01036f8:	c0 
c01036f9:	c7 44 24 04 0d 01 00 	movl   $0x10d,0x4(%esp)
c0103700:	00 
c0103701:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c0103708:	e8 f5 d5 ff ff       	call   c0100d02 <__panic>
    assert(alloc_page() == NULL);
c010370d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103714:	e8 f7 07 00 00       	call   c0103f10 <alloc_pages>
c0103719:	85 c0                	test   %eax,%eax
c010371b:	74 24                	je     c0103741 <default_check+0x203>
c010371d:	c7 44 24 0c be 69 10 	movl   $0xc01069be,0xc(%esp)
c0103724:	c0 
c0103725:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c010372c:	c0 
c010372d:	c7 44 24 04 0e 01 00 	movl   $0x10e,0x4(%esp)
c0103734:	00 
c0103735:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c010373c:	e8 c1 d5 ff ff       	call   c0100d02 <__panic>

    unsigned int nr_free_store = nr_free;
c0103741:	a1 88 ce 11 c0       	mov    0xc011ce88,%eax
c0103746:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nr_free = 0;
c0103749:	c7 05 88 ce 11 c0 00 	movl   $0x0,0xc011ce88
c0103750:	00 00 00 

    free_pages(p0 + 2, 3);
c0103753:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103756:	83 c0 28             	add    $0x28,%eax
c0103759:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0103760:	00 
c0103761:	89 04 24             	mov    %eax,(%esp)
c0103764:	e8 e1 07 00 00       	call   c0103f4a <free_pages>
    assert(alloc_pages(4) == NULL);
c0103769:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0103770:	e8 9b 07 00 00       	call   c0103f10 <alloc_pages>
c0103775:	85 c0                	test   %eax,%eax
c0103777:	74 24                	je     c010379d <default_check+0x25f>
c0103779:	c7 44 24 0c 64 6a 10 	movl   $0xc0106a64,0xc(%esp)
c0103780:	c0 
c0103781:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c0103788:	c0 
c0103789:	c7 44 24 04 14 01 00 	movl   $0x114,0x4(%esp)
c0103790:	00 
c0103791:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c0103798:	e8 65 d5 ff ff       	call   c0100d02 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c010379d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01037a0:	83 c0 28             	add    $0x28,%eax
c01037a3:	83 c0 04             	add    $0x4,%eax
c01037a6:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c01037ad:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01037b0:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01037b3:	8b 55 ac             	mov    -0x54(%ebp),%edx
c01037b6:	0f a3 10             	bt     %edx,(%eax)
c01037b9:	19 c0                	sbb    %eax,%eax
c01037bb:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c01037be:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c01037c2:	0f 95 c0             	setne  %al
c01037c5:	0f b6 c0             	movzbl %al,%eax
c01037c8:	85 c0                	test   %eax,%eax
c01037ca:	74 0e                	je     c01037da <default_check+0x29c>
c01037cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01037cf:	83 c0 28             	add    $0x28,%eax
c01037d2:	8b 40 08             	mov    0x8(%eax),%eax
c01037d5:	83 f8 03             	cmp    $0x3,%eax
c01037d8:	74 24                	je     c01037fe <default_check+0x2c0>
c01037da:	c7 44 24 0c 7c 6a 10 	movl   $0xc0106a7c,0xc(%esp)
c01037e1:	c0 
c01037e2:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c01037e9:	c0 
c01037ea:	c7 44 24 04 15 01 00 	movl   $0x115,0x4(%esp)
c01037f1:	00 
c01037f2:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c01037f9:	e8 04 d5 ff ff       	call   c0100d02 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c01037fe:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c0103805:	e8 06 07 00 00       	call   c0103f10 <alloc_pages>
c010380a:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010380d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0103811:	75 24                	jne    c0103837 <default_check+0x2f9>
c0103813:	c7 44 24 0c a8 6a 10 	movl   $0xc0106aa8,0xc(%esp)
c010381a:	c0 
c010381b:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c0103822:	c0 
c0103823:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c010382a:	00 
c010382b:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c0103832:	e8 cb d4 ff ff       	call   c0100d02 <__panic>
    assert(alloc_page() == NULL);
c0103837:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010383e:	e8 cd 06 00 00       	call   c0103f10 <alloc_pages>
c0103843:	85 c0                	test   %eax,%eax
c0103845:	74 24                	je     c010386b <default_check+0x32d>
c0103847:	c7 44 24 0c be 69 10 	movl   $0xc01069be,0xc(%esp)
c010384e:	c0 
c010384f:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c0103856:	c0 
c0103857:	c7 44 24 04 17 01 00 	movl   $0x117,0x4(%esp)
c010385e:	00 
c010385f:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c0103866:	e8 97 d4 ff ff       	call   c0100d02 <__panic>
    assert(p0 + 2 == p1);
c010386b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010386e:	83 c0 28             	add    $0x28,%eax
c0103871:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0103874:	74 24                	je     c010389a <default_check+0x35c>
c0103876:	c7 44 24 0c c6 6a 10 	movl   $0xc0106ac6,0xc(%esp)
c010387d:	c0 
c010387e:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c0103885:	c0 
c0103886:	c7 44 24 04 18 01 00 	movl   $0x118,0x4(%esp)
c010388d:	00 
c010388e:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c0103895:	e8 68 d4 ff ff       	call   c0100d02 <__panic>

    p2 = p0 + 1;
c010389a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010389d:	83 c0 14             	add    $0x14,%eax
c01038a0:	89 45 dc             	mov    %eax,-0x24(%ebp)
    free_page(p0);
c01038a3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01038aa:	00 
c01038ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01038ae:	89 04 24             	mov    %eax,(%esp)
c01038b1:	e8 94 06 00 00       	call   c0103f4a <free_pages>
    free_pages(p1, 3);
c01038b6:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c01038bd:	00 
c01038be:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01038c1:	89 04 24             	mov    %eax,(%esp)
c01038c4:	e8 81 06 00 00       	call   c0103f4a <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c01038c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01038cc:	83 c0 04             	add    $0x4,%eax
c01038cf:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c01038d6:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01038d9:	8b 45 9c             	mov    -0x64(%ebp),%eax
c01038dc:	8b 55 a0             	mov    -0x60(%ebp),%edx
c01038df:	0f a3 10             	bt     %edx,(%eax)
c01038e2:	19 c0                	sbb    %eax,%eax
c01038e4:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c01038e7:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c01038eb:	0f 95 c0             	setne  %al
c01038ee:	0f b6 c0             	movzbl %al,%eax
c01038f1:	85 c0                	test   %eax,%eax
c01038f3:	74 0b                	je     c0103900 <default_check+0x3c2>
c01038f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01038f8:	8b 40 08             	mov    0x8(%eax),%eax
c01038fb:	83 f8 01             	cmp    $0x1,%eax
c01038fe:	74 24                	je     c0103924 <default_check+0x3e6>
c0103900:	c7 44 24 0c d4 6a 10 	movl   $0xc0106ad4,0xc(%esp)
c0103907:	c0 
c0103908:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c010390f:	c0 
c0103910:	c7 44 24 04 1d 01 00 	movl   $0x11d,0x4(%esp)
c0103917:	00 
c0103918:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c010391f:	e8 de d3 ff ff       	call   c0100d02 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c0103924:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103927:	83 c0 04             	add    $0x4,%eax
c010392a:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c0103931:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103934:	8b 45 90             	mov    -0x70(%ebp),%eax
c0103937:	8b 55 94             	mov    -0x6c(%ebp),%edx
c010393a:	0f a3 10             	bt     %edx,(%eax)
c010393d:	19 c0                	sbb    %eax,%eax
c010393f:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c0103942:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c0103946:	0f 95 c0             	setne  %al
c0103949:	0f b6 c0             	movzbl %al,%eax
c010394c:	85 c0                	test   %eax,%eax
c010394e:	74 0b                	je     c010395b <default_check+0x41d>
c0103950:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103953:	8b 40 08             	mov    0x8(%eax),%eax
c0103956:	83 f8 03             	cmp    $0x3,%eax
c0103959:	74 24                	je     c010397f <default_check+0x441>
c010395b:	c7 44 24 0c fc 6a 10 	movl   $0xc0106afc,0xc(%esp)
c0103962:	c0 
c0103963:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c010396a:	c0 
c010396b:	c7 44 24 04 1e 01 00 	movl   $0x11e,0x4(%esp)
c0103972:	00 
c0103973:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c010397a:	e8 83 d3 ff ff       	call   c0100d02 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c010397f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103986:	e8 85 05 00 00       	call   c0103f10 <alloc_pages>
c010398b:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010398e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103991:	83 e8 14             	sub    $0x14,%eax
c0103994:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0103997:	74 24                	je     c01039bd <default_check+0x47f>
c0103999:	c7 44 24 0c 22 6b 10 	movl   $0xc0106b22,0xc(%esp)
c01039a0:	c0 
c01039a1:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c01039a8:	c0 
c01039a9:	c7 44 24 04 20 01 00 	movl   $0x120,0x4(%esp)
c01039b0:	00 
c01039b1:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c01039b8:	e8 45 d3 ff ff       	call   c0100d02 <__panic>
    free_page(p0);
c01039bd:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01039c4:	00 
c01039c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01039c8:	89 04 24             	mov    %eax,(%esp)
c01039cb:	e8 7a 05 00 00       	call   c0103f4a <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c01039d0:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c01039d7:	e8 34 05 00 00       	call   c0103f10 <alloc_pages>
c01039dc:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01039df:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01039e2:	83 c0 14             	add    $0x14,%eax
c01039e5:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c01039e8:	74 24                	je     c0103a0e <default_check+0x4d0>
c01039ea:	c7 44 24 0c 40 6b 10 	movl   $0xc0106b40,0xc(%esp)
c01039f1:	c0 
c01039f2:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c01039f9:	c0 
c01039fa:	c7 44 24 04 22 01 00 	movl   $0x122,0x4(%esp)
c0103a01:	00 
c0103a02:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c0103a09:	e8 f4 d2 ff ff       	call   c0100d02 <__panic>

    free_pages(p0, 2);
c0103a0e:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c0103a15:	00 
c0103a16:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103a19:	89 04 24             	mov    %eax,(%esp)
c0103a1c:	e8 29 05 00 00       	call   c0103f4a <free_pages>
    free_page(p2);
c0103a21:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103a28:	00 
c0103a29:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103a2c:	89 04 24             	mov    %eax,(%esp)
c0103a2f:	e8 16 05 00 00       	call   c0103f4a <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c0103a34:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0103a3b:	e8 d0 04 00 00       	call   c0103f10 <alloc_pages>
c0103a40:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103a43:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0103a47:	75 24                	jne    c0103a6d <default_check+0x52f>
c0103a49:	c7 44 24 0c 60 6b 10 	movl   $0xc0106b60,0xc(%esp)
c0103a50:	c0 
c0103a51:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c0103a58:	c0 
c0103a59:	c7 44 24 04 27 01 00 	movl   $0x127,0x4(%esp)
c0103a60:	00 
c0103a61:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c0103a68:	e8 95 d2 ff ff       	call   c0100d02 <__panic>
    assert(alloc_page() == NULL);
c0103a6d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103a74:	e8 97 04 00 00       	call   c0103f10 <alloc_pages>
c0103a79:	85 c0                	test   %eax,%eax
c0103a7b:	74 24                	je     c0103aa1 <default_check+0x563>
c0103a7d:	c7 44 24 0c be 69 10 	movl   $0xc01069be,0xc(%esp)
c0103a84:	c0 
c0103a85:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c0103a8c:	c0 
c0103a8d:	c7 44 24 04 28 01 00 	movl   $0x128,0x4(%esp)
c0103a94:	00 
c0103a95:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c0103a9c:	e8 61 d2 ff ff       	call   c0100d02 <__panic>

    assert(nr_free == 0);
c0103aa1:	a1 88 ce 11 c0       	mov    0xc011ce88,%eax
c0103aa6:	85 c0                	test   %eax,%eax
c0103aa8:	74 24                	je     c0103ace <default_check+0x590>
c0103aaa:	c7 44 24 0c 11 6a 10 	movl   $0xc0106a11,0xc(%esp)
c0103ab1:	c0 
c0103ab2:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c0103ab9:	c0 
c0103aba:	c7 44 24 04 2a 01 00 	movl   $0x12a,0x4(%esp)
c0103ac1:	00 
c0103ac2:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c0103ac9:	e8 34 d2 ff ff       	call   c0100d02 <__panic>
    nr_free = nr_free_store;
c0103ace:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103ad1:	a3 88 ce 11 c0       	mov    %eax,0xc011ce88

    free_list = free_list_store;
c0103ad6:	8b 45 80             	mov    -0x80(%ebp),%eax
c0103ad9:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0103adc:	a3 80 ce 11 c0       	mov    %eax,0xc011ce80
c0103ae1:	89 15 84 ce 11 c0    	mov    %edx,0xc011ce84
    free_pages(p0, 5);
c0103ae7:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c0103aee:	00 
c0103aef:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103af2:	89 04 24             	mov    %eax,(%esp)
c0103af5:	e8 50 04 00 00       	call   c0103f4a <free_pages>

    le = &free_list;
c0103afa:	c7 45 ec 80 ce 11 c0 	movl   $0xc011ce80,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0103b01:	eb 5a                	jmp    c0103b5d <default_check+0x61f>
        assert(le->next->prev == le && le->prev->next == le);
c0103b03:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103b06:	8b 40 04             	mov    0x4(%eax),%eax
c0103b09:	8b 00                	mov    (%eax),%eax
c0103b0b:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0103b0e:	75 0d                	jne    c0103b1d <default_check+0x5df>
c0103b10:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103b13:	8b 00                	mov    (%eax),%eax
c0103b15:	8b 40 04             	mov    0x4(%eax),%eax
c0103b18:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0103b1b:	74 24                	je     c0103b41 <default_check+0x603>
c0103b1d:	c7 44 24 0c 80 6b 10 	movl   $0xc0106b80,0xc(%esp)
c0103b24:	c0 
c0103b25:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c0103b2c:	c0 
c0103b2d:	c7 44 24 04 32 01 00 	movl   $0x132,0x4(%esp)
c0103b34:	00 
c0103b35:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c0103b3c:	e8 c1 d1 ff ff       	call   c0100d02 <__panic>
        struct Page *p = le2page(le, page_link);
c0103b41:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103b44:	83 e8 0c             	sub    $0xc,%eax
c0103b47:	89 45 d8             	mov    %eax,-0x28(%ebp)
        count --, total -= p->property;
c0103b4a:	ff 4d f4             	decl   -0xc(%ebp)
c0103b4d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0103b50:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103b53:	8b 48 08             	mov    0x8(%eax),%ecx
c0103b56:	89 d0                	mov    %edx,%eax
c0103b58:	29 c8                	sub    %ecx,%eax
c0103b5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103b5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103b60:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
c0103b63:	8b 45 88             	mov    -0x78(%ebp),%eax
c0103b66:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c0103b69:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103b6c:	81 7d ec 80 ce 11 c0 	cmpl   $0xc011ce80,-0x14(%ebp)
c0103b73:	75 8e                	jne    c0103b03 <default_check+0x5c5>
    }
    assert(count == 0);
c0103b75:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103b79:	74 24                	je     c0103b9f <default_check+0x661>
c0103b7b:	c7 44 24 0c ad 6b 10 	movl   $0xc0106bad,0xc(%esp)
c0103b82:	c0 
c0103b83:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c0103b8a:	c0 
c0103b8b:	c7 44 24 04 36 01 00 	movl   $0x136,0x4(%esp)
c0103b92:	00 
c0103b93:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c0103b9a:	e8 63 d1 ff ff       	call   c0100d02 <__panic>
    assert(total == 0);
c0103b9f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103ba3:	74 24                	je     c0103bc9 <default_check+0x68b>
c0103ba5:	c7 44 24 0c b8 6b 10 	movl   $0xc0106bb8,0xc(%esp)
c0103bac:	c0 
c0103bad:	c7 44 24 08 36 68 10 	movl   $0xc0106836,0x8(%esp)
c0103bb4:	c0 
c0103bb5:	c7 44 24 04 37 01 00 	movl   $0x137,0x4(%esp)
c0103bbc:	00 
c0103bbd:	c7 04 24 4b 68 10 c0 	movl   $0xc010684b,(%esp)
c0103bc4:	e8 39 d1 ff ff       	call   c0100d02 <__panic>
}
c0103bc9:	90                   	nop
c0103bca:	89 ec                	mov    %ebp,%esp
c0103bcc:	5d                   	pop    %ebp
c0103bcd:	c3                   	ret    

c0103bce <page2ppn>:
page2ppn(struct Page *page) {
c0103bce:	55                   	push   %ebp
c0103bcf:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0103bd1:	8b 15 a0 ce 11 c0    	mov    0xc011cea0,%edx
c0103bd7:	8b 45 08             	mov    0x8(%ebp),%eax
c0103bda:	29 d0                	sub    %edx,%eax
c0103bdc:	c1 f8 02             	sar    $0x2,%eax
c0103bdf:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0103be5:	5d                   	pop    %ebp
c0103be6:	c3                   	ret    

c0103be7 <page2pa>:
page2pa(struct Page *page) {
c0103be7:	55                   	push   %ebp
c0103be8:	89 e5                	mov    %esp,%ebp
c0103bea:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0103bed:	8b 45 08             	mov    0x8(%ebp),%eax
c0103bf0:	89 04 24             	mov    %eax,(%esp)
c0103bf3:	e8 d6 ff ff ff       	call   c0103bce <page2ppn>
c0103bf8:	c1 e0 0c             	shl    $0xc,%eax
}
c0103bfb:	89 ec                	mov    %ebp,%esp
c0103bfd:	5d                   	pop    %ebp
c0103bfe:	c3                   	ret    

c0103bff <pa2page>:
pa2page(uintptr_t pa) {
c0103bff:	55                   	push   %ebp
c0103c00:	89 e5                	mov    %esp,%ebp
c0103c02:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0103c05:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c08:	c1 e8 0c             	shr    $0xc,%eax
c0103c0b:	89 c2                	mov    %eax,%edx
c0103c0d:	a1 a4 ce 11 c0       	mov    0xc011cea4,%eax
c0103c12:	39 c2                	cmp    %eax,%edx
c0103c14:	72 1c                	jb     c0103c32 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0103c16:	c7 44 24 08 f4 6b 10 	movl   $0xc0106bf4,0x8(%esp)
c0103c1d:	c0 
c0103c1e:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c0103c25:	00 
c0103c26:	c7 04 24 13 6c 10 c0 	movl   $0xc0106c13,(%esp)
c0103c2d:	e8 d0 d0 ff ff       	call   c0100d02 <__panic>
    return &pages[PPN(pa)];
c0103c32:	8b 0d a0 ce 11 c0    	mov    0xc011cea0,%ecx
c0103c38:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c3b:	c1 e8 0c             	shr    $0xc,%eax
c0103c3e:	89 c2                	mov    %eax,%edx
c0103c40:	89 d0                	mov    %edx,%eax
c0103c42:	c1 e0 02             	shl    $0x2,%eax
c0103c45:	01 d0                	add    %edx,%eax
c0103c47:	c1 e0 02             	shl    $0x2,%eax
c0103c4a:	01 c8                	add    %ecx,%eax
}
c0103c4c:	89 ec                	mov    %ebp,%esp
c0103c4e:	5d                   	pop    %ebp
c0103c4f:	c3                   	ret    

c0103c50 <page2kva>:
page2kva(struct Page *page) {
c0103c50:	55                   	push   %ebp
c0103c51:	89 e5                	mov    %esp,%ebp
c0103c53:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0103c56:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c59:	89 04 24             	mov    %eax,(%esp)
c0103c5c:	e8 86 ff ff ff       	call   c0103be7 <page2pa>
c0103c61:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103c64:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103c67:	c1 e8 0c             	shr    $0xc,%eax
c0103c6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103c6d:	a1 a4 ce 11 c0       	mov    0xc011cea4,%eax
c0103c72:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0103c75:	72 23                	jb     c0103c9a <page2kva+0x4a>
c0103c77:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103c7a:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103c7e:	c7 44 24 08 24 6c 10 	movl   $0xc0106c24,0x8(%esp)
c0103c85:	c0 
c0103c86:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c0103c8d:	00 
c0103c8e:	c7 04 24 13 6c 10 c0 	movl   $0xc0106c13,(%esp)
c0103c95:	e8 68 d0 ff ff       	call   c0100d02 <__panic>
c0103c9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103c9d:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0103ca2:	89 ec                	mov    %ebp,%esp
c0103ca4:	5d                   	pop    %ebp
c0103ca5:	c3                   	ret    

c0103ca6 <pte2page>:
pte2page(pte_t pte) {
c0103ca6:	55                   	push   %ebp
c0103ca7:	89 e5                	mov    %esp,%ebp
c0103ca9:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0103cac:	8b 45 08             	mov    0x8(%ebp),%eax
c0103caf:	83 e0 01             	and    $0x1,%eax
c0103cb2:	85 c0                	test   %eax,%eax
c0103cb4:	75 1c                	jne    c0103cd2 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0103cb6:	c7 44 24 08 48 6c 10 	movl   $0xc0106c48,0x8(%esp)
c0103cbd:	c0 
c0103cbe:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c0103cc5:	00 
c0103cc6:	c7 04 24 13 6c 10 c0 	movl   $0xc0106c13,(%esp)
c0103ccd:	e8 30 d0 ff ff       	call   c0100d02 <__panic>
    return pa2page(PTE_ADDR(pte));
c0103cd2:	8b 45 08             	mov    0x8(%ebp),%eax
c0103cd5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103cda:	89 04 24             	mov    %eax,(%esp)
c0103cdd:	e8 1d ff ff ff       	call   c0103bff <pa2page>
}
c0103ce2:	89 ec                	mov    %ebp,%esp
c0103ce4:	5d                   	pop    %ebp
c0103ce5:	c3                   	ret    

c0103ce6 <pde2page>:
pde2page(pde_t pde) {
c0103ce6:	55                   	push   %ebp
c0103ce7:	89 e5                	mov    %esp,%ebp
c0103ce9:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c0103cec:	8b 45 08             	mov    0x8(%ebp),%eax
c0103cef:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103cf4:	89 04 24             	mov    %eax,(%esp)
c0103cf7:	e8 03 ff ff ff       	call   c0103bff <pa2page>
}
c0103cfc:	89 ec                	mov    %ebp,%esp
c0103cfe:	5d                   	pop    %ebp
c0103cff:	c3                   	ret    

c0103d00 <page_ref>:
page_ref(struct Page *page) {
c0103d00:	55                   	push   %ebp
c0103d01:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0103d03:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d06:	8b 00                	mov    (%eax),%eax
}
c0103d08:	5d                   	pop    %ebp
c0103d09:	c3                   	ret    

c0103d0a <set_page_ref>:
set_page_ref(struct Page *page, int val) {
c0103d0a:	55                   	push   %ebp
c0103d0b:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0103d0d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d10:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103d13:	89 10                	mov    %edx,(%eax)
}
c0103d15:	90                   	nop
c0103d16:	5d                   	pop    %ebp
c0103d17:	c3                   	ret    

c0103d18 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0103d18:	55                   	push   %ebp
c0103d19:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0103d1b:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d1e:	8b 00                	mov    (%eax),%eax
c0103d20:	8d 50 01             	lea    0x1(%eax),%edx
c0103d23:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d26:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103d28:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d2b:	8b 00                	mov    (%eax),%eax
}
c0103d2d:	5d                   	pop    %ebp
c0103d2e:	c3                   	ret    

c0103d2f <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0103d2f:	55                   	push   %ebp
c0103d30:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0103d32:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d35:	8b 00                	mov    (%eax),%eax
c0103d37:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103d3a:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d3d:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103d3f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d42:	8b 00                	mov    (%eax),%eax
}
c0103d44:	5d                   	pop    %ebp
c0103d45:	c3                   	ret    

c0103d46 <__intr_save>:
__intr_save(void) {
c0103d46:	55                   	push   %ebp
c0103d47:	89 e5                	mov    %esp,%ebp
c0103d49:	83 ec 18             	sub    $0x18,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0103d4c:	9c                   	pushf  
c0103d4d:	58                   	pop    %eax
c0103d4e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0103d51:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0103d54:	25 00 02 00 00       	and    $0x200,%eax
c0103d59:	85 c0                	test   %eax,%eax
c0103d5b:	74 0c                	je     c0103d69 <__intr_save+0x23>
        intr_disable();
c0103d5d:	e8 f9 d9 ff ff       	call   c010175b <intr_disable>
        return 1;
c0103d62:	b8 01 00 00 00       	mov    $0x1,%eax
c0103d67:	eb 05                	jmp    c0103d6e <__intr_save+0x28>
    return 0;
c0103d69:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103d6e:	89 ec                	mov    %ebp,%esp
c0103d70:	5d                   	pop    %ebp
c0103d71:	c3                   	ret    

c0103d72 <__intr_restore>:
__intr_restore(bool flag) {
c0103d72:	55                   	push   %ebp
c0103d73:	89 e5                	mov    %esp,%ebp
c0103d75:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0103d78:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0103d7c:	74 05                	je     c0103d83 <__intr_restore+0x11>
        intr_enable();
c0103d7e:	e8 d0 d9 ff ff       	call   c0101753 <intr_enable>
}
c0103d83:	90                   	nop
c0103d84:	89 ec                	mov    %ebp,%esp
c0103d86:	5d                   	pop    %ebp
c0103d87:	c3                   	ret    

c0103d88 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0103d88:	55                   	push   %ebp
c0103d89:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0103d8b:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d8e:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0103d91:	b8 23 00 00 00       	mov    $0x23,%eax
c0103d96:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0103d98:	b8 23 00 00 00       	mov    $0x23,%eax
c0103d9d:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0103d9f:	b8 10 00 00 00       	mov    $0x10,%eax
c0103da4:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0103da6:	b8 10 00 00 00       	mov    $0x10,%eax
c0103dab:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0103dad:	b8 10 00 00 00       	mov    $0x10,%eax
c0103db2:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0103db4:	ea bb 3d 10 c0 08 00 	ljmp   $0x8,$0xc0103dbb
}
c0103dbb:	90                   	nop
c0103dbc:	5d                   	pop    %ebp
c0103dbd:	c3                   	ret    

c0103dbe <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0103dbe:	55                   	push   %ebp
c0103dbf:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0103dc1:	8b 45 08             	mov    0x8(%ebp),%eax
c0103dc4:	a3 c4 ce 11 c0       	mov    %eax,0xc011cec4
}
c0103dc9:	90                   	nop
c0103dca:	5d                   	pop    %ebp
c0103dcb:	c3                   	ret    

c0103dcc <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0103dcc:	55                   	push   %ebp
c0103dcd:	89 e5                	mov    %esp,%ebp
c0103dcf:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0103dd2:	b8 00 90 11 c0       	mov    $0xc0119000,%eax
c0103dd7:	89 04 24             	mov    %eax,(%esp)
c0103dda:	e8 df ff ff ff       	call   c0103dbe <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0103ddf:	66 c7 05 c8 ce 11 c0 	movw   $0x10,0xc011cec8
c0103de6:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0103de8:	66 c7 05 28 9a 11 c0 	movw   $0x68,0xc0119a28
c0103def:	68 00 
c0103df1:	b8 c0 ce 11 c0       	mov    $0xc011cec0,%eax
c0103df6:	0f b7 c0             	movzwl %ax,%eax
c0103df9:	66 a3 2a 9a 11 c0    	mov    %ax,0xc0119a2a
c0103dff:	b8 c0 ce 11 c0       	mov    $0xc011cec0,%eax
c0103e04:	c1 e8 10             	shr    $0x10,%eax
c0103e07:	a2 2c 9a 11 c0       	mov    %al,0xc0119a2c
c0103e0c:	0f b6 05 2d 9a 11 c0 	movzbl 0xc0119a2d,%eax
c0103e13:	24 f0                	and    $0xf0,%al
c0103e15:	0c 09                	or     $0x9,%al
c0103e17:	a2 2d 9a 11 c0       	mov    %al,0xc0119a2d
c0103e1c:	0f b6 05 2d 9a 11 c0 	movzbl 0xc0119a2d,%eax
c0103e23:	24 ef                	and    $0xef,%al
c0103e25:	a2 2d 9a 11 c0       	mov    %al,0xc0119a2d
c0103e2a:	0f b6 05 2d 9a 11 c0 	movzbl 0xc0119a2d,%eax
c0103e31:	24 9f                	and    $0x9f,%al
c0103e33:	a2 2d 9a 11 c0       	mov    %al,0xc0119a2d
c0103e38:	0f b6 05 2d 9a 11 c0 	movzbl 0xc0119a2d,%eax
c0103e3f:	0c 80                	or     $0x80,%al
c0103e41:	a2 2d 9a 11 c0       	mov    %al,0xc0119a2d
c0103e46:	0f b6 05 2e 9a 11 c0 	movzbl 0xc0119a2e,%eax
c0103e4d:	24 f0                	and    $0xf0,%al
c0103e4f:	a2 2e 9a 11 c0       	mov    %al,0xc0119a2e
c0103e54:	0f b6 05 2e 9a 11 c0 	movzbl 0xc0119a2e,%eax
c0103e5b:	24 ef                	and    $0xef,%al
c0103e5d:	a2 2e 9a 11 c0       	mov    %al,0xc0119a2e
c0103e62:	0f b6 05 2e 9a 11 c0 	movzbl 0xc0119a2e,%eax
c0103e69:	24 df                	and    $0xdf,%al
c0103e6b:	a2 2e 9a 11 c0       	mov    %al,0xc0119a2e
c0103e70:	0f b6 05 2e 9a 11 c0 	movzbl 0xc0119a2e,%eax
c0103e77:	0c 40                	or     $0x40,%al
c0103e79:	a2 2e 9a 11 c0       	mov    %al,0xc0119a2e
c0103e7e:	0f b6 05 2e 9a 11 c0 	movzbl 0xc0119a2e,%eax
c0103e85:	24 7f                	and    $0x7f,%al
c0103e87:	a2 2e 9a 11 c0       	mov    %al,0xc0119a2e
c0103e8c:	b8 c0 ce 11 c0       	mov    $0xc011cec0,%eax
c0103e91:	c1 e8 18             	shr    $0x18,%eax
c0103e94:	a2 2f 9a 11 c0       	mov    %al,0xc0119a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0103e99:	c7 04 24 30 9a 11 c0 	movl   $0xc0119a30,(%esp)
c0103ea0:	e8 e3 fe ff ff       	call   c0103d88 <lgdt>
c0103ea5:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0103eab:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0103eaf:	0f 00 d8             	ltr    %ax
}
c0103eb2:	90                   	nop

    // load the TSS
    ltr(GD_TSS);
}
c0103eb3:	90                   	nop
c0103eb4:	89 ec                	mov    %ebp,%esp
c0103eb6:	5d                   	pop    %ebp
c0103eb7:	c3                   	ret    

c0103eb8 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0103eb8:	55                   	push   %ebp
c0103eb9:	89 e5                	mov    %esp,%ebp
c0103ebb:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0103ebe:	c7 05 ac ce 11 c0 d8 	movl   $0xc0106bd8,0xc011ceac
c0103ec5:	6b 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0103ec8:	a1 ac ce 11 c0       	mov    0xc011ceac,%eax
c0103ecd:	8b 00                	mov    (%eax),%eax
c0103ecf:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103ed3:	c7 04 24 74 6c 10 c0 	movl   $0xc0106c74,(%esp)
c0103eda:	e8 82 c4 ff ff       	call   c0100361 <cprintf>
    pmm_manager->init();
c0103edf:	a1 ac ce 11 c0       	mov    0xc011ceac,%eax
c0103ee4:	8b 40 04             	mov    0x4(%eax),%eax
c0103ee7:	ff d0                	call   *%eax
}
c0103ee9:	90                   	nop
c0103eea:	89 ec                	mov    %ebp,%esp
c0103eec:	5d                   	pop    %ebp
c0103eed:	c3                   	ret    

c0103eee <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0103eee:	55                   	push   %ebp
c0103eef:	89 e5                	mov    %esp,%ebp
c0103ef1:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0103ef4:	a1 ac ce 11 c0       	mov    0xc011ceac,%eax
c0103ef9:	8b 40 08             	mov    0x8(%eax),%eax
c0103efc:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103eff:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103f03:	8b 55 08             	mov    0x8(%ebp),%edx
c0103f06:	89 14 24             	mov    %edx,(%esp)
c0103f09:	ff d0                	call   *%eax
}
c0103f0b:	90                   	nop
c0103f0c:	89 ec                	mov    %ebp,%esp
c0103f0e:	5d                   	pop    %ebp
c0103f0f:	c3                   	ret    

c0103f10 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0103f10:	55                   	push   %ebp
c0103f11:	89 e5                	mov    %esp,%ebp
c0103f13:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0103f16:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0103f1d:	e8 24 fe ff ff       	call   c0103d46 <__intr_save>
c0103f22:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0103f25:	a1 ac ce 11 c0       	mov    0xc011ceac,%eax
c0103f2a:	8b 40 0c             	mov    0xc(%eax),%eax
c0103f2d:	8b 55 08             	mov    0x8(%ebp),%edx
c0103f30:	89 14 24             	mov    %edx,(%esp)
c0103f33:	ff d0                	call   *%eax
c0103f35:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0103f38:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103f3b:	89 04 24             	mov    %eax,(%esp)
c0103f3e:	e8 2f fe ff ff       	call   c0103d72 <__intr_restore>
    return page;
c0103f43:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0103f46:	89 ec                	mov    %ebp,%esp
c0103f48:	5d                   	pop    %ebp
c0103f49:	c3                   	ret    

c0103f4a <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0103f4a:	55                   	push   %ebp
c0103f4b:	89 e5                	mov    %esp,%ebp
c0103f4d:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0103f50:	e8 f1 fd ff ff       	call   c0103d46 <__intr_save>
c0103f55:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0103f58:	a1 ac ce 11 c0       	mov    0xc011ceac,%eax
c0103f5d:	8b 40 10             	mov    0x10(%eax),%eax
c0103f60:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103f63:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103f67:	8b 55 08             	mov    0x8(%ebp),%edx
c0103f6a:	89 14 24             	mov    %edx,(%esp)
c0103f6d:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c0103f6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103f72:	89 04 24             	mov    %eax,(%esp)
c0103f75:	e8 f8 fd ff ff       	call   c0103d72 <__intr_restore>
}
c0103f7a:	90                   	nop
c0103f7b:	89 ec                	mov    %ebp,%esp
c0103f7d:	5d                   	pop    %ebp
c0103f7e:	c3                   	ret    

c0103f7f <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0103f7f:	55                   	push   %ebp
c0103f80:	89 e5                	mov    %esp,%ebp
c0103f82:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0103f85:	e8 bc fd ff ff       	call   c0103d46 <__intr_save>
c0103f8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0103f8d:	a1 ac ce 11 c0       	mov    0xc011ceac,%eax
c0103f92:	8b 40 14             	mov    0x14(%eax),%eax
c0103f95:	ff d0                	call   *%eax
c0103f97:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0103f9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103f9d:	89 04 24             	mov    %eax,(%esp)
c0103fa0:	e8 cd fd ff ff       	call   c0103d72 <__intr_restore>
    return ret;
c0103fa5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0103fa8:	89 ec                	mov    %ebp,%esp
c0103faa:	5d                   	pop    %ebp
c0103fab:	c3                   	ret    

c0103fac <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0103fac:	55                   	push   %ebp
c0103fad:	89 e5                	mov    %esp,%ebp
c0103faf:	57                   	push   %edi
c0103fb0:	56                   	push   %esi
c0103fb1:	53                   	push   %ebx
c0103fb2:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0103fb8:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0103fbf:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0103fc6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0103fcd:	c7 04 24 8b 6c 10 c0 	movl   $0xc0106c8b,(%esp)
c0103fd4:	e8 88 c3 ff ff       	call   c0100361 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0103fd9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103fe0:	e9 0c 01 00 00       	jmp    c01040f1 <page_init+0x145>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0103fe5:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103fe8:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103feb:	89 d0                	mov    %edx,%eax
c0103fed:	c1 e0 02             	shl    $0x2,%eax
c0103ff0:	01 d0                	add    %edx,%eax
c0103ff2:	c1 e0 02             	shl    $0x2,%eax
c0103ff5:	01 c8                	add    %ecx,%eax
c0103ff7:	8b 50 08             	mov    0x8(%eax),%edx
c0103ffa:	8b 40 04             	mov    0x4(%eax),%eax
c0103ffd:	89 45 a0             	mov    %eax,-0x60(%ebp)
c0104000:	89 55 a4             	mov    %edx,-0x5c(%ebp)
c0104003:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104006:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104009:	89 d0                	mov    %edx,%eax
c010400b:	c1 e0 02             	shl    $0x2,%eax
c010400e:	01 d0                	add    %edx,%eax
c0104010:	c1 e0 02             	shl    $0x2,%eax
c0104013:	01 c8                	add    %ecx,%eax
c0104015:	8b 48 0c             	mov    0xc(%eax),%ecx
c0104018:	8b 58 10             	mov    0x10(%eax),%ebx
c010401b:	8b 45 a0             	mov    -0x60(%ebp),%eax
c010401e:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0104021:	01 c8                	add    %ecx,%eax
c0104023:	11 da                	adc    %ebx,%edx
c0104025:	89 45 98             	mov    %eax,-0x68(%ebp)
c0104028:	89 55 9c             	mov    %edx,-0x64(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c010402b:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010402e:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104031:	89 d0                	mov    %edx,%eax
c0104033:	c1 e0 02             	shl    $0x2,%eax
c0104036:	01 d0                	add    %edx,%eax
c0104038:	c1 e0 02             	shl    $0x2,%eax
c010403b:	01 c8                	add    %ecx,%eax
c010403d:	83 c0 14             	add    $0x14,%eax
c0104040:	8b 00                	mov    (%eax),%eax
c0104042:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c0104048:	8b 45 98             	mov    -0x68(%ebp),%eax
c010404b:	8b 55 9c             	mov    -0x64(%ebp),%edx
c010404e:	83 c0 ff             	add    $0xffffffff,%eax
c0104051:	83 d2 ff             	adc    $0xffffffff,%edx
c0104054:	89 c6                	mov    %eax,%esi
c0104056:	89 d7                	mov    %edx,%edi
c0104058:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010405b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010405e:	89 d0                	mov    %edx,%eax
c0104060:	c1 e0 02             	shl    $0x2,%eax
c0104063:	01 d0                	add    %edx,%eax
c0104065:	c1 e0 02             	shl    $0x2,%eax
c0104068:	01 c8                	add    %ecx,%eax
c010406a:	8b 48 0c             	mov    0xc(%eax),%ecx
c010406d:	8b 58 10             	mov    0x10(%eax),%ebx
c0104070:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0104076:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c010407a:	89 74 24 14          	mov    %esi,0x14(%esp)
c010407e:	89 7c 24 18          	mov    %edi,0x18(%esp)
c0104082:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0104085:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0104088:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010408c:	89 54 24 10          	mov    %edx,0x10(%esp)
c0104090:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0104094:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0104098:	c7 04 24 98 6c 10 c0 	movl   $0xc0106c98,(%esp)
c010409f:	e8 bd c2 ff ff       	call   c0100361 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c01040a4:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01040a7:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01040aa:	89 d0                	mov    %edx,%eax
c01040ac:	c1 e0 02             	shl    $0x2,%eax
c01040af:	01 d0                	add    %edx,%eax
c01040b1:	c1 e0 02             	shl    $0x2,%eax
c01040b4:	01 c8                	add    %ecx,%eax
c01040b6:	83 c0 14             	add    $0x14,%eax
c01040b9:	8b 00                	mov    (%eax),%eax
c01040bb:	83 f8 01             	cmp    $0x1,%eax
c01040be:	75 2e                	jne    c01040ee <page_init+0x142>
            if (maxpa < end && begin < KMEMSIZE) {
c01040c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01040c3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01040c6:	3b 45 98             	cmp    -0x68(%ebp),%eax
c01040c9:	89 d0                	mov    %edx,%eax
c01040cb:	1b 45 9c             	sbb    -0x64(%ebp),%eax
c01040ce:	73 1e                	jae    c01040ee <page_init+0x142>
c01040d0:	ba ff ff ff 37       	mov    $0x37ffffff,%edx
c01040d5:	b8 00 00 00 00       	mov    $0x0,%eax
c01040da:	3b 55 a0             	cmp    -0x60(%ebp),%edx
c01040dd:	1b 45 a4             	sbb    -0x5c(%ebp),%eax
c01040e0:	72 0c                	jb     c01040ee <page_init+0x142>
                maxpa = end;
c01040e2:	8b 45 98             	mov    -0x68(%ebp),%eax
c01040e5:	8b 55 9c             	mov    -0x64(%ebp),%edx
c01040e8:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01040eb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i ++) {
c01040ee:	ff 45 dc             	incl   -0x24(%ebp)
c01040f1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01040f4:	8b 00                	mov    (%eax),%eax
c01040f6:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c01040f9:	0f 8c e6 fe ff ff    	jl     c0103fe5 <page_init+0x39>
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c01040ff:	ba 00 00 00 38       	mov    $0x38000000,%edx
c0104104:	b8 00 00 00 00       	mov    $0x0,%eax
c0104109:	3b 55 e0             	cmp    -0x20(%ebp),%edx
c010410c:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
c010410f:	73 0e                	jae    c010411f <page_init+0x173>
        maxpa = KMEMSIZE;
c0104111:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0104118:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c010411f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104122:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104125:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0104129:	c1 ea 0c             	shr    $0xc,%edx
c010412c:	a3 a4 ce 11 c0       	mov    %eax,0xc011cea4
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0104131:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
c0104138:	b8 2c cf 11 c0       	mov    $0xc011cf2c,%eax
c010413d:	8d 50 ff             	lea    -0x1(%eax),%edx
c0104140:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0104143:	01 d0                	add    %edx,%eax
c0104145:	89 45 bc             	mov    %eax,-0x44(%ebp)
c0104148:	8b 45 bc             	mov    -0x44(%ebp),%eax
c010414b:	ba 00 00 00 00       	mov    $0x0,%edx
c0104150:	f7 75 c0             	divl   -0x40(%ebp)
c0104153:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0104156:	29 d0                	sub    %edx,%eax
c0104158:	a3 a0 ce 11 c0       	mov    %eax,0xc011cea0

    for (i = 0; i < npage; i ++) {
c010415d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0104164:	eb 2f                	jmp    c0104195 <page_init+0x1e9>
        SetPageReserved(pages + i);
c0104166:	8b 0d a0 ce 11 c0    	mov    0xc011cea0,%ecx
c010416c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010416f:	89 d0                	mov    %edx,%eax
c0104171:	c1 e0 02             	shl    $0x2,%eax
c0104174:	01 d0                	add    %edx,%eax
c0104176:	c1 e0 02             	shl    $0x2,%eax
c0104179:	01 c8                	add    %ecx,%eax
c010417b:	83 c0 04             	add    $0x4,%eax
c010417e:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
c0104185:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104188:	8b 45 90             	mov    -0x70(%ebp),%eax
c010418b:	8b 55 94             	mov    -0x6c(%ebp),%edx
c010418e:	0f ab 10             	bts    %edx,(%eax)
}
c0104191:	90                   	nop
    for (i = 0; i < npage; i ++) {
c0104192:	ff 45 dc             	incl   -0x24(%ebp)
c0104195:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104198:	a1 a4 ce 11 c0       	mov    0xc011cea4,%eax
c010419d:	39 c2                	cmp    %eax,%edx
c010419f:	72 c5                	jb     c0104166 <page_init+0x1ba>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c01041a1:	8b 15 a4 ce 11 c0    	mov    0xc011cea4,%edx
c01041a7:	89 d0                	mov    %edx,%eax
c01041a9:	c1 e0 02             	shl    $0x2,%eax
c01041ac:	01 d0                	add    %edx,%eax
c01041ae:	c1 e0 02             	shl    $0x2,%eax
c01041b1:	89 c2                	mov    %eax,%edx
c01041b3:	a1 a0 ce 11 c0       	mov    0xc011cea0,%eax
c01041b8:	01 d0                	add    %edx,%eax
c01041ba:	89 45 b8             	mov    %eax,-0x48(%ebp)
c01041bd:	81 7d b8 ff ff ff bf 	cmpl   $0xbfffffff,-0x48(%ebp)
c01041c4:	77 23                	ja     c01041e9 <page_init+0x23d>
c01041c6:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01041c9:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01041cd:	c7 44 24 08 c8 6c 10 	movl   $0xc0106cc8,0x8(%esp)
c01041d4:	c0 
c01041d5:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
c01041dc:	00 
c01041dd:	c7 04 24 ec 6c 10 c0 	movl   $0xc0106cec,(%esp)
c01041e4:	e8 19 cb ff ff       	call   c0100d02 <__panic>
c01041e9:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01041ec:	05 00 00 00 40       	add    $0x40000000,%eax
c01041f1:	89 45 b4             	mov    %eax,-0x4c(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c01041f4:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01041fb:	e9 53 01 00 00       	jmp    c0104353 <page_init+0x3a7>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0104200:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104203:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104206:	89 d0                	mov    %edx,%eax
c0104208:	c1 e0 02             	shl    $0x2,%eax
c010420b:	01 d0                	add    %edx,%eax
c010420d:	c1 e0 02             	shl    $0x2,%eax
c0104210:	01 c8                	add    %ecx,%eax
c0104212:	8b 50 08             	mov    0x8(%eax),%edx
c0104215:	8b 40 04             	mov    0x4(%eax),%eax
c0104218:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010421b:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010421e:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104221:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104224:	89 d0                	mov    %edx,%eax
c0104226:	c1 e0 02             	shl    $0x2,%eax
c0104229:	01 d0                	add    %edx,%eax
c010422b:	c1 e0 02             	shl    $0x2,%eax
c010422e:	01 c8                	add    %ecx,%eax
c0104230:	8b 48 0c             	mov    0xc(%eax),%ecx
c0104233:	8b 58 10             	mov    0x10(%eax),%ebx
c0104236:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104239:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010423c:	01 c8                	add    %ecx,%eax
c010423e:	11 da                	adc    %ebx,%edx
c0104240:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0104243:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c0104246:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104249:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010424c:	89 d0                	mov    %edx,%eax
c010424e:	c1 e0 02             	shl    $0x2,%eax
c0104251:	01 d0                	add    %edx,%eax
c0104253:	c1 e0 02             	shl    $0x2,%eax
c0104256:	01 c8                	add    %ecx,%eax
c0104258:	83 c0 14             	add    $0x14,%eax
c010425b:	8b 00                	mov    (%eax),%eax
c010425d:	83 f8 01             	cmp    $0x1,%eax
c0104260:	0f 85 ea 00 00 00    	jne    c0104350 <page_init+0x3a4>
            if (begin < freemem) {
c0104266:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104269:	ba 00 00 00 00       	mov    $0x0,%edx
c010426e:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0104271:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c0104274:	19 d1                	sbb    %edx,%ecx
c0104276:	73 0d                	jae    c0104285 <page_init+0x2d9>
                begin = freemem;
c0104278:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010427b:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010427e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c0104285:	ba 00 00 00 38       	mov    $0x38000000,%edx
c010428a:	b8 00 00 00 00       	mov    $0x0,%eax
c010428f:	3b 55 c8             	cmp    -0x38(%ebp),%edx
c0104292:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c0104295:	73 0e                	jae    c01042a5 <page_init+0x2f9>
                end = KMEMSIZE;
c0104297:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c010429e:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c01042a5:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01042a8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01042ab:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c01042ae:	89 d0                	mov    %edx,%eax
c01042b0:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c01042b3:	0f 83 97 00 00 00    	jae    c0104350 <page_init+0x3a4>
                begin = ROUNDUP(begin, PGSIZE);
c01042b9:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
c01042c0:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01042c3:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01042c6:	01 d0                	add    %edx,%eax
c01042c8:	48                   	dec    %eax
c01042c9:	89 45 ac             	mov    %eax,-0x54(%ebp)
c01042cc:	8b 45 ac             	mov    -0x54(%ebp),%eax
c01042cf:	ba 00 00 00 00       	mov    $0x0,%edx
c01042d4:	f7 75 b0             	divl   -0x50(%ebp)
c01042d7:	8b 45 ac             	mov    -0x54(%ebp),%eax
c01042da:	29 d0                	sub    %edx,%eax
c01042dc:	ba 00 00 00 00       	mov    $0x0,%edx
c01042e1:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01042e4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c01042e7:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01042ea:	89 45 a8             	mov    %eax,-0x58(%ebp)
c01042ed:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01042f0:	ba 00 00 00 00       	mov    $0x0,%edx
c01042f5:	89 c7                	mov    %eax,%edi
c01042f7:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c01042fd:	89 7d 80             	mov    %edi,-0x80(%ebp)
c0104300:	89 d0                	mov    %edx,%eax
c0104302:	83 e0 00             	and    $0x0,%eax
c0104305:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0104308:	8b 45 80             	mov    -0x80(%ebp),%eax
c010430b:	8b 55 84             	mov    -0x7c(%ebp),%edx
c010430e:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0104311:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
c0104314:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104317:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010431a:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c010431d:	89 d0                	mov    %edx,%eax
c010431f:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c0104322:	73 2c                	jae    c0104350 <page_init+0x3a4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c0104324:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104327:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010432a:	2b 45 d0             	sub    -0x30(%ebp),%eax
c010432d:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
c0104330:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0104334:	c1 ea 0c             	shr    $0xc,%edx
c0104337:	89 c3                	mov    %eax,%ebx
c0104339:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010433c:	89 04 24             	mov    %eax,(%esp)
c010433f:	e8 bb f8 ff ff       	call   c0103bff <pa2page>
c0104344:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0104348:	89 04 24             	mov    %eax,(%esp)
c010434b:	e8 9e fb ff ff       	call   c0103eee <init_memmap>
    for (i = 0; i < memmap->nr_map; i ++) {
c0104350:	ff 45 dc             	incl   -0x24(%ebp)
c0104353:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104356:	8b 00                	mov    (%eax),%eax
c0104358:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c010435b:	0f 8c 9f fe ff ff    	jl     c0104200 <page_init+0x254>
                }
            }
        }
    }
}
c0104361:	90                   	nop
c0104362:	90                   	nop
c0104363:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c0104369:	5b                   	pop    %ebx
c010436a:	5e                   	pop    %esi
c010436b:	5f                   	pop    %edi
c010436c:	5d                   	pop    %ebp
c010436d:	c3                   	ret    

c010436e <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c010436e:	55                   	push   %ebp
c010436f:	89 e5                	mov    %esp,%ebp
c0104371:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c0104374:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104377:	33 45 14             	xor    0x14(%ebp),%eax
c010437a:	25 ff 0f 00 00       	and    $0xfff,%eax
c010437f:	85 c0                	test   %eax,%eax
c0104381:	74 24                	je     c01043a7 <boot_map_segment+0x39>
c0104383:	c7 44 24 0c fa 6c 10 	movl   $0xc0106cfa,0xc(%esp)
c010438a:	c0 
c010438b:	c7 44 24 08 11 6d 10 	movl   $0xc0106d11,0x8(%esp)
c0104392:	c0 
c0104393:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c010439a:	00 
c010439b:	c7 04 24 ec 6c 10 c0 	movl   $0xc0106cec,(%esp)
c01043a2:	e8 5b c9 ff ff       	call   c0100d02 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c01043a7:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c01043ae:	8b 45 0c             	mov    0xc(%ebp),%eax
c01043b1:	25 ff 0f 00 00       	and    $0xfff,%eax
c01043b6:	89 c2                	mov    %eax,%edx
c01043b8:	8b 45 10             	mov    0x10(%ebp),%eax
c01043bb:	01 c2                	add    %eax,%edx
c01043bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01043c0:	01 d0                	add    %edx,%eax
c01043c2:	48                   	dec    %eax
c01043c3:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01043c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01043c9:	ba 00 00 00 00       	mov    $0x0,%edx
c01043ce:	f7 75 f0             	divl   -0x10(%ebp)
c01043d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01043d4:	29 d0                	sub    %edx,%eax
c01043d6:	c1 e8 0c             	shr    $0xc,%eax
c01043d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c01043dc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01043df:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01043e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01043e5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01043ea:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c01043ed:	8b 45 14             	mov    0x14(%ebp),%eax
c01043f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01043f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01043f6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01043fb:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01043fe:	eb 68                	jmp    c0104468 <boot_map_segment+0xfa>
        pte_t *ptep = get_pte(pgdir, la, 1);
c0104400:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0104407:	00 
c0104408:	8b 45 0c             	mov    0xc(%ebp),%eax
c010440b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010440f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104412:	89 04 24             	mov    %eax,(%esp)
c0104415:	e8 88 01 00 00       	call   c01045a2 <get_pte>
c010441a:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c010441d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0104421:	75 24                	jne    c0104447 <boot_map_segment+0xd9>
c0104423:	c7 44 24 0c 26 6d 10 	movl   $0xc0106d26,0xc(%esp)
c010442a:	c0 
c010442b:	c7 44 24 08 11 6d 10 	movl   $0xc0106d11,0x8(%esp)
c0104432:	c0 
c0104433:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
c010443a:	00 
c010443b:	c7 04 24 ec 6c 10 c0 	movl   $0xc0106cec,(%esp)
c0104442:	e8 bb c8 ff ff       	call   c0100d02 <__panic>
        *ptep = pa | PTE_P | perm;
c0104447:	8b 45 14             	mov    0x14(%ebp),%eax
c010444a:	0b 45 18             	or     0x18(%ebp),%eax
c010444d:	83 c8 01             	or     $0x1,%eax
c0104450:	89 c2                	mov    %eax,%edx
c0104452:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104455:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0104457:	ff 4d f4             	decl   -0xc(%ebp)
c010445a:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c0104461:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c0104468:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010446c:	75 92                	jne    c0104400 <boot_map_segment+0x92>
    }
}
c010446e:	90                   	nop
c010446f:	90                   	nop
c0104470:	89 ec                	mov    %ebp,%esp
c0104472:	5d                   	pop    %ebp
c0104473:	c3                   	ret    

c0104474 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c0104474:	55                   	push   %ebp
c0104475:	89 e5                	mov    %esp,%ebp
c0104477:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c010447a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104481:	e8 8a fa ff ff       	call   c0103f10 <alloc_pages>
c0104486:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c0104489:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010448d:	75 1c                	jne    c01044ab <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c010448f:	c7 44 24 08 33 6d 10 	movl   $0xc0106d33,0x8(%esp)
c0104496:	c0 
c0104497:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
c010449e:	00 
c010449f:	c7 04 24 ec 6c 10 c0 	movl   $0xc0106cec,(%esp)
c01044a6:	e8 57 c8 ff ff       	call   c0100d02 <__panic>
    }
    return page2kva(p);
c01044ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044ae:	89 04 24             	mov    %eax,(%esp)
c01044b1:	e8 9a f7 ff ff       	call   c0103c50 <page2kva>
}
c01044b6:	89 ec                	mov    %ebp,%esp
c01044b8:	5d                   	pop    %ebp
c01044b9:	c3                   	ret    

c01044ba <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c01044ba:	55                   	push   %ebp
c01044bb:	89 e5                	mov    %esp,%ebp
c01044bd:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
c01044c0:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c01044c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01044c8:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01044cf:	77 23                	ja     c01044f4 <pmm_init+0x3a>
c01044d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044d4:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01044d8:	c7 44 24 08 c8 6c 10 	movl   $0xc0106cc8,0x8(%esp)
c01044df:	c0 
c01044e0:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c01044e7:	00 
c01044e8:	c7 04 24 ec 6c 10 c0 	movl   $0xc0106cec,(%esp)
c01044ef:	e8 0e c8 ff ff       	call   c0100d02 <__panic>
c01044f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044f7:	05 00 00 00 40       	add    $0x40000000,%eax
c01044fc:	a3 a8 ce 11 c0       	mov    %eax,0xc011cea8
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c0104501:	e8 b2 f9 ff ff       	call   c0103eb8 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c0104506:	e8 a1 fa ff ff       	call   c0103fac <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c010450b:	e8 1b 04 00 00       	call   c010492b <check_alloc_page>

    check_pgdir();
c0104510:	e8 37 04 00 00       	call   c010494c <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c0104515:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c010451a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010451d:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0104524:	77 23                	ja     c0104549 <pmm_init+0x8f>
c0104526:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104529:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010452d:	c7 44 24 08 c8 6c 10 	movl   $0xc0106cc8,0x8(%esp)
c0104534:	c0 
c0104535:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
c010453c:	00 
c010453d:	c7 04 24 ec 6c 10 c0 	movl   $0xc0106cec,(%esp)
c0104544:	e8 b9 c7 ff ff       	call   c0100d02 <__panic>
c0104549:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010454c:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
c0104552:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104557:	05 ac 0f 00 00       	add    $0xfac,%eax
c010455c:	83 ca 03             	or     $0x3,%edx
c010455f:	89 10                	mov    %edx,(%eax)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c0104561:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104566:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c010456d:	00 
c010456e:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104575:	00 
c0104576:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c010457d:	38 
c010457e:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c0104585:	c0 
c0104586:	89 04 24             	mov    %eax,(%esp)
c0104589:	e8 e0 fd ff ff       	call   c010436e <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c010458e:	e8 39 f8 ff ff       	call   c0103dcc <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c0104593:	e8 52 0a 00 00       	call   c0104fea <check_boot_pgdir>

    print_pgdir();
c0104598:	e8 cf 0e 00 00       	call   c010546c <print_pgdir>

}
c010459d:	90                   	nop
c010459e:	89 ec                	mov    %ebp,%esp
c01045a0:	5d                   	pop    %ebp
c01045a1:	c3                   	ret    

c01045a2 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c01045a2:	55                   	push   %ebp
c01045a3:	89 e5                	mov    %esp,%ebp
c01045a5:	83 ec 38             	sub    $0x38,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    pde_t *pdep = pgdir + PDX(la);
c01045a8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01045ab:	c1 e8 16             	shr    $0x16,%eax
c01045ae:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01045b5:	8b 45 08             	mov    0x8(%ebp),%eax
c01045b8:	01 d0                	add    %edx,%eax
c01045ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(((*pdep) & PTE_P)!=1){//如果不存在页目录项
c01045bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045c0:	8b 00                	mov    (%eax),%eax
c01045c2:	83 e0 01             	and    $0x1,%eax
c01045c5:	85 c0                	test   %eax,%eax
c01045c7:	0f 85 d8 00 00 00    	jne    c01046a5 <get_pte+0x103>
        if(!create)return NULL;//不需要创建则返回null
c01045cd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01045d1:	75 0a                	jne    c01045dd <get_pte+0x3b>
c01045d3:	b8 00 00 00 00       	mov    $0x0,%eax
c01045d8:	e9 25 01 00 00       	jmp    c0104702 <get_pte+0x160>
        struct Page* ptPage;
        assert(ptPage=alloc_page());
c01045dd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01045e4:	e8 27 f9 ff ff       	call   c0103f10 <alloc_pages>
c01045e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01045ec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01045f0:	75 24                	jne    c0104616 <get_pte+0x74>
c01045f2:	c7 44 24 0c 4c 6d 10 	movl   $0xc0106d4c,0xc(%esp)
c01045f9:	c0 
c01045fa:	c7 44 24 08 11 6d 10 	movl   $0xc0106d11,0x8(%esp)
c0104601:	c0 
c0104602:	c7 44 24 04 6e 01 00 	movl   $0x16e,0x4(%esp)
c0104609:	00 
c010460a:	c7 04 24 ec 6c 10 c0 	movl   $0xc0106cec,(%esp)
c0104611:	e8 ec c6 ff ff       	call   c0100d02 <__panic>
        set_page_ref(ptPage,1);
c0104616:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010461d:	00 
c010461e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104621:	89 04 24             	mov    %eax,(%esp)
c0104624:	e8 e1 f6 ff ff       	call   c0103d0a <set_page_ref>
        uintptr_t pa=page2pa(ptPage);
c0104629:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010462c:	89 04 24             	mov    %eax,(%esp)
c010462f:	e8 b3 f5 ff ff       	call   c0103be7 <page2pa>
c0104634:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(pa),0,PGSIZE);
c0104637:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010463a:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010463d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104640:	c1 e8 0c             	shr    $0xc,%eax
c0104643:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104646:	a1 a4 ce 11 c0       	mov    0xc011cea4,%eax
c010464b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c010464e:	72 23                	jb     c0104673 <get_pte+0xd1>
c0104650:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104653:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104657:	c7 44 24 08 24 6c 10 	movl   $0xc0106c24,0x8(%esp)
c010465e:	c0 
c010465f:	c7 44 24 04 71 01 00 	movl   $0x171,0x4(%esp)
c0104666:	00 
c0104667:	c7 04 24 ec 6c 10 c0 	movl   $0xc0106cec,(%esp)
c010466e:	e8 8f c6 ff ff       	call   c0100d02 <__panic>
c0104673:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104676:	2d 00 00 00 40       	sub    $0x40000000,%eax
c010467b:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104682:	00 
c0104683:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010468a:	00 
c010468b:	89 04 24             	mov    %eax,(%esp)
c010468e:	e8 de 18 00 00       	call   c0105f71 <memset>
        *pdep=((pa&~0x0FFF)| PTE_U | PTE_W | PTE_P);//未判断此页表项是否存在？
c0104693:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104696:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010469b:	83 c8 07             	or     $0x7,%eax
c010469e:	89 c2                	mov    %eax,%edx
c01046a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046a3:	89 10                	mov    %edx,(%eax)
    }
    return ((pte_t*)KADDR((*pdep) & ~0xFFF)) + PTX(la);
c01046a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046a8:	8b 00                	mov    (%eax),%eax
c01046aa:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01046af:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01046b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01046b5:	c1 e8 0c             	shr    $0xc,%eax
c01046b8:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01046bb:	a1 a4 ce 11 c0       	mov    0xc011cea4,%eax
c01046c0:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c01046c3:	72 23                	jb     c01046e8 <get_pte+0x146>
c01046c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01046c8:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01046cc:	c7 44 24 08 24 6c 10 	movl   $0xc0106c24,0x8(%esp)
c01046d3:	c0 
c01046d4:	c7 44 24 04 74 01 00 	movl   $0x174,0x4(%esp)
c01046db:	00 
c01046dc:	c7 04 24 ec 6c 10 c0 	movl   $0xc0106cec,(%esp)
c01046e3:	e8 1a c6 ff ff       	call   c0100d02 <__panic>
c01046e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01046eb:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01046f0:	89 c2                	mov    %eax,%edx
c01046f2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01046f5:	c1 e8 0c             	shr    $0xc,%eax
c01046f8:	25 ff 03 00 00       	and    $0x3ff,%eax
c01046fd:	c1 e0 02             	shl    $0x2,%eax
c0104700:	01 d0                	add    %edx,%eax

}
c0104702:	89 ec                	mov    %ebp,%esp
c0104704:	5d                   	pop    %ebp
c0104705:	c3                   	ret    

c0104706 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c0104706:	55                   	push   %ebp
c0104707:	89 e5                	mov    %esp,%ebp
c0104709:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c010470c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104713:	00 
c0104714:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104717:	89 44 24 04          	mov    %eax,0x4(%esp)
c010471b:	8b 45 08             	mov    0x8(%ebp),%eax
c010471e:	89 04 24             	mov    %eax,(%esp)
c0104721:	e8 7c fe ff ff       	call   c01045a2 <get_pte>
c0104726:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c0104729:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010472d:	74 08                	je     c0104737 <get_page+0x31>
        *ptep_store = ptep;
c010472f:	8b 45 10             	mov    0x10(%ebp),%eax
c0104732:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104735:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c0104737:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010473b:	74 1b                	je     c0104758 <get_page+0x52>
c010473d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104740:	8b 00                	mov    (%eax),%eax
c0104742:	83 e0 01             	and    $0x1,%eax
c0104745:	85 c0                	test   %eax,%eax
c0104747:	74 0f                	je     c0104758 <get_page+0x52>
        return pte2page(*ptep);
c0104749:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010474c:	8b 00                	mov    (%eax),%eax
c010474e:	89 04 24             	mov    %eax,(%esp)
c0104751:	e8 50 f5 ff ff       	call   c0103ca6 <pte2page>
c0104756:	eb 05                	jmp    c010475d <get_page+0x57>
    }
    return NULL;
c0104758:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010475d:	89 ec                	mov    %ebp,%esp
c010475f:	5d                   	pop    %ebp
c0104760:	c3                   	ret    

c0104761 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c0104761:	55                   	push   %ebp
c0104762:	89 e5                	mov    %esp,%ebp
c0104764:	83 ec 28             	sub    $0x28,%esp
     *                        edited are the ones currently in use by the processor.
     * DEFINEs:
     *   PTE_P           0x001                   // page table/directory entry flags bit : Present
     */

    if(((*ptep)&PTE_P)==1){
c0104767:	8b 45 10             	mov    0x10(%ebp),%eax
c010476a:	8b 00                	mov    (%eax),%eax
c010476c:	83 e0 01             	and    $0x1,%eax
c010476f:	85 c0                	test   %eax,%eax
c0104771:	74 52                	je     c01047c5 <page_remove_pte+0x64>
        struct Page* page=pte2page(*ptep);
c0104773:	8b 45 10             	mov    0x10(%ebp),%eax
c0104776:	8b 00                	mov    (%eax),%eax
c0104778:	89 04 24             	mov    %eax,(%esp)
c010477b:	e8 26 f5 ff ff       	call   c0103ca6 <pte2page>
c0104780:	89 45 f4             	mov    %eax,-0xc(%ebp)
        page_ref_dec(page);
c0104783:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104786:	89 04 24             	mov    %eax,(%esp)
c0104789:	e8 a1 f5 ff ff       	call   c0103d2f <page_ref_dec>
        if(page->ref==0)free_page(page);
c010478e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104791:	8b 00                	mov    (%eax),%eax
c0104793:	85 c0                	test   %eax,%eax
c0104795:	75 13                	jne    c01047aa <page_remove_pte+0x49>
c0104797:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010479e:	00 
c010479f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047a2:	89 04 24             	mov    %eax,(%esp)
c01047a5:	e8 a0 f7 ff ff       	call   c0103f4a <free_pages>
        *ptep=NULL;
c01047aa:	8b 45 10             	mov    0x10(%ebp),%eax
c01047ad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir,la);
c01047b3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01047b6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01047ba:	8b 45 08             	mov    0x8(%ebp),%eax
c01047bd:	89 04 24             	mov    %eax,(%esp)
c01047c0:	e8 07 01 00 00       	call   c01048cc <tlb_invalidate>
#endif




}
c01047c5:	90                   	nop
c01047c6:	89 ec                	mov    %ebp,%esp
c01047c8:	5d                   	pop    %ebp
c01047c9:	c3                   	ret    

c01047ca <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c01047ca:	55                   	push   %ebp
c01047cb:	89 e5                	mov    %esp,%ebp
c01047cd:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01047d0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01047d7:	00 
c01047d8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01047db:	89 44 24 04          	mov    %eax,0x4(%esp)
c01047df:	8b 45 08             	mov    0x8(%ebp),%eax
c01047e2:	89 04 24             	mov    %eax,(%esp)
c01047e5:	e8 b8 fd ff ff       	call   c01045a2 <get_pte>
c01047ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c01047ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01047f1:	74 19                	je     c010480c <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c01047f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047f6:	89 44 24 08          	mov    %eax,0x8(%esp)
c01047fa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01047fd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104801:	8b 45 08             	mov    0x8(%ebp),%eax
c0104804:	89 04 24             	mov    %eax,(%esp)
c0104807:	e8 55 ff ff ff       	call   c0104761 <page_remove_pte>
    }
}
c010480c:	90                   	nop
c010480d:	89 ec                	mov    %ebp,%esp
c010480f:	5d                   	pop    %ebp
c0104810:	c3                   	ret    

c0104811 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c0104811:	55                   	push   %ebp
c0104812:	89 e5                	mov    %esp,%ebp
c0104814:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c0104817:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c010481e:	00 
c010481f:	8b 45 10             	mov    0x10(%ebp),%eax
c0104822:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104826:	8b 45 08             	mov    0x8(%ebp),%eax
c0104829:	89 04 24             	mov    %eax,(%esp)
c010482c:	e8 71 fd ff ff       	call   c01045a2 <get_pte>
c0104831:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c0104834:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104838:	75 0a                	jne    c0104844 <page_insert+0x33>
        return -E_NO_MEM;
c010483a:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c010483f:	e9 84 00 00 00       	jmp    c01048c8 <page_insert+0xb7>
    }
    page_ref_inc(page);
c0104844:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104847:	89 04 24             	mov    %eax,(%esp)
c010484a:	e8 c9 f4 ff ff       	call   c0103d18 <page_ref_inc>
    if (*ptep & PTE_P) {
c010484f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104852:	8b 00                	mov    (%eax),%eax
c0104854:	83 e0 01             	and    $0x1,%eax
c0104857:	85 c0                	test   %eax,%eax
c0104859:	74 3e                	je     c0104899 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c010485b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010485e:	8b 00                	mov    (%eax),%eax
c0104860:	89 04 24             	mov    %eax,(%esp)
c0104863:	e8 3e f4 ff ff       	call   c0103ca6 <pte2page>
c0104868:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c010486b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010486e:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104871:	75 0d                	jne    c0104880 <page_insert+0x6f>
            page_ref_dec(page);
c0104873:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104876:	89 04 24             	mov    %eax,(%esp)
c0104879:	e8 b1 f4 ff ff       	call   c0103d2f <page_ref_dec>
c010487e:	eb 19                	jmp    c0104899 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c0104880:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104883:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104887:	8b 45 10             	mov    0x10(%ebp),%eax
c010488a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010488e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104891:	89 04 24             	mov    %eax,(%esp)
c0104894:	e8 c8 fe ff ff       	call   c0104761 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c0104899:	8b 45 0c             	mov    0xc(%ebp),%eax
c010489c:	89 04 24             	mov    %eax,(%esp)
c010489f:	e8 43 f3 ff ff       	call   c0103be7 <page2pa>
c01048a4:	0b 45 14             	or     0x14(%ebp),%eax
c01048a7:	83 c8 01             	or     $0x1,%eax
c01048aa:	89 c2                	mov    %eax,%edx
c01048ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048af:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c01048b1:	8b 45 10             	mov    0x10(%ebp),%eax
c01048b4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01048b8:	8b 45 08             	mov    0x8(%ebp),%eax
c01048bb:	89 04 24             	mov    %eax,(%esp)
c01048be:	e8 09 00 00 00       	call   c01048cc <tlb_invalidate>
    return 0;
c01048c3:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01048c8:	89 ec                	mov    %ebp,%esp
c01048ca:	5d                   	pop    %ebp
c01048cb:	c3                   	ret    

c01048cc <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c01048cc:	55                   	push   %ebp
c01048cd:	89 e5                	mov    %esp,%ebp
c01048cf:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c01048d2:	0f 20 d8             	mov    %cr3,%eax
c01048d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c01048d8:	8b 55 f0             	mov    -0x10(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
c01048db:	8b 45 08             	mov    0x8(%ebp),%eax
c01048de:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01048e1:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01048e8:	77 23                	ja     c010490d <tlb_invalidate+0x41>
c01048ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048ed:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01048f1:	c7 44 24 08 c8 6c 10 	movl   $0xc0106cc8,0x8(%esp)
c01048f8:	c0 
c01048f9:	c7 44 24 04 de 01 00 	movl   $0x1de,0x4(%esp)
c0104900:	00 
c0104901:	c7 04 24 ec 6c 10 c0 	movl   $0xc0106cec,(%esp)
c0104908:	e8 f5 c3 ff ff       	call   c0100d02 <__panic>
c010490d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104910:	05 00 00 00 40       	add    $0x40000000,%eax
c0104915:	39 d0                	cmp    %edx,%eax
c0104917:	75 0d                	jne    c0104926 <tlb_invalidate+0x5a>
        invlpg((void *)la);
c0104919:	8b 45 0c             	mov    0xc(%ebp),%eax
c010491c:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c010491f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104922:	0f 01 38             	invlpg (%eax)
}
c0104925:	90                   	nop
    }
}
c0104926:	90                   	nop
c0104927:	89 ec                	mov    %ebp,%esp
c0104929:	5d                   	pop    %ebp
c010492a:	c3                   	ret    

c010492b <check_alloc_page>:

static void
check_alloc_page(void) {
c010492b:	55                   	push   %ebp
c010492c:	89 e5                	mov    %esp,%ebp
c010492e:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c0104931:	a1 ac ce 11 c0       	mov    0xc011ceac,%eax
c0104936:	8b 40 18             	mov    0x18(%eax),%eax
c0104939:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c010493b:	c7 04 24 60 6d 10 c0 	movl   $0xc0106d60,(%esp)
c0104942:	e8 1a ba ff ff       	call   c0100361 <cprintf>
}
c0104947:	90                   	nop
c0104948:	89 ec                	mov    %ebp,%esp
c010494a:	5d                   	pop    %ebp
c010494b:	c3                   	ret    

c010494c <check_pgdir>:

static void
check_pgdir(void) {
c010494c:	55                   	push   %ebp
c010494d:	89 e5                	mov    %esp,%ebp
c010494f:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c0104952:	a1 a4 ce 11 c0       	mov    0xc011cea4,%eax
c0104957:	3d 00 80 03 00       	cmp    $0x38000,%eax
c010495c:	76 24                	jbe    c0104982 <check_pgdir+0x36>
c010495e:	c7 44 24 0c 7f 6d 10 	movl   $0xc0106d7f,0xc(%esp)
c0104965:	c0 
c0104966:	c7 44 24 08 11 6d 10 	movl   $0xc0106d11,0x8(%esp)
c010496d:	c0 
c010496e:	c7 44 24 04 eb 01 00 	movl   $0x1eb,0x4(%esp)
c0104975:	00 
c0104976:	c7 04 24 ec 6c 10 c0 	movl   $0xc0106cec,(%esp)
c010497d:	e8 80 c3 ff ff       	call   c0100d02 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c0104982:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104987:	85 c0                	test   %eax,%eax
c0104989:	74 0e                	je     c0104999 <check_pgdir+0x4d>
c010498b:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104990:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104995:	85 c0                	test   %eax,%eax
c0104997:	74 24                	je     c01049bd <check_pgdir+0x71>
c0104999:	c7 44 24 0c 9c 6d 10 	movl   $0xc0106d9c,0xc(%esp)
c01049a0:	c0 
c01049a1:	c7 44 24 08 11 6d 10 	movl   $0xc0106d11,0x8(%esp)
c01049a8:	c0 
c01049a9:	c7 44 24 04 ec 01 00 	movl   $0x1ec,0x4(%esp)
c01049b0:	00 
c01049b1:	c7 04 24 ec 6c 10 c0 	movl   $0xc0106cec,(%esp)
c01049b8:	e8 45 c3 ff ff       	call   c0100d02 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c01049bd:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c01049c2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01049c9:	00 
c01049ca:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01049d1:	00 
c01049d2:	89 04 24             	mov    %eax,(%esp)
c01049d5:	e8 2c fd ff ff       	call   c0104706 <get_page>
c01049da:	85 c0                	test   %eax,%eax
c01049dc:	74 24                	je     c0104a02 <check_pgdir+0xb6>
c01049de:	c7 44 24 0c d4 6d 10 	movl   $0xc0106dd4,0xc(%esp)
c01049e5:	c0 
c01049e6:	c7 44 24 08 11 6d 10 	movl   $0xc0106d11,0x8(%esp)
c01049ed:	c0 
c01049ee:	c7 44 24 04 ed 01 00 	movl   $0x1ed,0x4(%esp)
c01049f5:	00 
c01049f6:	c7 04 24 ec 6c 10 c0 	movl   $0xc0106cec,(%esp)
c01049fd:	e8 00 c3 ff ff       	call   c0100d02 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c0104a02:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104a09:	e8 02 f5 ff ff       	call   c0103f10 <alloc_pages>
c0104a0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c0104a11:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104a16:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104a1d:	00 
c0104a1e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104a25:	00 
c0104a26:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104a29:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104a2d:	89 04 24             	mov    %eax,(%esp)
c0104a30:	e8 dc fd ff ff       	call   c0104811 <page_insert>
c0104a35:	85 c0                	test   %eax,%eax
c0104a37:	74 24                	je     c0104a5d <check_pgdir+0x111>
c0104a39:	c7 44 24 0c fc 6d 10 	movl   $0xc0106dfc,0xc(%esp)
c0104a40:	c0 
c0104a41:	c7 44 24 08 11 6d 10 	movl   $0xc0106d11,0x8(%esp)
c0104a48:	c0 
c0104a49:	c7 44 24 04 f1 01 00 	movl   $0x1f1,0x4(%esp)
c0104a50:	00 
c0104a51:	c7 04 24 ec 6c 10 c0 	movl   $0xc0106cec,(%esp)
c0104a58:	e8 a5 c2 ff ff       	call   c0100d02 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c0104a5d:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104a62:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104a69:	00 
c0104a6a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104a71:	00 
c0104a72:	89 04 24             	mov    %eax,(%esp)
c0104a75:	e8 28 fb ff ff       	call   c01045a2 <get_pte>
c0104a7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104a7d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104a81:	75 24                	jne    c0104aa7 <check_pgdir+0x15b>
c0104a83:	c7 44 24 0c 28 6e 10 	movl   $0xc0106e28,0xc(%esp)
c0104a8a:	c0 
c0104a8b:	c7 44 24 08 11 6d 10 	movl   $0xc0106d11,0x8(%esp)
c0104a92:	c0 
c0104a93:	c7 44 24 04 f4 01 00 	movl   $0x1f4,0x4(%esp)
c0104a9a:	00 
c0104a9b:	c7 04 24 ec 6c 10 c0 	movl   $0xc0106cec,(%esp)
c0104aa2:	e8 5b c2 ff ff       	call   c0100d02 <__panic>
    assert(pte2page(*ptep) == p1);
c0104aa7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104aaa:	8b 00                	mov    (%eax),%eax
c0104aac:	89 04 24             	mov    %eax,(%esp)
c0104aaf:	e8 f2 f1 ff ff       	call   c0103ca6 <pte2page>
c0104ab4:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0104ab7:	74 24                	je     c0104add <check_pgdir+0x191>
c0104ab9:	c7 44 24 0c 55 6e 10 	movl   $0xc0106e55,0xc(%esp)
c0104ac0:	c0 
c0104ac1:	c7 44 24 08 11 6d 10 	movl   $0xc0106d11,0x8(%esp)
c0104ac8:	c0 
c0104ac9:	c7 44 24 04 f5 01 00 	movl   $0x1f5,0x4(%esp)
c0104ad0:	00 
c0104ad1:	c7 04 24 ec 6c 10 c0 	movl   $0xc0106cec,(%esp)
c0104ad8:	e8 25 c2 ff ff       	call   c0100d02 <__panic>
    assert(page_ref(p1) == 1);
c0104add:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ae0:	89 04 24             	mov    %eax,(%esp)
c0104ae3:	e8 18 f2 ff ff       	call   c0103d00 <page_ref>
c0104ae8:	83 f8 01             	cmp    $0x1,%eax
c0104aeb:	74 24                	je     c0104b11 <check_pgdir+0x1c5>
c0104aed:	c7 44 24 0c 6b 6e 10 	movl   $0xc0106e6b,0xc(%esp)
c0104af4:	c0 
c0104af5:	c7 44 24 08 11 6d 10 	movl   $0xc0106d11,0x8(%esp)
c0104afc:	c0 
c0104afd:	c7 44 24 04 f6 01 00 	movl   $0x1f6,0x4(%esp)
c0104b04:	00 
c0104b05:	c7 04 24 ec 6c 10 c0 	movl   $0xc0106cec,(%esp)
c0104b0c:	e8 f1 c1 ff ff       	call   c0100d02 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c0104b11:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104b16:	8b 00                	mov    (%eax),%eax
c0104b18:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104b1d:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104b20:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104b23:	c1 e8 0c             	shr    $0xc,%eax
c0104b26:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104b29:	a1 a4 ce 11 c0       	mov    0xc011cea4,%eax
c0104b2e:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0104b31:	72 23                	jb     c0104b56 <check_pgdir+0x20a>
c0104b33:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104b36:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104b3a:	c7 44 24 08 24 6c 10 	movl   $0xc0106c24,0x8(%esp)
c0104b41:	c0 
c0104b42:	c7 44 24 04 f8 01 00 	movl   $0x1f8,0x4(%esp)
c0104b49:	00 
c0104b4a:	c7 04 24 ec 6c 10 c0 	movl   $0xc0106cec,(%esp)
c0104b51:	e8 ac c1 ff ff       	call   c0100d02 <__panic>
c0104b56:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104b59:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104b5e:	83 c0 04             	add    $0x4,%eax
c0104b61:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c0104b64:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104b69:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104b70:	00 
c0104b71:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104b78:	00 
c0104b79:	89 04 24             	mov    %eax,(%esp)
c0104b7c:	e8 21 fa ff ff       	call   c01045a2 <get_pte>
c0104b81:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0104b84:	74 24                	je     c0104baa <check_pgdir+0x25e>
c0104b86:	c7 44 24 0c 80 6e 10 	movl   $0xc0106e80,0xc(%esp)
c0104b8d:	c0 
c0104b8e:	c7 44 24 08 11 6d 10 	movl   $0xc0106d11,0x8(%esp)
c0104b95:	c0 
c0104b96:	c7 44 24 04 f9 01 00 	movl   $0x1f9,0x4(%esp)
c0104b9d:	00 
c0104b9e:	c7 04 24 ec 6c 10 c0 	movl   $0xc0106cec,(%esp)
c0104ba5:	e8 58 c1 ff ff       	call   c0100d02 <__panic>

    p2 = alloc_page();
c0104baa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104bb1:	e8 5a f3 ff ff       	call   c0103f10 <alloc_pages>
c0104bb6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0104bb9:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104bbe:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c0104bc5:	00 
c0104bc6:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104bcd:	00 
c0104bce:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104bd1:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104bd5:	89 04 24             	mov    %eax,(%esp)
c0104bd8:	e8 34 fc ff ff       	call   c0104811 <page_insert>
c0104bdd:	85 c0                	test   %eax,%eax
c0104bdf:	74 24                	je     c0104c05 <check_pgdir+0x2b9>
c0104be1:	c7 44 24 0c a8 6e 10 	movl   $0xc0106ea8,0xc(%esp)
c0104be8:	c0 
c0104be9:	c7 44 24 08 11 6d 10 	movl   $0xc0106d11,0x8(%esp)
c0104bf0:	c0 
c0104bf1:	c7 44 24 04 fc 01 00 	movl   $0x1fc,0x4(%esp)
c0104bf8:	00 
c0104bf9:	c7 04 24 ec 6c 10 c0 	movl   $0xc0106cec,(%esp)
c0104c00:	e8 fd c0 ff ff       	call   c0100d02 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104c05:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104c0a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104c11:	00 
c0104c12:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104c19:	00 
c0104c1a:	89 04 24             	mov    %eax,(%esp)
c0104c1d:	e8 80 f9 ff ff       	call   c01045a2 <get_pte>
c0104c22:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104c25:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104c29:	75 24                	jne    c0104c4f <check_pgdir+0x303>
c0104c2b:	c7 44 24 0c e0 6e 10 	movl   $0xc0106ee0,0xc(%esp)
c0104c32:	c0 
c0104c33:	c7 44 24 08 11 6d 10 	movl   $0xc0106d11,0x8(%esp)
c0104c3a:	c0 
c0104c3b:	c7 44 24 04 fd 01 00 	movl   $0x1fd,0x4(%esp)
c0104c42:	00 
c0104c43:	c7 04 24 ec 6c 10 c0 	movl   $0xc0106cec,(%esp)
c0104c4a:	e8 b3 c0 ff ff       	call   c0100d02 <__panic>
    assert(*ptep & PTE_U);
c0104c4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c52:	8b 00                	mov    (%eax),%eax
c0104c54:	83 e0 04             	and    $0x4,%eax
c0104c57:	85 c0                	test   %eax,%eax
c0104c59:	75 24                	jne    c0104c7f <check_pgdir+0x333>
c0104c5b:	c7 44 24 0c 10 6f 10 	movl   $0xc0106f10,0xc(%esp)
c0104c62:	c0 
c0104c63:	c7 44 24 08 11 6d 10 	movl   $0xc0106d11,0x8(%esp)
c0104c6a:	c0 
c0104c6b:	c7 44 24 04 fe 01 00 	movl   $0x1fe,0x4(%esp)
c0104c72:	00 
c0104c73:	c7 04 24 ec 6c 10 c0 	movl   $0xc0106cec,(%esp)
c0104c7a:	e8 83 c0 ff ff       	call   c0100d02 <__panic>
    assert(*ptep & PTE_W);
c0104c7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c82:	8b 00                	mov    (%eax),%eax
c0104c84:	83 e0 02             	and    $0x2,%eax
c0104c87:	85 c0                	test   %eax,%eax
c0104c89:	75 24                	jne    c0104caf <check_pgdir+0x363>
c0104c8b:	c7 44 24 0c 1e 6f 10 	movl   $0xc0106f1e,0xc(%esp)
c0104c92:	c0 
c0104c93:	c7 44 24 08 11 6d 10 	movl   $0xc0106d11,0x8(%esp)
c0104c9a:	c0 
c0104c9b:	c7 44 24 04 ff 01 00 	movl   $0x1ff,0x4(%esp)
c0104ca2:	00 
c0104ca3:	c7 04 24 ec 6c 10 c0 	movl   $0xc0106cec,(%esp)
c0104caa:	e8 53 c0 ff ff       	call   c0100d02 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0104caf:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104cb4:	8b 00                	mov    (%eax),%eax
c0104cb6:	83 e0 04             	and    $0x4,%eax
c0104cb9:	85 c0                	test   %eax,%eax
c0104cbb:	75 24                	jne    c0104ce1 <check_pgdir+0x395>
c0104cbd:	c7 44 24 0c 2c 6f 10 	movl   $0xc0106f2c,0xc(%esp)
c0104cc4:	c0 
c0104cc5:	c7 44 24 08 11 6d 10 	movl   $0xc0106d11,0x8(%esp)
c0104ccc:	c0 
c0104ccd:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
c0104cd4:	00 
c0104cd5:	c7 04 24 ec 6c 10 c0 	movl   $0xc0106cec,(%esp)
c0104cdc:	e8 21 c0 ff ff       	call   c0100d02 <__panic>
    assert(page_ref(p2) == 1);
c0104ce1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104ce4:	89 04 24             	mov    %eax,(%esp)
c0104ce7:	e8 14 f0 ff ff       	call   c0103d00 <page_ref>
c0104cec:	83 f8 01             	cmp    $0x1,%eax
c0104cef:	74 24                	je     c0104d15 <check_pgdir+0x3c9>
c0104cf1:	c7 44 24 0c 42 6f 10 	movl   $0xc0106f42,0xc(%esp)
c0104cf8:	c0 
c0104cf9:	c7 44 24 08 11 6d 10 	movl   $0xc0106d11,0x8(%esp)
c0104d00:	c0 
c0104d01:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
c0104d08:	00 
c0104d09:	c7 04 24 ec 6c 10 c0 	movl   $0xc0106cec,(%esp)
c0104d10:	e8 ed bf ff ff       	call   c0100d02 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0104d15:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104d1a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104d21:	00 
c0104d22:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104d29:	00 
c0104d2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104d2d:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104d31:	89 04 24             	mov    %eax,(%esp)
c0104d34:	e8 d8 fa ff ff       	call   c0104811 <page_insert>
c0104d39:	85 c0                	test   %eax,%eax
c0104d3b:	74 24                	je     c0104d61 <check_pgdir+0x415>
c0104d3d:	c7 44 24 0c 54 6f 10 	movl   $0xc0106f54,0xc(%esp)
c0104d44:	c0 
c0104d45:	c7 44 24 08 11 6d 10 	movl   $0xc0106d11,0x8(%esp)
c0104d4c:	c0 
c0104d4d:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
c0104d54:	00 
c0104d55:	c7 04 24 ec 6c 10 c0 	movl   $0xc0106cec,(%esp)
c0104d5c:	e8 a1 bf ff ff       	call   c0100d02 <__panic>
    assert(page_ref(p1) == 2);
c0104d61:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d64:	89 04 24             	mov    %eax,(%esp)
c0104d67:	e8 94 ef ff ff       	call   c0103d00 <page_ref>
c0104d6c:	83 f8 02             	cmp    $0x2,%eax
c0104d6f:	74 24                	je     c0104d95 <check_pgdir+0x449>
c0104d71:	c7 44 24 0c 80 6f 10 	movl   $0xc0106f80,0xc(%esp)
c0104d78:	c0 
c0104d79:	c7 44 24 08 11 6d 10 	movl   $0xc0106d11,0x8(%esp)
c0104d80:	c0 
c0104d81:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
c0104d88:	00 
c0104d89:	c7 04 24 ec 6c 10 c0 	movl   $0xc0106cec,(%esp)
c0104d90:	e8 6d bf ff ff       	call   c0100d02 <__panic>
    assert(page_ref(p2) == 0);
c0104d95:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104d98:	89 04 24             	mov    %eax,(%esp)
c0104d9b:	e8 60 ef ff ff       	call   c0103d00 <page_ref>
c0104da0:	85 c0                	test   %eax,%eax
c0104da2:	74 24                	je     c0104dc8 <check_pgdir+0x47c>
c0104da4:	c7 44 24 0c 92 6f 10 	movl   $0xc0106f92,0xc(%esp)
c0104dab:	c0 
c0104dac:	c7 44 24 08 11 6d 10 	movl   $0xc0106d11,0x8(%esp)
c0104db3:	c0 
c0104db4:	c7 44 24 04 05 02 00 	movl   $0x205,0x4(%esp)
c0104dbb:	00 
c0104dbc:	c7 04 24 ec 6c 10 c0 	movl   $0xc0106cec,(%esp)
c0104dc3:	e8 3a bf ff ff       	call   c0100d02 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104dc8:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104dcd:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104dd4:	00 
c0104dd5:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104ddc:	00 
c0104ddd:	89 04 24             	mov    %eax,(%esp)
c0104de0:	e8 bd f7 ff ff       	call   c01045a2 <get_pte>
c0104de5:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104de8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104dec:	75 24                	jne    c0104e12 <check_pgdir+0x4c6>
c0104dee:	c7 44 24 0c e0 6e 10 	movl   $0xc0106ee0,0xc(%esp)
c0104df5:	c0 
c0104df6:	c7 44 24 08 11 6d 10 	movl   $0xc0106d11,0x8(%esp)
c0104dfd:	c0 
c0104dfe:	c7 44 24 04 06 02 00 	movl   $0x206,0x4(%esp)
c0104e05:	00 
c0104e06:	c7 04 24 ec 6c 10 c0 	movl   $0xc0106cec,(%esp)
c0104e0d:	e8 f0 be ff ff       	call   c0100d02 <__panic>
    assert(pte2page(*ptep) == p1);
c0104e12:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e15:	8b 00                	mov    (%eax),%eax
c0104e17:	89 04 24             	mov    %eax,(%esp)
c0104e1a:	e8 87 ee ff ff       	call   c0103ca6 <pte2page>
c0104e1f:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0104e22:	74 24                	je     c0104e48 <check_pgdir+0x4fc>
c0104e24:	c7 44 24 0c 55 6e 10 	movl   $0xc0106e55,0xc(%esp)
c0104e2b:	c0 
c0104e2c:	c7 44 24 08 11 6d 10 	movl   $0xc0106d11,0x8(%esp)
c0104e33:	c0 
c0104e34:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
c0104e3b:	00 
c0104e3c:	c7 04 24 ec 6c 10 c0 	movl   $0xc0106cec,(%esp)
c0104e43:	e8 ba be ff ff       	call   c0100d02 <__panic>
    assert((*ptep & PTE_U) == 0);
c0104e48:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e4b:	8b 00                	mov    (%eax),%eax
c0104e4d:	83 e0 04             	and    $0x4,%eax
c0104e50:	85 c0                	test   %eax,%eax
c0104e52:	74 24                	je     c0104e78 <check_pgdir+0x52c>
c0104e54:	c7 44 24 0c a4 6f 10 	movl   $0xc0106fa4,0xc(%esp)
c0104e5b:	c0 
c0104e5c:	c7 44 24 08 11 6d 10 	movl   $0xc0106d11,0x8(%esp)
c0104e63:	c0 
c0104e64:	c7 44 24 04 08 02 00 	movl   $0x208,0x4(%esp)
c0104e6b:	00 
c0104e6c:	c7 04 24 ec 6c 10 c0 	movl   $0xc0106cec,(%esp)
c0104e73:	e8 8a be ff ff       	call   c0100d02 <__panic>

    page_remove(boot_pgdir, 0x0);
c0104e78:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104e7d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104e84:	00 
c0104e85:	89 04 24             	mov    %eax,(%esp)
c0104e88:	e8 3d f9 ff ff       	call   c01047ca <page_remove>
    assert(page_ref(p1) == 1);
c0104e8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e90:	89 04 24             	mov    %eax,(%esp)
c0104e93:	e8 68 ee ff ff       	call   c0103d00 <page_ref>
c0104e98:	83 f8 01             	cmp    $0x1,%eax
c0104e9b:	74 24                	je     c0104ec1 <check_pgdir+0x575>
c0104e9d:	c7 44 24 0c 6b 6e 10 	movl   $0xc0106e6b,0xc(%esp)
c0104ea4:	c0 
c0104ea5:	c7 44 24 08 11 6d 10 	movl   $0xc0106d11,0x8(%esp)
c0104eac:	c0 
c0104ead:	c7 44 24 04 0b 02 00 	movl   $0x20b,0x4(%esp)
c0104eb4:	00 
c0104eb5:	c7 04 24 ec 6c 10 c0 	movl   $0xc0106cec,(%esp)
c0104ebc:	e8 41 be ff ff       	call   c0100d02 <__panic>
    assert(page_ref(p2) == 0);
c0104ec1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104ec4:	89 04 24             	mov    %eax,(%esp)
c0104ec7:	e8 34 ee ff ff       	call   c0103d00 <page_ref>
c0104ecc:	85 c0                	test   %eax,%eax
c0104ece:	74 24                	je     c0104ef4 <check_pgdir+0x5a8>
c0104ed0:	c7 44 24 0c 92 6f 10 	movl   $0xc0106f92,0xc(%esp)
c0104ed7:	c0 
c0104ed8:	c7 44 24 08 11 6d 10 	movl   $0xc0106d11,0x8(%esp)
c0104edf:	c0 
c0104ee0:	c7 44 24 04 0c 02 00 	movl   $0x20c,0x4(%esp)
c0104ee7:	00 
c0104ee8:	c7 04 24 ec 6c 10 c0 	movl   $0xc0106cec,(%esp)
c0104eef:	e8 0e be ff ff       	call   c0100d02 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0104ef4:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104ef9:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104f00:	00 
c0104f01:	89 04 24             	mov    %eax,(%esp)
c0104f04:	e8 c1 f8 ff ff       	call   c01047ca <page_remove>
    assert(page_ref(p1) == 0);
c0104f09:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f0c:	89 04 24             	mov    %eax,(%esp)
c0104f0f:	e8 ec ed ff ff       	call   c0103d00 <page_ref>
c0104f14:	85 c0                	test   %eax,%eax
c0104f16:	74 24                	je     c0104f3c <check_pgdir+0x5f0>
c0104f18:	c7 44 24 0c b9 6f 10 	movl   $0xc0106fb9,0xc(%esp)
c0104f1f:	c0 
c0104f20:	c7 44 24 08 11 6d 10 	movl   $0xc0106d11,0x8(%esp)
c0104f27:	c0 
c0104f28:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
c0104f2f:	00 
c0104f30:	c7 04 24 ec 6c 10 c0 	movl   $0xc0106cec,(%esp)
c0104f37:	e8 c6 bd ff ff       	call   c0100d02 <__panic>
    assert(page_ref(p2) == 0);
c0104f3c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104f3f:	89 04 24             	mov    %eax,(%esp)
c0104f42:	e8 b9 ed ff ff       	call   c0103d00 <page_ref>
c0104f47:	85 c0                	test   %eax,%eax
c0104f49:	74 24                	je     c0104f6f <check_pgdir+0x623>
c0104f4b:	c7 44 24 0c 92 6f 10 	movl   $0xc0106f92,0xc(%esp)
c0104f52:	c0 
c0104f53:	c7 44 24 08 11 6d 10 	movl   $0xc0106d11,0x8(%esp)
c0104f5a:	c0 
c0104f5b:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
c0104f62:	00 
c0104f63:	c7 04 24 ec 6c 10 c0 	movl   $0xc0106cec,(%esp)
c0104f6a:	e8 93 bd ff ff       	call   c0100d02 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c0104f6f:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104f74:	8b 00                	mov    (%eax),%eax
c0104f76:	89 04 24             	mov    %eax,(%esp)
c0104f79:	e8 68 ed ff ff       	call   c0103ce6 <pde2page>
c0104f7e:	89 04 24             	mov    %eax,(%esp)
c0104f81:	e8 7a ed ff ff       	call   c0103d00 <page_ref>
c0104f86:	83 f8 01             	cmp    $0x1,%eax
c0104f89:	74 24                	je     c0104faf <check_pgdir+0x663>
c0104f8b:	c7 44 24 0c cc 6f 10 	movl   $0xc0106fcc,0xc(%esp)
c0104f92:	c0 
c0104f93:	c7 44 24 08 11 6d 10 	movl   $0xc0106d11,0x8(%esp)
c0104f9a:	c0 
c0104f9b:	c7 44 24 04 12 02 00 	movl   $0x212,0x4(%esp)
c0104fa2:	00 
c0104fa3:	c7 04 24 ec 6c 10 c0 	movl   $0xc0106cec,(%esp)
c0104faa:	e8 53 bd ff ff       	call   c0100d02 <__panic>
    free_page(pde2page(boot_pgdir[0]));
c0104faf:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104fb4:	8b 00                	mov    (%eax),%eax
c0104fb6:	89 04 24             	mov    %eax,(%esp)
c0104fb9:	e8 28 ed ff ff       	call   c0103ce6 <pde2page>
c0104fbe:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104fc5:	00 
c0104fc6:	89 04 24             	mov    %eax,(%esp)
c0104fc9:	e8 7c ef ff ff       	call   c0103f4a <free_pages>
    boot_pgdir[0] = 0;
c0104fce:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0104fd3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0104fd9:	c7 04 24 f3 6f 10 c0 	movl   $0xc0106ff3,(%esp)
c0104fe0:	e8 7c b3 ff ff       	call   c0100361 <cprintf>
}
c0104fe5:	90                   	nop
c0104fe6:	89 ec                	mov    %ebp,%esp
c0104fe8:	5d                   	pop    %ebp
c0104fe9:	c3                   	ret    

c0104fea <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0104fea:	55                   	push   %ebp
c0104feb:	89 e5                	mov    %esp,%ebp
c0104fed:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0104ff0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104ff7:	e9 ca 00 00 00       	jmp    c01050c6 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0104ffc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104fff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105002:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105005:	c1 e8 0c             	shr    $0xc,%eax
c0105008:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010500b:	a1 a4 ce 11 c0       	mov    0xc011cea4,%eax
c0105010:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0105013:	72 23                	jb     c0105038 <check_boot_pgdir+0x4e>
c0105015:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105018:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010501c:	c7 44 24 08 24 6c 10 	movl   $0xc0106c24,0x8(%esp)
c0105023:	c0 
c0105024:	c7 44 24 04 1e 02 00 	movl   $0x21e,0x4(%esp)
c010502b:	00 
c010502c:	c7 04 24 ec 6c 10 c0 	movl   $0xc0106cec,(%esp)
c0105033:	e8 ca bc ff ff       	call   c0100d02 <__panic>
c0105038:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010503b:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0105040:	89 c2                	mov    %eax,%edx
c0105042:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0105047:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010504e:	00 
c010504f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105053:	89 04 24             	mov    %eax,(%esp)
c0105056:	e8 47 f5 ff ff       	call   c01045a2 <get_pte>
c010505b:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010505e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0105062:	75 24                	jne    c0105088 <check_boot_pgdir+0x9e>
c0105064:	c7 44 24 0c 10 70 10 	movl   $0xc0107010,0xc(%esp)
c010506b:	c0 
c010506c:	c7 44 24 08 11 6d 10 	movl   $0xc0106d11,0x8(%esp)
c0105073:	c0 
c0105074:	c7 44 24 04 1e 02 00 	movl   $0x21e,0x4(%esp)
c010507b:	00 
c010507c:	c7 04 24 ec 6c 10 c0 	movl   $0xc0106cec,(%esp)
c0105083:	e8 7a bc ff ff       	call   c0100d02 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0105088:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010508b:	8b 00                	mov    (%eax),%eax
c010508d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105092:	89 c2                	mov    %eax,%edx
c0105094:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105097:	39 c2                	cmp    %eax,%edx
c0105099:	74 24                	je     c01050bf <check_boot_pgdir+0xd5>
c010509b:	c7 44 24 0c 4d 70 10 	movl   $0xc010704d,0xc(%esp)
c01050a2:	c0 
c01050a3:	c7 44 24 08 11 6d 10 	movl   $0xc0106d11,0x8(%esp)
c01050aa:	c0 
c01050ab:	c7 44 24 04 1f 02 00 	movl   $0x21f,0x4(%esp)
c01050b2:	00 
c01050b3:	c7 04 24 ec 6c 10 c0 	movl   $0xc0106cec,(%esp)
c01050ba:	e8 43 bc ff ff       	call   c0100d02 <__panic>
    for (i = 0; i < npage; i += PGSIZE) {
c01050bf:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c01050c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01050c9:	a1 a4 ce 11 c0       	mov    0xc011cea4,%eax
c01050ce:	39 c2                	cmp    %eax,%edx
c01050d0:	0f 82 26 ff ff ff    	jb     c0104ffc <check_boot_pgdir+0x12>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c01050d6:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c01050db:	05 ac 0f 00 00       	add    $0xfac,%eax
c01050e0:	8b 00                	mov    (%eax),%eax
c01050e2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01050e7:	89 c2                	mov    %eax,%edx
c01050e9:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c01050ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01050f1:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c01050f8:	77 23                	ja     c010511d <check_boot_pgdir+0x133>
c01050fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01050fd:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105101:	c7 44 24 08 c8 6c 10 	movl   $0xc0106cc8,0x8(%esp)
c0105108:	c0 
c0105109:	c7 44 24 04 22 02 00 	movl   $0x222,0x4(%esp)
c0105110:	00 
c0105111:	c7 04 24 ec 6c 10 c0 	movl   $0xc0106cec,(%esp)
c0105118:	e8 e5 bb ff ff       	call   c0100d02 <__panic>
c010511d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105120:	05 00 00 00 40       	add    $0x40000000,%eax
c0105125:	39 d0                	cmp    %edx,%eax
c0105127:	74 24                	je     c010514d <check_boot_pgdir+0x163>
c0105129:	c7 44 24 0c 64 70 10 	movl   $0xc0107064,0xc(%esp)
c0105130:	c0 
c0105131:	c7 44 24 08 11 6d 10 	movl   $0xc0106d11,0x8(%esp)
c0105138:	c0 
c0105139:	c7 44 24 04 22 02 00 	movl   $0x222,0x4(%esp)
c0105140:	00 
c0105141:	c7 04 24 ec 6c 10 c0 	movl   $0xc0106cec,(%esp)
c0105148:	e8 b5 bb ff ff       	call   c0100d02 <__panic>

    assert(boot_pgdir[0] == 0);
c010514d:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0105152:	8b 00                	mov    (%eax),%eax
c0105154:	85 c0                	test   %eax,%eax
c0105156:	74 24                	je     c010517c <check_boot_pgdir+0x192>
c0105158:	c7 44 24 0c 98 70 10 	movl   $0xc0107098,0xc(%esp)
c010515f:	c0 
c0105160:	c7 44 24 08 11 6d 10 	movl   $0xc0106d11,0x8(%esp)
c0105167:	c0 
c0105168:	c7 44 24 04 24 02 00 	movl   $0x224,0x4(%esp)
c010516f:	00 
c0105170:	c7 04 24 ec 6c 10 c0 	movl   $0xc0106cec,(%esp)
c0105177:	e8 86 bb ff ff       	call   c0100d02 <__panic>

    struct Page *p;
    p = alloc_page();
c010517c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105183:	e8 88 ed ff ff       	call   c0103f10 <alloc_pages>
c0105188:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c010518b:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0105190:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0105197:	00 
c0105198:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c010519f:	00 
c01051a0:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01051a3:	89 54 24 04          	mov    %edx,0x4(%esp)
c01051a7:	89 04 24             	mov    %eax,(%esp)
c01051aa:	e8 62 f6 ff ff       	call   c0104811 <page_insert>
c01051af:	85 c0                	test   %eax,%eax
c01051b1:	74 24                	je     c01051d7 <check_boot_pgdir+0x1ed>
c01051b3:	c7 44 24 0c ac 70 10 	movl   $0xc01070ac,0xc(%esp)
c01051ba:	c0 
c01051bb:	c7 44 24 08 11 6d 10 	movl   $0xc0106d11,0x8(%esp)
c01051c2:	c0 
c01051c3:	c7 44 24 04 28 02 00 	movl   $0x228,0x4(%esp)
c01051ca:	00 
c01051cb:	c7 04 24 ec 6c 10 c0 	movl   $0xc0106cec,(%esp)
c01051d2:	e8 2b bb ff ff       	call   c0100d02 <__panic>
    assert(page_ref(p) == 1);
c01051d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01051da:	89 04 24             	mov    %eax,(%esp)
c01051dd:	e8 1e eb ff ff       	call   c0103d00 <page_ref>
c01051e2:	83 f8 01             	cmp    $0x1,%eax
c01051e5:	74 24                	je     c010520b <check_boot_pgdir+0x221>
c01051e7:	c7 44 24 0c da 70 10 	movl   $0xc01070da,0xc(%esp)
c01051ee:	c0 
c01051ef:	c7 44 24 08 11 6d 10 	movl   $0xc0106d11,0x8(%esp)
c01051f6:	c0 
c01051f7:	c7 44 24 04 29 02 00 	movl   $0x229,0x4(%esp)
c01051fe:	00 
c01051ff:	c7 04 24 ec 6c 10 c0 	movl   $0xc0106cec,(%esp)
c0105206:	e8 f7 ba ff ff       	call   c0100d02 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c010520b:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0105210:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0105217:	00 
c0105218:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c010521f:	00 
c0105220:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105223:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105227:	89 04 24             	mov    %eax,(%esp)
c010522a:	e8 e2 f5 ff ff       	call   c0104811 <page_insert>
c010522f:	85 c0                	test   %eax,%eax
c0105231:	74 24                	je     c0105257 <check_boot_pgdir+0x26d>
c0105233:	c7 44 24 0c ec 70 10 	movl   $0xc01070ec,0xc(%esp)
c010523a:	c0 
c010523b:	c7 44 24 08 11 6d 10 	movl   $0xc0106d11,0x8(%esp)
c0105242:	c0 
c0105243:	c7 44 24 04 2a 02 00 	movl   $0x22a,0x4(%esp)
c010524a:	00 
c010524b:	c7 04 24 ec 6c 10 c0 	movl   $0xc0106cec,(%esp)
c0105252:	e8 ab ba ff ff       	call   c0100d02 <__panic>
    assert(page_ref(p) == 2);
c0105257:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010525a:	89 04 24             	mov    %eax,(%esp)
c010525d:	e8 9e ea ff ff       	call   c0103d00 <page_ref>
c0105262:	83 f8 02             	cmp    $0x2,%eax
c0105265:	74 24                	je     c010528b <check_boot_pgdir+0x2a1>
c0105267:	c7 44 24 0c 23 71 10 	movl   $0xc0107123,0xc(%esp)
c010526e:	c0 
c010526f:	c7 44 24 08 11 6d 10 	movl   $0xc0106d11,0x8(%esp)
c0105276:	c0 
c0105277:	c7 44 24 04 2b 02 00 	movl   $0x22b,0x4(%esp)
c010527e:	00 
c010527f:	c7 04 24 ec 6c 10 c0 	movl   $0xc0106cec,(%esp)
c0105286:	e8 77 ba ff ff       	call   c0100d02 <__panic>

    const char *str = "ucore: Hello world!!";
c010528b:	c7 45 e8 34 71 10 c0 	movl   $0xc0107134,-0x18(%ebp)
    strcpy((void *)0x100, str);
c0105292:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105295:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105299:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c01052a0:	e8 fc 09 00 00       	call   c0105ca1 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c01052a5:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c01052ac:	00 
c01052ad:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c01052b4:	e8 60 0a 00 00       	call   c0105d19 <strcmp>
c01052b9:	85 c0                	test   %eax,%eax
c01052bb:	74 24                	je     c01052e1 <check_boot_pgdir+0x2f7>
c01052bd:	c7 44 24 0c 4c 71 10 	movl   $0xc010714c,0xc(%esp)
c01052c4:	c0 
c01052c5:	c7 44 24 08 11 6d 10 	movl   $0xc0106d11,0x8(%esp)
c01052cc:	c0 
c01052cd:	c7 44 24 04 2f 02 00 	movl   $0x22f,0x4(%esp)
c01052d4:	00 
c01052d5:	c7 04 24 ec 6c 10 c0 	movl   $0xc0106cec,(%esp)
c01052dc:	e8 21 ba ff ff       	call   c0100d02 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c01052e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01052e4:	89 04 24             	mov    %eax,(%esp)
c01052e7:	e8 64 e9 ff ff       	call   c0103c50 <page2kva>
c01052ec:	05 00 01 00 00       	add    $0x100,%eax
c01052f1:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c01052f4:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c01052fb:	e8 47 09 00 00       	call   c0105c47 <strlen>
c0105300:	85 c0                	test   %eax,%eax
c0105302:	74 24                	je     c0105328 <check_boot_pgdir+0x33e>
c0105304:	c7 44 24 0c 84 71 10 	movl   $0xc0107184,0xc(%esp)
c010530b:	c0 
c010530c:	c7 44 24 08 11 6d 10 	movl   $0xc0106d11,0x8(%esp)
c0105313:	c0 
c0105314:	c7 44 24 04 32 02 00 	movl   $0x232,0x4(%esp)
c010531b:	00 
c010531c:	c7 04 24 ec 6c 10 c0 	movl   $0xc0106cec,(%esp)
c0105323:	e8 da b9 ff ff       	call   c0100d02 <__panic>

    free_page(p);
c0105328:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010532f:	00 
c0105330:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105333:	89 04 24             	mov    %eax,(%esp)
c0105336:	e8 0f ec ff ff       	call   c0103f4a <free_pages>
    free_page(pde2page(boot_pgdir[0]));
c010533b:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0105340:	8b 00                	mov    (%eax),%eax
c0105342:	89 04 24             	mov    %eax,(%esp)
c0105345:	e8 9c e9 ff ff       	call   c0103ce6 <pde2page>
c010534a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105351:	00 
c0105352:	89 04 24             	mov    %eax,(%esp)
c0105355:	e8 f0 eb ff ff       	call   c0103f4a <free_pages>
    boot_pgdir[0] = 0;
c010535a:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c010535f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c0105365:	c7 04 24 a8 71 10 c0 	movl   $0xc01071a8,(%esp)
c010536c:	e8 f0 af ff ff       	call   c0100361 <cprintf>
}
c0105371:	90                   	nop
c0105372:	89 ec                	mov    %ebp,%esp
c0105374:	5d                   	pop    %ebp
c0105375:	c3                   	ret    

c0105376 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c0105376:	55                   	push   %ebp
c0105377:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c0105379:	8b 45 08             	mov    0x8(%ebp),%eax
c010537c:	83 e0 04             	and    $0x4,%eax
c010537f:	85 c0                	test   %eax,%eax
c0105381:	74 04                	je     c0105387 <perm2str+0x11>
c0105383:	b0 75                	mov    $0x75,%al
c0105385:	eb 02                	jmp    c0105389 <perm2str+0x13>
c0105387:	b0 2d                	mov    $0x2d,%al
c0105389:	a2 28 cf 11 c0       	mov    %al,0xc011cf28
    str[1] = 'r';
c010538e:	c6 05 29 cf 11 c0 72 	movb   $0x72,0xc011cf29
    str[2] = (perm & PTE_W) ? 'w' : '-';
c0105395:	8b 45 08             	mov    0x8(%ebp),%eax
c0105398:	83 e0 02             	and    $0x2,%eax
c010539b:	85 c0                	test   %eax,%eax
c010539d:	74 04                	je     c01053a3 <perm2str+0x2d>
c010539f:	b0 77                	mov    $0x77,%al
c01053a1:	eb 02                	jmp    c01053a5 <perm2str+0x2f>
c01053a3:	b0 2d                	mov    $0x2d,%al
c01053a5:	a2 2a cf 11 c0       	mov    %al,0xc011cf2a
    str[3] = '\0';
c01053aa:	c6 05 2b cf 11 c0 00 	movb   $0x0,0xc011cf2b
    return str;
c01053b1:	b8 28 cf 11 c0       	mov    $0xc011cf28,%eax
}
c01053b6:	5d                   	pop    %ebp
c01053b7:	c3                   	ret    

c01053b8 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c01053b8:	55                   	push   %ebp
c01053b9:	89 e5                	mov    %esp,%ebp
c01053bb:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c01053be:	8b 45 10             	mov    0x10(%ebp),%eax
c01053c1:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01053c4:	72 0d                	jb     c01053d3 <get_pgtable_items+0x1b>
        return 0;
c01053c6:	b8 00 00 00 00       	mov    $0x0,%eax
c01053cb:	e9 98 00 00 00       	jmp    c0105468 <get_pgtable_items+0xb0>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
c01053d0:	ff 45 10             	incl   0x10(%ebp)
    while (start < right && !(table[start] & PTE_P)) {
c01053d3:	8b 45 10             	mov    0x10(%ebp),%eax
c01053d6:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01053d9:	73 18                	jae    c01053f3 <get_pgtable_items+0x3b>
c01053db:	8b 45 10             	mov    0x10(%ebp),%eax
c01053de:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01053e5:	8b 45 14             	mov    0x14(%ebp),%eax
c01053e8:	01 d0                	add    %edx,%eax
c01053ea:	8b 00                	mov    (%eax),%eax
c01053ec:	83 e0 01             	and    $0x1,%eax
c01053ef:	85 c0                	test   %eax,%eax
c01053f1:	74 dd                	je     c01053d0 <get_pgtable_items+0x18>
    }
    if (start < right) {
c01053f3:	8b 45 10             	mov    0x10(%ebp),%eax
c01053f6:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01053f9:	73 68                	jae    c0105463 <get_pgtable_items+0xab>
        if (left_store != NULL) {
c01053fb:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c01053ff:	74 08                	je     c0105409 <get_pgtable_items+0x51>
            *left_store = start;
c0105401:	8b 45 18             	mov    0x18(%ebp),%eax
c0105404:	8b 55 10             	mov    0x10(%ebp),%edx
c0105407:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c0105409:	8b 45 10             	mov    0x10(%ebp),%eax
c010540c:	8d 50 01             	lea    0x1(%eax),%edx
c010540f:	89 55 10             	mov    %edx,0x10(%ebp)
c0105412:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105419:	8b 45 14             	mov    0x14(%ebp),%eax
c010541c:	01 d0                	add    %edx,%eax
c010541e:	8b 00                	mov    (%eax),%eax
c0105420:	83 e0 07             	and    $0x7,%eax
c0105423:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0105426:	eb 03                	jmp    c010542b <get_pgtable_items+0x73>
            start ++;
c0105428:	ff 45 10             	incl   0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c010542b:	8b 45 10             	mov    0x10(%ebp),%eax
c010542e:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105431:	73 1d                	jae    c0105450 <get_pgtable_items+0x98>
c0105433:	8b 45 10             	mov    0x10(%ebp),%eax
c0105436:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010543d:	8b 45 14             	mov    0x14(%ebp),%eax
c0105440:	01 d0                	add    %edx,%eax
c0105442:	8b 00                	mov    (%eax),%eax
c0105444:	83 e0 07             	and    $0x7,%eax
c0105447:	89 c2                	mov    %eax,%edx
c0105449:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010544c:	39 c2                	cmp    %eax,%edx
c010544e:	74 d8                	je     c0105428 <get_pgtable_items+0x70>
        }
        if (right_store != NULL) {
c0105450:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0105454:	74 08                	je     c010545e <get_pgtable_items+0xa6>
            *right_store = start;
c0105456:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0105459:	8b 55 10             	mov    0x10(%ebp),%edx
c010545c:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c010545e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105461:	eb 05                	jmp    c0105468 <get_pgtable_items+0xb0>
    }
    return 0;
c0105463:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105468:	89 ec                	mov    %ebp,%esp
c010546a:	5d                   	pop    %ebp
c010546b:	c3                   	ret    

c010546c <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c010546c:	55                   	push   %ebp
c010546d:	89 e5                	mov    %esp,%ebp
c010546f:	57                   	push   %edi
c0105470:	56                   	push   %esi
c0105471:	53                   	push   %ebx
c0105472:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c0105475:	c7 04 24 c8 71 10 c0 	movl   $0xc01071c8,(%esp)
c010547c:	e8 e0 ae ff ff       	call   c0100361 <cprintf>
    size_t left, right = 0, perm;
c0105481:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0105488:	e9 f2 00 00 00       	jmp    c010557f <print_pgdir+0x113>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c010548d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105490:	89 04 24             	mov    %eax,(%esp)
c0105493:	e8 de fe ff ff       	call   c0105376 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0105498:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010549b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c010549e:	29 ca                	sub    %ecx,%edx
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c01054a0:	89 d6                	mov    %edx,%esi
c01054a2:	c1 e6 16             	shl    $0x16,%esi
c01054a5:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01054a8:	89 d3                	mov    %edx,%ebx
c01054aa:	c1 e3 16             	shl    $0x16,%ebx
c01054ad:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01054b0:	89 d1                	mov    %edx,%ecx
c01054b2:	c1 e1 16             	shl    $0x16,%ecx
c01054b5:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01054b8:	8b 7d e0             	mov    -0x20(%ebp),%edi
c01054bb:	29 fa                	sub    %edi,%edx
c01054bd:	89 44 24 14          	mov    %eax,0x14(%esp)
c01054c1:	89 74 24 10          	mov    %esi,0x10(%esp)
c01054c5:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01054c9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01054cd:	89 54 24 04          	mov    %edx,0x4(%esp)
c01054d1:	c7 04 24 f9 71 10 c0 	movl   $0xc01071f9,(%esp)
c01054d8:	e8 84 ae ff ff       	call   c0100361 <cprintf>
        size_t l, r = left * NPTEENTRY;
c01054dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01054e0:	c1 e0 0a             	shl    $0xa,%eax
c01054e3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c01054e6:	eb 50                	jmp    c0105538 <print_pgdir+0xcc>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c01054e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01054eb:	89 04 24             	mov    %eax,(%esp)
c01054ee:	e8 83 fe ff ff       	call   c0105376 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c01054f3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01054f6:	8b 4d d8             	mov    -0x28(%ebp),%ecx
c01054f9:	29 ca                	sub    %ecx,%edx
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c01054fb:	89 d6                	mov    %edx,%esi
c01054fd:	c1 e6 0c             	shl    $0xc,%esi
c0105500:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105503:	89 d3                	mov    %edx,%ebx
c0105505:	c1 e3 0c             	shl    $0xc,%ebx
c0105508:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010550b:	89 d1                	mov    %edx,%ecx
c010550d:	c1 e1 0c             	shl    $0xc,%ecx
c0105510:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105513:	8b 7d d8             	mov    -0x28(%ebp),%edi
c0105516:	29 fa                	sub    %edi,%edx
c0105518:	89 44 24 14          	mov    %eax,0x14(%esp)
c010551c:	89 74 24 10          	mov    %esi,0x10(%esp)
c0105520:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105524:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0105528:	89 54 24 04          	mov    %edx,0x4(%esp)
c010552c:	c7 04 24 18 72 10 c0 	movl   $0xc0107218,(%esp)
c0105533:	e8 29 ae ff ff       	call   c0100361 <cprintf>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0105538:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
c010553d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0105540:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105543:	89 d3                	mov    %edx,%ebx
c0105545:	c1 e3 0a             	shl    $0xa,%ebx
c0105548:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010554b:	89 d1                	mov    %edx,%ecx
c010554d:	c1 e1 0a             	shl    $0xa,%ecx
c0105550:	8d 55 d4             	lea    -0x2c(%ebp),%edx
c0105553:	89 54 24 14          	mov    %edx,0x14(%esp)
c0105557:	8d 55 d8             	lea    -0x28(%ebp),%edx
c010555a:	89 54 24 10          	mov    %edx,0x10(%esp)
c010555e:	89 74 24 0c          	mov    %esi,0xc(%esp)
c0105562:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105566:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c010556a:	89 0c 24             	mov    %ecx,(%esp)
c010556d:	e8 46 fe ff ff       	call   c01053b8 <get_pgtable_items>
c0105572:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105575:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105579:	0f 85 69 ff ff ff    	jne    c01054e8 <print_pgdir+0x7c>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c010557f:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
c0105584:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105587:	8d 55 dc             	lea    -0x24(%ebp),%edx
c010558a:	89 54 24 14          	mov    %edx,0x14(%esp)
c010558e:	8d 55 e0             	lea    -0x20(%ebp),%edx
c0105591:	89 54 24 10          	mov    %edx,0x10(%esp)
c0105595:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0105599:	89 44 24 08          	mov    %eax,0x8(%esp)
c010559d:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c01055a4:	00 
c01055a5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01055ac:	e8 07 fe ff ff       	call   c01053b8 <get_pgtable_items>
c01055b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01055b4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01055b8:	0f 85 cf fe ff ff    	jne    c010548d <print_pgdir+0x21>
        }
    }
    cprintf("--------------------- END ---------------------\n");
c01055be:	c7 04 24 3c 72 10 c0 	movl   $0xc010723c,(%esp)
c01055c5:	e8 97 ad ff ff       	call   c0100361 <cprintf>
}
c01055ca:	90                   	nop
c01055cb:	83 c4 4c             	add    $0x4c,%esp
c01055ce:	5b                   	pop    %ebx
c01055cf:	5e                   	pop    %esi
c01055d0:	5f                   	pop    %edi
c01055d1:	5d                   	pop    %ebp
c01055d2:	c3                   	ret    

c01055d3 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c01055d3:	55                   	push   %ebp
c01055d4:	89 e5                	mov    %esp,%ebp
c01055d6:	83 ec 58             	sub    $0x58,%esp
c01055d9:	8b 45 10             	mov    0x10(%ebp),%eax
c01055dc:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01055df:	8b 45 14             	mov    0x14(%ebp),%eax
c01055e2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c01055e5:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01055e8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01055eb:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01055ee:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c01055f1:	8b 45 18             	mov    0x18(%ebp),%eax
c01055f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01055f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01055fa:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01055fd:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105600:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0105603:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105606:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105609:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010560d:	74 1c                	je     c010562b <printnum+0x58>
c010560f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105612:	ba 00 00 00 00       	mov    $0x0,%edx
c0105617:	f7 75 e4             	divl   -0x1c(%ebp)
c010561a:	89 55 f4             	mov    %edx,-0xc(%ebp)
c010561d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105620:	ba 00 00 00 00       	mov    $0x0,%edx
c0105625:	f7 75 e4             	divl   -0x1c(%ebp)
c0105628:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010562b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010562e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105631:	f7 75 e4             	divl   -0x1c(%ebp)
c0105634:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105637:	89 55 dc             	mov    %edx,-0x24(%ebp)
c010563a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010563d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105640:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105643:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0105646:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105649:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c010564c:	8b 45 18             	mov    0x18(%ebp),%eax
c010564f:	ba 00 00 00 00       	mov    $0x0,%edx
c0105654:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0105657:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c010565a:	19 d1                	sbb    %edx,%ecx
c010565c:	72 4c                	jb     c01056aa <printnum+0xd7>
        printnum(putch, putdat, result, base, width - 1, padc);
c010565e:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0105661:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105664:	8b 45 20             	mov    0x20(%ebp),%eax
c0105667:	89 44 24 18          	mov    %eax,0x18(%esp)
c010566b:	89 54 24 14          	mov    %edx,0x14(%esp)
c010566f:	8b 45 18             	mov    0x18(%ebp),%eax
c0105672:	89 44 24 10          	mov    %eax,0x10(%esp)
c0105676:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105679:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010567c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105680:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105684:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105687:	89 44 24 04          	mov    %eax,0x4(%esp)
c010568b:	8b 45 08             	mov    0x8(%ebp),%eax
c010568e:	89 04 24             	mov    %eax,(%esp)
c0105691:	e8 3d ff ff ff       	call   c01055d3 <printnum>
c0105696:	eb 1b                	jmp    c01056b3 <printnum+0xe0>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c0105698:	8b 45 0c             	mov    0xc(%ebp),%eax
c010569b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010569f:	8b 45 20             	mov    0x20(%ebp),%eax
c01056a2:	89 04 24             	mov    %eax,(%esp)
c01056a5:	8b 45 08             	mov    0x8(%ebp),%eax
c01056a8:	ff d0                	call   *%eax
        while (-- width > 0)
c01056aa:	ff 4d 1c             	decl   0x1c(%ebp)
c01056ad:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c01056b1:	7f e5                	jg     c0105698 <printnum+0xc5>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c01056b3:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01056b6:	05 f0 72 10 c0       	add    $0xc01072f0,%eax
c01056bb:	0f b6 00             	movzbl (%eax),%eax
c01056be:	0f be c0             	movsbl %al,%eax
c01056c1:	8b 55 0c             	mov    0xc(%ebp),%edx
c01056c4:	89 54 24 04          	mov    %edx,0x4(%esp)
c01056c8:	89 04 24             	mov    %eax,(%esp)
c01056cb:	8b 45 08             	mov    0x8(%ebp),%eax
c01056ce:	ff d0                	call   *%eax
}
c01056d0:	90                   	nop
c01056d1:	89 ec                	mov    %ebp,%esp
c01056d3:	5d                   	pop    %ebp
c01056d4:	c3                   	ret    

c01056d5 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c01056d5:	55                   	push   %ebp
c01056d6:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c01056d8:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c01056dc:	7e 14                	jle    c01056f2 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c01056de:	8b 45 08             	mov    0x8(%ebp),%eax
c01056e1:	8b 00                	mov    (%eax),%eax
c01056e3:	8d 48 08             	lea    0x8(%eax),%ecx
c01056e6:	8b 55 08             	mov    0x8(%ebp),%edx
c01056e9:	89 0a                	mov    %ecx,(%edx)
c01056eb:	8b 50 04             	mov    0x4(%eax),%edx
c01056ee:	8b 00                	mov    (%eax),%eax
c01056f0:	eb 30                	jmp    c0105722 <getuint+0x4d>
    }
    else if (lflag) {
c01056f2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01056f6:	74 16                	je     c010570e <getuint+0x39>
        return va_arg(*ap, unsigned long);
c01056f8:	8b 45 08             	mov    0x8(%ebp),%eax
c01056fb:	8b 00                	mov    (%eax),%eax
c01056fd:	8d 48 04             	lea    0x4(%eax),%ecx
c0105700:	8b 55 08             	mov    0x8(%ebp),%edx
c0105703:	89 0a                	mov    %ecx,(%edx)
c0105705:	8b 00                	mov    (%eax),%eax
c0105707:	ba 00 00 00 00       	mov    $0x0,%edx
c010570c:	eb 14                	jmp    c0105722 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c010570e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105711:	8b 00                	mov    (%eax),%eax
c0105713:	8d 48 04             	lea    0x4(%eax),%ecx
c0105716:	8b 55 08             	mov    0x8(%ebp),%edx
c0105719:	89 0a                	mov    %ecx,(%edx)
c010571b:	8b 00                	mov    (%eax),%eax
c010571d:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c0105722:	5d                   	pop    %ebp
c0105723:	c3                   	ret    

c0105724 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c0105724:	55                   	push   %ebp
c0105725:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0105727:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c010572b:	7e 14                	jle    c0105741 <getint+0x1d>
        return va_arg(*ap, long long);
c010572d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105730:	8b 00                	mov    (%eax),%eax
c0105732:	8d 48 08             	lea    0x8(%eax),%ecx
c0105735:	8b 55 08             	mov    0x8(%ebp),%edx
c0105738:	89 0a                	mov    %ecx,(%edx)
c010573a:	8b 50 04             	mov    0x4(%eax),%edx
c010573d:	8b 00                	mov    (%eax),%eax
c010573f:	eb 28                	jmp    c0105769 <getint+0x45>
    }
    else if (lflag) {
c0105741:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105745:	74 12                	je     c0105759 <getint+0x35>
        return va_arg(*ap, long);
c0105747:	8b 45 08             	mov    0x8(%ebp),%eax
c010574a:	8b 00                	mov    (%eax),%eax
c010574c:	8d 48 04             	lea    0x4(%eax),%ecx
c010574f:	8b 55 08             	mov    0x8(%ebp),%edx
c0105752:	89 0a                	mov    %ecx,(%edx)
c0105754:	8b 00                	mov    (%eax),%eax
c0105756:	99                   	cltd   
c0105757:	eb 10                	jmp    c0105769 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c0105759:	8b 45 08             	mov    0x8(%ebp),%eax
c010575c:	8b 00                	mov    (%eax),%eax
c010575e:	8d 48 04             	lea    0x4(%eax),%ecx
c0105761:	8b 55 08             	mov    0x8(%ebp),%edx
c0105764:	89 0a                	mov    %ecx,(%edx)
c0105766:	8b 00                	mov    (%eax),%eax
c0105768:	99                   	cltd   
    }
}
c0105769:	5d                   	pop    %ebp
c010576a:	c3                   	ret    

c010576b <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c010576b:	55                   	push   %ebp
c010576c:	89 e5                	mov    %esp,%ebp
c010576e:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c0105771:	8d 45 14             	lea    0x14(%ebp),%eax
c0105774:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c0105777:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010577a:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010577e:	8b 45 10             	mov    0x10(%ebp),%eax
c0105781:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105785:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105788:	89 44 24 04          	mov    %eax,0x4(%esp)
c010578c:	8b 45 08             	mov    0x8(%ebp),%eax
c010578f:	89 04 24             	mov    %eax,(%esp)
c0105792:	e8 05 00 00 00       	call   c010579c <vprintfmt>
    va_end(ap);
}
c0105797:	90                   	nop
c0105798:	89 ec                	mov    %ebp,%esp
c010579a:	5d                   	pop    %ebp
c010579b:	c3                   	ret    

c010579c <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c010579c:	55                   	push   %ebp
c010579d:	89 e5                	mov    %esp,%ebp
c010579f:	56                   	push   %esi
c01057a0:	53                   	push   %ebx
c01057a1:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01057a4:	eb 17                	jmp    c01057bd <vprintfmt+0x21>
            if (ch == '\0') {
c01057a6:	85 db                	test   %ebx,%ebx
c01057a8:	0f 84 bf 03 00 00    	je     c0105b6d <vprintfmt+0x3d1>
                return;
            }
            putch(ch, putdat);
c01057ae:	8b 45 0c             	mov    0xc(%ebp),%eax
c01057b1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057b5:	89 1c 24             	mov    %ebx,(%esp)
c01057b8:	8b 45 08             	mov    0x8(%ebp),%eax
c01057bb:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01057bd:	8b 45 10             	mov    0x10(%ebp),%eax
c01057c0:	8d 50 01             	lea    0x1(%eax),%edx
c01057c3:	89 55 10             	mov    %edx,0x10(%ebp)
c01057c6:	0f b6 00             	movzbl (%eax),%eax
c01057c9:	0f b6 d8             	movzbl %al,%ebx
c01057cc:	83 fb 25             	cmp    $0x25,%ebx
c01057cf:	75 d5                	jne    c01057a6 <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
c01057d1:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c01057d5:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c01057dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01057df:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c01057e2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01057e9:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01057ec:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c01057ef:	8b 45 10             	mov    0x10(%ebp),%eax
c01057f2:	8d 50 01             	lea    0x1(%eax),%edx
c01057f5:	89 55 10             	mov    %edx,0x10(%ebp)
c01057f8:	0f b6 00             	movzbl (%eax),%eax
c01057fb:	0f b6 d8             	movzbl %al,%ebx
c01057fe:	8d 43 dd             	lea    -0x23(%ebx),%eax
c0105801:	83 f8 55             	cmp    $0x55,%eax
c0105804:	0f 87 37 03 00 00    	ja     c0105b41 <vprintfmt+0x3a5>
c010580a:	8b 04 85 14 73 10 c0 	mov    -0x3fef8cec(,%eax,4),%eax
c0105811:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c0105813:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c0105817:	eb d6                	jmp    c01057ef <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c0105819:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c010581d:	eb d0                	jmp    c01057ef <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c010581f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c0105826:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105829:	89 d0                	mov    %edx,%eax
c010582b:	c1 e0 02             	shl    $0x2,%eax
c010582e:	01 d0                	add    %edx,%eax
c0105830:	01 c0                	add    %eax,%eax
c0105832:	01 d8                	add    %ebx,%eax
c0105834:	83 e8 30             	sub    $0x30,%eax
c0105837:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c010583a:	8b 45 10             	mov    0x10(%ebp),%eax
c010583d:	0f b6 00             	movzbl (%eax),%eax
c0105840:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c0105843:	83 fb 2f             	cmp    $0x2f,%ebx
c0105846:	7e 38                	jle    c0105880 <vprintfmt+0xe4>
c0105848:	83 fb 39             	cmp    $0x39,%ebx
c010584b:	7f 33                	jg     c0105880 <vprintfmt+0xe4>
            for (precision = 0; ; ++ fmt) {
c010584d:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
c0105850:	eb d4                	jmp    c0105826 <vprintfmt+0x8a>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
c0105852:	8b 45 14             	mov    0x14(%ebp),%eax
c0105855:	8d 50 04             	lea    0x4(%eax),%edx
c0105858:	89 55 14             	mov    %edx,0x14(%ebp)
c010585b:	8b 00                	mov    (%eax),%eax
c010585d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c0105860:	eb 1f                	jmp    c0105881 <vprintfmt+0xe5>

        case '.':
            if (width < 0)
c0105862:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105866:	79 87                	jns    c01057ef <vprintfmt+0x53>
                width = 0;
c0105868:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c010586f:	e9 7b ff ff ff       	jmp    c01057ef <vprintfmt+0x53>

        case '#':
            altflag = 1;
c0105874:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c010587b:	e9 6f ff ff ff       	jmp    c01057ef <vprintfmt+0x53>
            goto process_precision;
c0105880:	90                   	nop

        process_precision:
            if (width < 0)
c0105881:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105885:	0f 89 64 ff ff ff    	jns    c01057ef <vprintfmt+0x53>
                width = precision, precision = -1;
c010588b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010588e:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105891:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c0105898:	e9 52 ff ff ff       	jmp    c01057ef <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c010589d:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
c01058a0:	e9 4a ff ff ff       	jmp    c01057ef <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c01058a5:	8b 45 14             	mov    0x14(%ebp),%eax
c01058a8:	8d 50 04             	lea    0x4(%eax),%edx
c01058ab:	89 55 14             	mov    %edx,0x14(%ebp)
c01058ae:	8b 00                	mov    (%eax),%eax
c01058b0:	8b 55 0c             	mov    0xc(%ebp),%edx
c01058b3:	89 54 24 04          	mov    %edx,0x4(%esp)
c01058b7:	89 04 24             	mov    %eax,(%esp)
c01058ba:	8b 45 08             	mov    0x8(%ebp),%eax
c01058bd:	ff d0                	call   *%eax
            break;
c01058bf:	e9 a4 02 00 00       	jmp    c0105b68 <vprintfmt+0x3cc>

        // error message
        case 'e':
            err = va_arg(ap, int);
c01058c4:	8b 45 14             	mov    0x14(%ebp),%eax
c01058c7:	8d 50 04             	lea    0x4(%eax),%edx
c01058ca:	89 55 14             	mov    %edx,0x14(%ebp)
c01058cd:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c01058cf:	85 db                	test   %ebx,%ebx
c01058d1:	79 02                	jns    c01058d5 <vprintfmt+0x139>
                err = -err;
c01058d3:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c01058d5:	83 fb 06             	cmp    $0x6,%ebx
c01058d8:	7f 0b                	jg     c01058e5 <vprintfmt+0x149>
c01058da:	8b 34 9d d4 72 10 c0 	mov    -0x3fef8d2c(,%ebx,4),%esi
c01058e1:	85 f6                	test   %esi,%esi
c01058e3:	75 23                	jne    c0105908 <vprintfmt+0x16c>
                printfmt(putch, putdat, "error %d", err);
c01058e5:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01058e9:	c7 44 24 08 01 73 10 	movl   $0xc0107301,0x8(%esp)
c01058f0:	c0 
c01058f1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058f4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058f8:	8b 45 08             	mov    0x8(%ebp),%eax
c01058fb:	89 04 24             	mov    %eax,(%esp)
c01058fe:	e8 68 fe ff ff       	call   c010576b <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c0105903:	e9 60 02 00 00       	jmp    c0105b68 <vprintfmt+0x3cc>
                printfmt(putch, putdat, "%s", p);
c0105908:	89 74 24 0c          	mov    %esi,0xc(%esp)
c010590c:	c7 44 24 08 0a 73 10 	movl   $0xc010730a,0x8(%esp)
c0105913:	c0 
c0105914:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105917:	89 44 24 04          	mov    %eax,0x4(%esp)
c010591b:	8b 45 08             	mov    0x8(%ebp),%eax
c010591e:	89 04 24             	mov    %eax,(%esp)
c0105921:	e8 45 fe ff ff       	call   c010576b <printfmt>
            break;
c0105926:	e9 3d 02 00 00       	jmp    c0105b68 <vprintfmt+0x3cc>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c010592b:	8b 45 14             	mov    0x14(%ebp),%eax
c010592e:	8d 50 04             	lea    0x4(%eax),%edx
c0105931:	89 55 14             	mov    %edx,0x14(%ebp)
c0105934:	8b 30                	mov    (%eax),%esi
c0105936:	85 f6                	test   %esi,%esi
c0105938:	75 05                	jne    c010593f <vprintfmt+0x1a3>
                p = "(null)";
c010593a:	be 0d 73 10 c0       	mov    $0xc010730d,%esi
            }
            if (width > 0 && padc != '-') {
c010593f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105943:	7e 76                	jle    c01059bb <vprintfmt+0x21f>
c0105945:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c0105949:	74 70                	je     c01059bb <vprintfmt+0x21f>
                for (width -= strnlen(p, precision); width > 0; width --) {
c010594b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010594e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105952:	89 34 24             	mov    %esi,(%esp)
c0105955:	e8 16 03 00 00       	call   c0105c70 <strnlen>
c010595a:	89 c2                	mov    %eax,%edx
c010595c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010595f:	29 d0                	sub    %edx,%eax
c0105961:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105964:	eb 16                	jmp    c010597c <vprintfmt+0x1e0>
                    putch(padc, putdat);
c0105966:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c010596a:	8b 55 0c             	mov    0xc(%ebp),%edx
c010596d:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105971:	89 04 24             	mov    %eax,(%esp)
c0105974:	8b 45 08             	mov    0x8(%ebp),%eax
c0105977:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
c0105979:	ff 4d e8             	decl   -0x18(%ebp)
c010597c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105980:	7f e4                	jg     c0105966 <vprintfmt+0x1ca>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0105982:	eb 37                	jmp    c01059bb <vprintfmt+0x21f>
                if (altflag && (ch < ' ' || ch > '~')) {
c0105984:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0105988:	74 1f                	je     c01059a9 <vprintfmt+0x20d>
c010598a:	83 fb 1f             	cmp    $0x1f,%ebx
c010598d:	7e 05                	jle    c0105994 <vprintfmt+0x1f8>
c010598f:	83 fb 7e             	cmp    $0x7e,%ebx
c0105992:	7e 15                	jle    c01059a9 <vprintfmt+0x20d>
                    putch('?', putdat);
c0105994:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105997:	89 44 24 04          	mov    %eax,0x4(%esp)
c010599b:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c01059a2:	8b 45 08             	mov    0x8(%ebp),%eax
c01059a5:	ff d0                	call   *%eax
c01059a7:	eb 0f                	jmp    c01059b8 <vprintfmt+0x21c>
                }
                else {
                    putch(ch, putdat);
c01059a9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059ac:	89 44 24 04          	mov    %eax,0x4(%esp)
c01059b0:	89 1c 24             	mov    %ebx,(%esp)
c01059b3:	8b 45 08             	mov    0x8(%ebp),%eax
c01059b6:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c01059b8:	ff 4d e8             	decl   -0x18(%ebp)
c01059bb:	89 f0                	mov    %esi,%eax
c01059bd:	8d 70 01             	lea    0x1(%eax),%esi
c01059c0:	0f b6 00             	movzbl (%eax),%eax
c01059c3:	0f be d8             	movsbl %al,%ebx
c01059c6:	85 db                	test   %ebx,%ebx
c01059c8:	74 27                	je     c01059f1 <vprintfmt+0x255>
c01059ca:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01059ce:	78 b4                	js     c0105984 <vprintfmt+0x1e8>
c01059d0:	ff 4d e4             	decl   -0x1c(%ebp)
c01059d3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01059d7:	79 ab                	jns    c0105984 <vprintfmt+0x1e8>
                }
            }
            for (; width > 0; width --) {
c01059d9:	eb 16                	jmp    c01059f1 <vprintfmt+0x255>
                putch(' ', putdat);
c01059db:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059de:	89 44 24 04          	mov    %eax,0x4(%esp)
c01059e2:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01059e9:	8b 45 08             	mov    0x8(%ebp),%eax
c01059ec:	ff d0                	call   *%eax
            for (; width > 0; width --) {
c01059ee:	ff 4d e8             	decl   -0x18(%ebp)
c01059f1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01059f5:	7f e4                	jg     c01059db <vprintfmt+0x23f>
            }
            break;
c01059f7:	e9 6c 01 00 00       	jmp    c0105b68 <vprintfmt+0x3cc>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c01059fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01059ff:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a03:	8d 45 14             	lea    0x14(%ebp),%eax
c0105a06:	89 04 24             	mov    %eax,(%esp)
c0105a09:	e8 16 fd ff ff       	call   c0105724 <getint>
c0105a0e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105a11:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c0105a14:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a17:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105a1a:	85 d2                	test   %edx,%edx
c0105a1c:	79 26                	jns    c0105a44 <vprintfmt+0x2a8>
                putch('-', putdat);
c0105a1e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a21:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a25:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c0105a2c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a2f:	ff d0                	call   *%eax
                num = -(long long)num;
c0105a31:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a34:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105a37:	f7 d8                	neg    %eax
c0105a39:	83 d2 00             	adc    $0x0,%edx
c0105a3c:	f7 da                	neg    %edx
c0105a3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105a41:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c0105a44:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105a4b:	e9 a8 00 00 00       	jmp    c0105af8 <vprintfmt+0x35c>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c0105a50:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105a53:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a57:	8d 45 14             	lea    0x14(%ebp),%eax
c0105a5a:	89 04 24             	mov    %eax,(%esp)
c0105a5d:	e8 73 fc ff ff       	call   c01056d5 <getuint>
c0105a62:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105a65:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c0105a68:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105a6f:	e9 84 00 00 00       	jmp    c0105af8 <vprintfmt+0x35c>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c0105a74:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105a77:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a7b:	8d 45 14             	lea    0x14(%ebp),%eax
c0105a7e:	89 04 24             	mov    %eax,(%esp)
c0105a81:	e8 4f fc ff ff       	call   c01056d5 <getuint>
c0105a86:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105a89:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c0105a8c:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c0105a93:	eb 63                	jmp    c0105af8 <vprintfmt+0x35c>

        // pointer
        case 'p':
            putch('0', putdat);
c0105a95:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a98:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a9c:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c0105aa3:	8b 45 08             	mov    0x8(%ebp),%eax
c0105aa6:	ff d0                	call   *%eax
            putch('x', putdat);
c0105aa8:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105aab:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105aaf:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c0105ab6:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ab9:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c0105abb:	8b 45 14             	mov    0x14(%ebp),%eax
c0105abe:	8d 50 04             	lea    0x4(%eax),%edx
c0105ac1:	89 55 14             	mov    %edx,0x14(%ebp)
c0105ac4:	8b 00                	mov    (%eax),%eax
c0105ac6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105ac9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c0105ad0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c0105ad7:	eb 1f                	jmp    c0105af8 <vprintfmt+0x35c>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c0105ad9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105adc:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105ae0:	8d 45 14             	lea    0x14(%ebp),%eax
c0105ae3:	89 04 24             	mov    %eax,(%esp)
c0105ae6:	e8 ea fb ff ff       	call   c01056d5 <getuint>
c0105aeb:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105aee:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c0105af1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c0105af8:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c0105afc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105aff:	89 54 24 18          	mov    %edx,0x18(%esp)
c0105b03:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0105b06:	89 54 24 14          	mov    %edx,0x14(%esp)
c0105b0a:	89 44 24 10          	mov    %eax,0x10(%esp)
c0105b0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105b11:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105b14:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105b18:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105b1c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b1f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105b23:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b26:	89 04 24             	mov    %eax,(%esp)
c0105b29:	e8 a5 fa ff ff       	call   c01055d3 <printnum>
            break;
c0105b2e:	eb 38                	jmp    c0105b68 <vprintfmt+0x3cc>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c0105b30:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b33:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105b37:	89 1c 24             	mov    %ebx,(%esp)
c0105b3a:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b3d:	ff d0                	call   *%eax
            break;
c0105b3f:	eb 27                	jmp    c0105b68 <vprintfmt+0x3cc>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c0105b41:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b44:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105b48:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c0105b4f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b52:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c0105b54:	ff 4d 10             	decl   0x10(%ebp)
c0105b57:	eb 03                	jmp    c0105b5c <vprintfmt+0x3c0>
c0105b59:	ff 4d 10             	decl   0x10(%ebp)
c0105b5c:	8b 45 10             	mov    0x10(%ebp),%eax
c0105b5f:	48                   	dec    %eax
c0105b60:	0f b6 00             	movzbl (%eax),%eax
c0105b63:	3c 25                	cmp    $0x25,%al
c0105b65:	75 f2                	jne    c0105b59 <vprintfmt+0x3bd>
                /* do nothing */;
            break;
c0105b67:	90                   	nop
    while (1) {
c0105b68:	e9 37 fc ff ff       	jmp    c01057a4 <vprintfmt+0x8>
                return;
c0105b6d:	90                   	nop
        }
    }
}
c0105b6e:	83 c4 40             	add    $0x40,%esp
c0105b71:	5b                   	pop    %ebx
c0105b72:	5e                   	pop    %esi
c0105b73:	5d                   	pop    %ebp
c0105b74:	c3                   	ret    

c0105b75 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0105b75:	55                   	push   %ebp
c0105b76:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c0105b78:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b7b:	8b 40 08             	mov    0x8(%eax),%eax
c0105b7e:	8d 50 01             	lea    0x1(%eax),%edx
c0105b81:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b84:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c0105b87:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b8a:	8b 10                	mov    (%eax),%edx
c0105b8c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b8f:	8b 40 04             	mov    0x4(%eax),%eax
c0105b92:	39 c2                	cmp    %eax,%edx
c0105b94:	73 12                	jae    c0105ba8 <sprintputch+0x33>
        *b->buf ++ = ch;
c0105b96:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b99:	8b 00                	mov    (%eax),%eax
c0105b9b:	8d 48 01             	lea    0x1(%eax),%ecx
c0105b9e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105ba1:	89 0a                	mov    %ecx,(%edx)
c0105ba3:	8b 55 08             	mov    0x8(%ebp),%edx
c0105ba6:	88 10                	mov    %dl,(%eax)
    }
}
c0105ba8:	90                   	nop
c0105ba9:	5d                   	pop    %ebp
c0105baa:	c3                   	ret    

c0105bab <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0105bab:	55                   	push   %ebp
c0105bac:	89 e5                	mov    %esp,%ebp
c0105bae:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0105bb1:	8d 45 14             	lea    0x14(%ebp),%eax
c0105bb4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c0105bb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105bba:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105bbe:	8b 45 10             	mov    0x10(%ebp),%eax
c0105bc1:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105bc5:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105bc8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105bcc:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bcf:	89 04 24             	mov    %eax,(%esp)
c0105bd2:	e8 0a 00 00 00       	call   c0105be1 <vsnprintf>
c0105bd7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0105bda:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105bdd:	89 ec                	mov    %ebp,%esp
c0105bdf:	5d                   	pop    %ebp
c0105be0:	c3                   	ret    

c0105be1 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0105be1:	55                   	push   %ebp
c0105be2:	89 e5                	mov    %esp,%ebp
c0105be4:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0105be7:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bea:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105bed:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105bf0:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105bf3:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bf6:	01 d0                	add    %edx,%eax
c0105bf8:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105bfb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0105c02:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105c06:	74 0a                	je     c0105c12 <vsnprintf+0x31>
c0105c08:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105c0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105c0e:	39 c2                	cmp    %eax,%edx
c0105c10:	76 07                	jbe    c0105c19 <vsnprintf+0x38>
        return -E_INVAL;
c0105c12:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0105c17:	eb 2a                	jmp    c0105c43 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0105c19:	8b 45 14             	mov    0x14(%ebp),%eax
c0105c1c:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105c20:	8b 45 10             	mov    0x10(%ebp),%eax
c0105c23:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105c27:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0105c2a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105c2e:	c7 04 24 75 5b 10 c0 	movl   $0xc0105b75,(%esp)
c0105c35:	e8 62 fb ff ff       	call   c010579c <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c0105c3a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105c3d:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0105c40:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105c43:	89 ec                	mov    %ebp,%esp
c0105c45:	5d                   	pop    %ebp
c0105c46:	c3                   	ret    

c0105c47 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c0105c47:	55                   	push   %ebp
c0105c48:	89 e5                	mov    %esp,%ebp
c0105c4a:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105c4d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c0105c54:	eb 03                	jmp    c0105c59 <strlen+0x12>
        cnt ++;
c0105c56:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
c0105c59:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c5c:	8d 50 01             	lea    0x1(%eax),%edx
c0105c5f:	89 55 08             	mov    %edx,0x8(%ebp)
c0105c62:	0f b6 00             	movzbl (%eax),%eax
c0105c65:	84 c0                	test   %al,%al
c0105c67:	75 ed                	jne    c0105c56 <strlen+0xf>
    }
    return cnt;
c0105c69:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105c6c:	89 ec                	mov    %ebp,%esp
c0105c6e:	5d                   	pop    %ebp
c0105c6f:	c3                   	ret    

c0105c70 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c0105c70:	55                   	push   %ebp
c0105c71:	89 e5                	mov    %esp,%ebp
c0105c73:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105c76:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0105c7d:	eb 03                	jmp    c0105c82 <strnlen+0x12>
        cnt ++;
c0105c7f:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0105c82:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105c85:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105c88:	73 10                	jae    c0105c9a <strnlen+0x2a>
c0105c8a:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c8d:	8d 50 01             	lea    0x1(%eax),%edx
c0105c90:	89 55 08             	mov    %edx,0x8(%ebp)
c0105c93:	0f b6 00             	movzbl (%eax),%eax
c0105c96:	84 c0                	test   %al,%al
c0105c98:	75 e5                	jne    c0105c7f <strnlen+0xf>
    }
    return cnt;
c0105c9a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105c9d:	89 ec                	mov    %ebp,%esp
c0105c9f:	5d                   	pop    %ebp
c0105ca0:	c3                   	ret    

c0105ca1 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c0105ca1:	55                   	push   %ebp
c0105ca2:	89 e5                	mov    %esp,%ebp
c0105ca4:	57                   	push   %edi
c0105ca5:	56                   	push   %esi
c0105ca6:	83 ec 20             	sub    $0x20,%esp
c0105ca9:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cac:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105caf:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105cb2:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c0105cb5:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105cb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105cbb:	89 d1                	mov    %edx,%ecx
c0105cbd:	89 c2                	mov    %eax,%edx
c0105cbf:	89 ce                	mov    %ecx,%esi
c0105cc1:	89 d7                	mov    %edx,%edi
c0105cc3:	ac                   	lods   %ds:(%esi),%al
c0105cc4:	aa                   	stos   %al,%es:(%edi)
c0105cc5:	84 c0                	test   %al,%al
c0105cc7:	75 fa                	jne    c0105cc3 <strcpy+0x22>
c0105cc9:	89 fa                	mov    %edi,%edx
c0105ccb:	89 f1                	mov    %esi,%ecx
c0105ccd:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105cd0:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0105cd3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c0105cd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0105cd9:	83 c4 20             	add    $0x20,%esp
c0105cdc:	5e                   	pop    %esi
c0105cdd:	5f                   	pop    %edi
c0105cde:	5d                   	pop    %ebp
c0105cdf:	c3                   	ret    

c0105ce0 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c0105ce0:	55                   	push   %ebp
c0105ce1:	89 e5                	mov    %esp,%ebp
c0105ce3:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0105ce6:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ce9:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c0105cec:	eb 1e                	jmp    c0105d0c <strncpy+0x2c>
        if ((*p = *src) != '\0') {
c0105cee:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105cf1:	0f b6 10             	movzbl (%eax),%edx
c0105cf4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105cf7:	88 10                	mov    %dl,(%eax)
c0105cf9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105cfc:	0f b6 00             	movzbl (%eax),%eax
c0105cff:	84 c0                	test   %al,%al
c0105d01:	74 03                	je     c0105d06 <strncpy+0x26>
            src ++;
c0105d03:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
c0105d06:	ff 45 fc             	incl   -0x4(%ebp)
c0105d09:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
c0105d0c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105d10:	75 dc                	jne    c0105cee <strncpy+0xe>
    }
    return dst;
c0105d12:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105d15:	89 ec                	mov    %ebp,%esp
c0105d17:	5d                   	pop    %ebp
c0105d18:	c3                   	ret    

c0105d19 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0105d19:	55                   	push   %ebp
c0105d1a:	89 e5                	mov    %esp,%ebp
c0105d1c:	57                   	push   %edi
c0105d1d:	56                   	push   %esi
c0105d1e:	83 ec 20             	sub    $0x20,%esp
c0105d21:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d24:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105d27:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
c0105d2d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105d30:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105d33:	89 d1                	mov    %edx,%ecx
c0105d35:	89 c2                	mov    %eax,%edx
c0105d37:	89 ce                	mov    %ecx,%esi
c0105d39:	89 d7                	mov    %edx,%edi
c0105d3b:	ac                   	lods   %ds:(%esi),%al
c0105d3c:	ae                   	scas   %es:(%edi),%al
c0105d3d:	75 08                	jne    c0105d47 <strcmp+0x2e>
c0105d3f:	84 c0                	test   %al,%al
c0105d41:	75 f8                	jne    c0105d3b <strcmp+0x22>
c0105d43:	31 c0                	xor    %eax,%eax
c0105d45:	eb 04                	jmp    c0105d4b <strcmp+0x32>
c0105d47:	19 c0                	sbb    %eax,%eax
c0105d49:	0c 01                	or     $0x1,%al
c0105d4b:	89 fa                	mov    %edi,%edx
c0105d4d:	89 f1                	mov    %esi,%ecx
c0105d4f:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105d52:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105d55:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
c0105d58:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0105d5b:	83 c4 20             	add    $0x20,%esp
c0105d5e:	5e                   	pop    %esi
c0105d5f:	5f                   	pop    %edi
c0105d60:	5d                   	pop    %ebp
c0105d61:	c3                   	ret    

c0105d62 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c0105d62:	55                   	push   %ebp
c0105d63:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105d65:	eb 09                	jmp    c0105d70 <strncmp+0xe>
        n --, s1 ++, s2 ++;
c0105d67:	ff 4d 10             	decl   0x10(%ebp)
c0105d6a:	ff 45 08             	incl   0x8(%ebp)
c0105d6d:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105d70:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105d74:	74 1a                	je     c0105d90 <strncmp+0x2e>
c0105d76:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d79:	0f b6 00             	movzbl (%eax),%eax
c0105d7c:	84 c0                	test   %al,%al
c0105d7e:	74 10                	je     c0105d90 <strncmp+0x2e>
c0105d80:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d83:	0f b6 10             	movzbl (%eax),%edx
c0105d86:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d89:	0f b6 00             	movzbl (%eax),%eax
c0105d8c:	38 c2                	cmp    %al,%dl
c0105d8e:	74 d7                	je     c0105d67 <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105d90:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105d94:	74 18                	je     c0105dae <strncmp+0x4c>
c0105d96:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d99:	0f b6 00             	movzbl (%eax),%eax
c0105d9c:	0f b6 d0             	movzbl %al,%edx
c0105d9f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105da2:	0f b6 00             	movzbl (%eax),%eax
c0105da5:	0f b6 c8             	movzbl %al,%ecx
c0105da8:	89 d0                	mov    %edx,%eax
c0105daa:	29 c8                	sub    %ecx,%eax
c0105dac:	eb 05                	jmp    c0105db3 <strncmp+0x51>
c0105dae:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105db3:	5d                   	pop    %ebp
c0105db4:	c3                   	ret    

c0105db5 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0105db5:	55                   	push   %ebp
c0105db6:	89 e5                	mov    %esp,%ebp
c0105db8:	83 ec 04             	sub    $0x4,%esp
c0105dbb:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105dbe:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105dc1:	eb 13                	jmp    c0105dd6 <strchr+0x21>
        if (*s == c) {
c0105dc3:	8b 45 08             	mov    0x8(%ebp),%eax
c0105dc6:	0f b6 00             	movzbl (%eax),%eax
c0105dc9:	38 45 fc             	cmp    %al,-0x4(%ebp)
c0105dcc:	75 05                	jne    c0105dd3 <strchr+0x1e>
            return (char *)s;
c0105dce:	8b 45 08             	mov    0x8(%ebp),%eax
c0105dd1:	eb 12                	jmp    c0105de5 <strchr+0x30>
        }
        s ++;
c0105dd3:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
c0105dd6:	8b 45 08             	mov    0x8(%ebp),%eax
c0105dd9:	0f b6 00             	movzbl (%eax),%eax
c0105ddc:	84 c0                	test   %al,%al
c0105dde:	75 e3                	jne    c0105dc3 <strchr+0xe>
    }
    return NULL;
c0105de0:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105de5:	89 ec                	mov    %ebp,%esp
c0105de7:	5d                   	pop    %ebp
c0105de8:	c3                   	ret    

c0105de9 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0105de9:	55                   	push   %ebp
c0105dea:	89 e5                	mov    %esp,%ebp
c0105dec:	83 ec 04             	sub    $0x4,%esp
c0105def:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105df2:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105df5:	eb 0e                	jmp    c0105e05 <strfind+0x1c>
        if (*s == c) {
c0105df7:	8b 45 08             	mov    0x8(%ebp),%eax
c0105dfa:	0f b6 00             	movzbl (%eax),%eax
c0105dfd:	38 45 fc             	cmp    %al,-0x4(%ebp)
c0105e00:	74 0f                	je     c0105e11 <strfind+0x28>
            break;
        }
        s ++;
c0105e02:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
c0105e05:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e08:	0f b6 00             	movzbl (%eax),%eax
c0105e0b:	84 c0                	test   %al,%al
c0105e0d:	75 e8                	jne    c0105df7 <strfind+0xe>
c0105e0f:	eb 01                	jmp    c0105e12 <strfind+0x29>
            break;
c0105e11:	90                   	nop
    }
    return (char *)s;
c0105e12:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105e15:	89 ec                	mov    %ebp,%esp
c0105e17:	5d                   	pop    %ebp
c0105e18:	c3                   	ret    

c0105e19 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c0105e19:	55                   	push   %ebp
c0105e1a:	89 e5                	mov    %esp,%ebp
c0105e1c:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0105e1f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0105e26:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105e2d:	eb 03                	jmp    c0105e32 <strtol+0x19>
        s ++;
c0105e2f:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
c0105e32:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e35:	0f b6 00             	movzbl (%eax),%eax
c0105e38:	3c 20                	cmp    $0x20,%al
c0105e3a:	74 f3                	je     c0105e2f <strtol+0x16>
c0105e3c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e3f:	0f b6 00             	movzbl (%eax),%eax
c0105e42:	3c 09                	cmp    $0x9,%al
c0105e44:	74 e9                	je     c0105e2f <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
c0105e46:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e49:	0f b6 00             	movzbl (%eax),%eax
c0105e4c:	3c 2b                	cmp    $0x2b,%al
c0105e4e:	75 05                	jne    c0105e55 <strtol+0x3c>
        s ++;
c0105e50:	ff 45 08             	incl   0x8(%ebp)
c0105e53:	eb 14                	jmp    c0105e69 <strtol+0x50>
    }
    else if (*s == '-') {
c0105e55:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e58:	0f b6 00             	movzbl (%eax),%eax
c0105e5b:	3c 2d                	cmp    $0x2d,%al
c0105e5d:	75 0a                	jne    c0105e69 <strtol+0x50>
        s ++, neg = 1;
c0105e5f:	ff 45 08             	incl   0x8(%ebp)
c0105e62:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0105e69:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105e6d:	74 06                	je     c0105e75 <strtol+0x5c>
c0105e6f:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0105e73:	75 22                	jne    c0105e97 <strtol+0x7e>
c0105e75:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e78:	0f b6 00             	movzbl (%eax),%eax
c0105e7b:	3c 30                	cmp    $0x30,%al
c0105e7d:	75 18                	jne    c0105e97 <strtol+0x7e>
c0105e7f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e82:	40                   	inc    %eax
c0105e83:	0f b6 00             	movzbl (%eax),%eax
c0105e86:	3c 78                	cmp    $0x78,%al
c0105e88:	75 0d                	jne    c0105e97 <strtol+0x7e>
        s += 2, base = 16;
c0105e8a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0105e8e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0105e95:	eb 29                	jmp    c0105ec0 <strtol+0xa7>
    }
    else if (base == 0 && s[0] == '0') {
c0105e97:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105e9b:	75 16                	jne    c0105eb3 <strtol+0x9a>
c0105e9d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ea0:	0f b6 00             	movzbl (%eax),%eax
c0105ea3:	3c 30                	cmp    $0x30,%al
c0105ea5:	75 0c                	jne    c0105eb3 <strtol+0x9a>
        s ++, base = 8;
c0105ea7:	ff 45 08             	incl   0x8(%ebp)
c0105eaa:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0105eb1:	eb 0d                	jmp    c0105ec0 <strtol+0xa7>
    }
    else if (base == 0) {
c0105eb3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105eb7:	75 07                	jne    c0105ec0 <strtol+0xa7>
        base = 10;
c0105eb9:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0105ec0:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ec3:	0f b6 00             	movzbl (%eax),%eax
c0105ec6:	3c 2f                	cmp    $0x2f,%al
c0105ec8:	7e 1b                	jle    c0105ee5 <strtol+0xcc>
c0105eca:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ecd:	0f b6 00             	movzbl (%eax),%eax
c0105ed0:	3c 39                	cmp    $0x39,%al
c0105ed2:	7f 11                	jg     c0105ee5 <strtol+0xcc>
            dig = *s - '0';
c0105ed4:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ed7:	0f b6 00             	movzbl (%eax),%eax
c0105eda:	0f be c0             	movsbl %al,%eax
c0105edd:	83 e8 30             	sub    $0x30,%eax
c0105ee0:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105ee3:	eb 48                	jmp    c0105f2d <strtol+0x114>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0105ee5:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ee8:	0f b6 00             	movzbl (%eax),%eax
c0105eeb:	3c 60                	cmp    $0x60,%al
c0105eed:	7e 1b                	jle    c0105f0a <strtol+0xf1>
c0105eef:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ef2:	0f b6 00             	movzbl (%eax),%eax
c0105ef5:	3c 7a                	cmp    $0x7a,%al
c0105ef7:	7f 11                	jg     c0105f0a <strtol+0xf1>
            dig = *s - 'a' + 10;
c0105ef9:	8b 45 08             	mov    0x8(%ebp),%eax
c0105efc:	0f b6 00             	movzbl (%eax),%eax
c0105eff:	0f be c0             	movsbl %al,%eax
c0105f02:	83 e8 57             	sub    $0x57,%eax
c0105f05:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105f08:	eb 23                	jmp    c0105f2d <strtol+0x114>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0105f0a:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f0d:	0f b6 00             	movzbl (%eax),%eax
c0105f10:	3c 40                	cmp    $0x40,%al
c0105f12:	7e 3b                	jle    c0105f4f <strtol+0x136>
c0105f14:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f17:	0f b6 00             	movzbl (%eax),%eax
c0105f1a:	3c 5a                	cmp    $0x5a,%al
c0105f1c:	7f 31                	jg     c0105f4f <strtol+0x136>
            dig = *s - 'A' + 10;
c0105f1e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f21:	0f b6 00             	movzbl (%eax),%eax
c0105f24:	0f be c0             	movsbl %al,%eax
c0105f27:	83 e8 37             	sub    $0x37,%eax
c0105f2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0105f2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105f30:	3b 45 10             	cmp    0x10(%ebp),%eax
c0105f33:	7d 19                	jge    c0105f4e <strtol+0x135>
            break;
        }
        s ++, val = (val * base) + dig;
c0105f35:	ff 45 08             	incl   0x8(%ebp)
c0105f38:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105f3b:	0f af 45 10          	imul   0x10(%ebp),%eax
c0105f3f:	89 c2                	mov    %eax,%edx
c0105f41:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105f44:	01 d0                	add    %edx,%eax
c0105f46:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
c0105f49:	e9 72 ff ff ff       	jmp    c0105ec0 <strtol+0xa7>
            break;
c0105f4e:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
c0105f4f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105f53:	74 08                	je     c0105f5d <strtol+0x144>
        *endptr = (char *) s;
c0105f55:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105f58:	8b 55 08             	mov    0x8(%ebp),%edx
c0105f5b:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0105f5d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0105f61:	74 07                	je     c0105f6a <strtol+0x151>
c0105f63:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105f66:	f7 d8                	neg    %eax
c0105f68:	eb 03                	jmp    c0105f6d <strtol+0x154>
c0105f6a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0105f6d:	89 ec                	mov    %ebp,%esp
c0105f6f:	5d                   	pop    %ebp
c0105f70:	c3                   	ret    

c0105f71 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0105f71:	55                   	push   %ebp
c0105f72:	89 e5                	mov    %esp,%ebp
c0105f74:	83 ec 28             	sub    $0x28,%esp
c0105f77:	89 7d fc             	mov    %edi,-0x4(%ebp)
c0105f7a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105f7d:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0105f80:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
c0105f84:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f87:	89 45 f8             	mov    %eax,-0x8(%ebp)
c0105f8a:	88 55 f7             	mov    %dl,-0x9(%ebp)
c0105f8d:	8b 45 10             	mov    0x10(%ebp),%eax
c0105f90:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0105f93:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0105f96:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0105f9a:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0105f9d:	89 d7                	mov    %edx,%edi
c0105f9f:	f3 aa                	rep stos %al,%es:(%edi)
c0105fa1:	89 fa                	mov    %edi,%edx
c0105fa3:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105fa6:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0105fa9:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0105fac:	8b 7d fc             	mov    -0x4(%ebp),%edi
c0105faf:	89 ec                	mov    %ebp,%esp
c0105fb1:	5d                   	pop    %ebp
c0105fb2:	c3                   	ret    

c0105fb3 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0105fb3:	55                   	push   %ebp
c0105fb4:	89 e5                	mov    %esp,%ebp
c0105fb6:	57                   	push   %edi
c0105fb7:	56                   	push   %esi
c0105fb8:	53                   	push   %ebx
c0105fb9:	83 ec 30             	sub    $0x30,%esp
c0105fbc:	8b 45 08             	mov    0x8(%ebp),%eax
c0105fbf:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105fc2:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105fc5:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105fc8:	8b 45 10             	mov    0x10(%ebp),%eax
c0105fcb:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0105fce:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105fd1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0105fd4:	73 42                	jae    c0106018 <memmove+0x65>
c0105fd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105fd9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105fdc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105fdf:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105fe2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105fe5:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105fe8:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105feb:	c1 e8 02             	shr    $0x2,%eax
c0105fee:	89 c1                	mov    %eax,%ecx
    asm volatile (
c0105ff0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105ff3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105ff6:	89 d7                	mov    %edx,%edi
c0105ff8:	89 c6                	mov    %eax,%esi
c0105ffa:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105ffc:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105fff:	83 e1 03             	and    $0x3,%ecx
c0106002:	74 02                	je     c0106006 <memmove+0x53>
c0106004:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0106006:	89 f0                	mov    %esi,%eax
c0106008:	89 fa                	mov    %edi,%edx
c010600a:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c010600d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0106010:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
c0106013:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        return __memcpy(dst, src, n);
c0106016:	eb 36                	jmp    c010604e <memmove+0x9b>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c0106018:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010601b:	8d 50 ff             	lea    -0x1(%eax),%edx
c010601e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106021:	01 c2                	add    %eax,%edx
c0106023:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106026:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0106029:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010602c:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
c010602f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106032:	89 c1                	mov    %eax,%ecx
c0106034:	89 d8                	mov    %ebx,%eax
c0106036:	89 d6                	mov    %edx,%esi
c0106038:	89 c7                	mov    %eax,%edi
c010603a:	fd                   	std    
c010603b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c010603d:	fc                   	cld    
c010603e:	89 f8                	mov    %edi,%eax
c0106040:	89 f2                	mov    %esi,%edx
c0106042:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0106045:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0106048:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
c010604b:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c010604e:	83 c4 30             	add    $0x30,%esp
c0106051:	5b                   	pop    %ebx
c0106052:	5e                   	pop    %esi
c0106053:	5f                   	pop    %edi
c0106054:	5d                   	pop    %ebp
c0106055:	c3                   	ret    

c0106056 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0106056:	55                   	push   %ebp
c0106057:	89 e5                	mov    %esp,%ebp
c0106059:	57                   	push   %edi
c010605a:	56                   	push   %esi
c010605b:	83 ec 20             	sub    $0x20,%esp
c010605e:	8b 45 08             	mov    0x8(%ebp),%eax
c0106061:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0106064:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106067:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010606a:	8b 45 10             	mov    0x10(%ebp),%eax
c010606d:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0106070:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106073:	c1 e8 02             	shr    $0x2,%eax
c0106076:	89 c1                	mov    %eax,%ecx
    asm volatile (
c0106078:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010607b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010607e:	89 d7                	mov    %edx,%edi
c0106080:	89 c6                	mov    %eax,%esi
c0106082:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0106084:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0106087:	83 e1 03             	and    $0x3,%ecx
c010608a:	74 02                	je     c010608e <memcpy+0x38>
c010608c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c010608e:	89 f0                	mov    %esi,%eax
c0106090:	89 fa                	mov    %edi,%edx
c0106092:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0106095:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0106098:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
c010609b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c010609e:	83 c4 20             	add    $0x20,%esp
c01060a1:	5e                   	pop    %esi
c01060a2:	5f                   	pop    %edi
c01060a3:	5d                   	pop    %ebp
c01060a4:	c3                   	ret    

c01060a5 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c01060a5:	55                   	push   %ebp
c01060a6:	89 e5                	mov    %esp,%ebp
c01060a8:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c01060ab:	8b 45 08             	mov    0x8(%ebp),%eax
c01060ae:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c01060b1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01060b4:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c01060b7:	eb 2e                	jmp    c01060e7 <memcmp+0x42>
        if (*s1 != *s2) {
c01060b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01060bc:	0f b6 10             	movzbl (%eax),%edx
c01060bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01060c2:	0f b6 00             	movzbl (%eax),%eax
c01060c5:	38 c2                	cmp    %al,%dl
c01060c7:	74 18                	je     c01060e1 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c01060c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01060cc:	0f b6 00             	movzbl (%eax),%eax
c01060cf:	0f b6 d0             	movzbl %al,%edx
c01060d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01060d5:	0f b6 00             	movzbl (%eax),%eax
c01060d8:	0f b6 c8             	movzbl %al,%ecx
c01060db:	89 d0                	mov    %edx,%eax
c01060dd:	29 c8                	sub    %ecx,%eax
c01060df:	eb 18                	jmp    c01060f9 <memcmp+0x54>
        }
        s1 ++, s2 ++;
c01060e1:	ff 45 fc             	incl   -0x4(%ebp)
c01060e4:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
c01060e7:	8b 45 10             	mov    0x10(%ebp),%eax
c01060ea:	8d 50 ff             	lea    -0x1(%eax),%edx
c01060ed:	89 55 10             	mov    %edx,0x10(%ebp)
c01060f0:	85 c0                	test   %eax,%eax
c01060f2:	75 c5                	jne    c01060b9 <memcmp+0x14>
    }
    return 0;
c01060f4:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01060f9:	89 ec                	mov    %ebp,%esp
c01060fb:	5d                   	pop    %ebp
c01060fc:	c3                   	ret    
