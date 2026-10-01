const {
    Client,
    GatewayIntentBits,
    REST,
    Routes,
    SlashCommandBuilder,
    EmbedBuilder,
    ActionRowBuilder,
    ButtonBuilder,
    ButtonStyle,
    StringSelectMenuBuilder
} = require('discord.js');

const TOKEN = 'MTU1NTIwMjY4MTUxNjA2ODk3NA.G6B8IP.Pnseo9quC5cFPEW2yW4XEPm1ahDS3Xgyr3BYtI';
const CLIENT_ID = '1555202681516068974';
const GUILD_ID = '1522624385834418186';

const client = new Client({
    intents: [GatewayIntentBits.Guilds]
});

const languages = {
    en: {
        name: '🇬🇧 English',
        home: 'Home',
        previous: 'Previous',
        next: 'Next',
        language: 'Language',
        pages: 'Pages',
        page: 'Page',
        rulebook: 'FISHORA・RULEBOOK',
        description: 'Please read and follow all rules to keep FISHORA friendly, safe and enjoyable.'
    },
    vi: {
        name: '🇻🇳 Tiếng Việt',
        home: 'Trang chủ',
        previous: 'Trước',
        next: 'Sau',
        language: 'Ngôn ngữ',
        pages: 'Trang',
        page: 'Trang',
        rulebook: 'FISHORA・NỘI QUY',
        description: 'Vui lòng đọc và tuân thủ toàn bộ nội quy để giữ FISHORA thân thiện, an toàn và vui vẻ.'
    },
    ja: {
        name: '🇯🇵 日本語',
        home: 'ホーム',
        previous: '前へ',
        next: '次へ',
        language: '言語',
        pages: 'ページ',
        page: 'ページ',
        rulebook: 'FISHORA・ルールブック',
        description: 'FISHORAを安全で楽しいコミュニティにするため、すべてのルールを守ってください。'
    },
    ko: {
        name: '🇰🇷 한국어',
        home: '홈',
        previous: '이전',
        next: '다음',
        language: '언어',
        pages: '페이지',
        page: '페이지',
        rulebook: 'FISHORA・규칙',
        description: 'FISHORA를 안전하고 즐거운 커뮤니티로 유지하기 위해 모든 규칙을 지켜주세요.'
    },
    zh: {
        name: '🇨🇳 中文',
        home: '首页',
        previous: '上一页',
        next: '下一页',
        language: '语言',
        pages: '页面',
        page: '页面',
        rulebook: 'FISHORA・规则',
        description: '请遵守所有规则，共同维护一个友好、安全和愉快的 FISHORA 社区。'
    }
};

const pages = {
    en: [
        {
            title: '🏠・WELCOME',
            sections: [
                {
                    title: '🐟 Welcome to FISHORA',
                    rules: [
                        '**01.01 — Read the Rules**\nPlease read all rules before participating in the server.',
                        '**01.02 — Respect the Community**\nTreat members, staff and guests with respect.',
                        '**01.03 — Keep FISHORA Friendly**\nHelp create a comfortable environment for everyone.'
                    ]
                },
                {
                    title: '📌・Important',
                    rules: [
                        '**01.04 — Staff Decisions**\nFollow reasonable instructions from the moderation team.',
                        '**01.05 — Common Sense**\nNot every situation can be covered by a written rule. Use common sense.'
                    ]
                }
            ]
        },
        {
            title: '🛡️・GENERAL RULES',
            sections: [
                {
                    title: '🤝・Respect',
                    rules: [
                        '**02.01 — Respect Everyone**\nTreat every member with respect.',
                        '**02.02 — No Harassment**\nDo not repeatedly target, insult or harass other members.',
                        '**02.03 — No Hate Speech**\nHateful or discriminatory behavior is not allowed.'
                    ]
                },
                {
                    title: '💬・Communication',
                    rules: [
                        '**02.04 — No Spam**\nDo not flood channels with repeated messages.',
                        '**02.05 — No Unnecessary Drama**\nKeep personal conflicts and arguments away from public channels.',
                        '**02.06 — Stay On Topic**\nUse each channel for its intended purpose.'
                    ]
                }
            ]
        },
        {
            title: '💬・CHAT RULES',
            sections: [
                {
                    title: '📝・Text Channels',
                    rules: [
                        '**03.01 — Avoid Message Flooding**\nDo not send excessive repeated messages.',
                        '**03.02 — No Excessive Caps**\nAvoid using excessive capital letters.',
                        '**03.03 — No Mention Abuse**\nDo not repeatedly mention users or roles without a valid reason.'
                    ]
                },
                {
                    title: '🖼️・Media',
                    rules: [
                        '**03.04 — Appropriate Content**\nOnly share content appropriate for the channel.',
                        '**03.05 — No Disturbing Content**\nDo not intentionally post content designed to shock or disturb members.'
                    ]
                }
            ]
        },
        {
            title: '🔊・VOICE RULES',
            sections: [
                {
                    title: '🎙️・Voice Chat',
                    rules: [
                        '**04.01 — Respect Others**\nDo not intentionally disrupt conversations.',
                        '**04.02 — No Mic Spam**\nAvoid loud or repetitive microphone noises.',
                        '**04.03 — No Sound Abuse**\nDo not intentionally play disruptive sounds.'
                    ]
                },
                {
                    title: '🎧・Voice Etiquette',
                    rules: [
                        '**04.04 — Give Everyone Space**\nAllow others to participate in conversations.',
                        '**04.05 — Follow Staff Instructions**\nModerators may intervene when a voice channel becomes disruptive.'
                    ]
                }
            ]
        },
        {
            title: '📢・ADVERTISEMENT RULES',
            sections: [
                {
                    title: '🚫・Advertising',
                    rules: [
                        '**05.01 — No Unapproved Advertising**\nDo not advertise external servers, products or services without permission.',
                        '**05.02 — No DM Advertising**\nDo not use server members for unsolicited advertisements.',
                        '**05.03 — No Spam Promotion**\nRepeated promotional messages are not allowed.'
                    ]
                },
                {
                    title: '🔗・Links',
                    rules: [
                        '**05.04 — Suspicious Links**\nDo not share suspicious or malicious links.',
                        '**05.05 — Unapproved Invites**\nDo not repeatedly post unrelated Discord invitations.'
                    ]
                }
            ]
        },
        {
            title: '🛡️・STAFF & MODERATION',
            sections: [
                {
                    title: '👮・Moderation',
                    rules: [
                        '**06.01 — Follow Moderation**\nMembers should follow reasonable moderation instructions.',
                        '**06.02 — Do Not Impersonate Staff**\nDo not pretend to be a moderator or administrator.',
                        '**06.03 — Report Problems**\nContact staff when you encounter serious rule violations.'
                    ]
                },
                {
                    title: '📋・Reports',
                    rules: [
                        '**06.04 — Provide Evidence**\nWhen reporting an issue, provide useful information when possible.',
                        '**06.05 — Do Not Abuse Reports**\nDo not submit intentionally false or spam reports.'
                    ]
                }
            ]
        },
        {
            title: '⚠️・PUNISHMENTS',
            sections: [
                {
                    title: '📌・Moderation Actions',
                    rules: [
                        '**07.01 — Warnings**\nMinor violations may receive a warning.',
                        '**07.02 — Timeout**\nRepeated or disruptive behavior may result in a timeout.',
                        '**07.03 — Removal**\nSerious violations may result in removal from the server.'
                    ]
                },
                {
                    title: '🔒・Important',
                    rules: [
                        '**07.04 — Case By Case**\nModeration actions may depend on the severity and context of a violation.',
                        '**07.05 — Repeated Violations**\nRepeated violations may result in stronger moderation action.'
                    ]
                }
            ]
        }
    ]
};

pages.vi = [
    {
        title: '🏠・CHÀO MỪNG',
        sections: [
            {
                title: '🐟 Chào mừng đến FISHORA',
                rules: [
                    '**01.01 — Đọc nội quy**\nHãy đọc toàn bộ nội quy trước khi tham gia server.',
                    '**01.02 — Tôn trọng cộng đồng**\nTôn trọng thành viên, staff và khách.',
                    '**01.03 — Giữ FISHORA thân thiện**\nHãy cùng tạo một môi trường thoải mái cho mọi người.'
                ]
            },
            {
                title: '📌・Quan trọng',
                rules: [
                    '**01.04 — Quyết định của Staff**\nTuân thủ các hướng dẫn hợp lý từ đội ngũ quản lý.',
                    '**01.05 — Sử dụng lý trí**\nKhông phải tình huống nào cũng có thể được viết thành luật. Hãy sử dụng common sense.'
                ]
            }
        ]
    },
    {
        title: '🛡️・NỘI QUY CHUNG',
        sections: [
            {
                title: '🤝・Tôn trọng',
                rules: [
                    '**02.01 — Tôn trọng mọi người**\nĐối xử tôn trọng với mọi thành viên.',
                    '**02.02 — Không quấy rối**\nKhông liên tục nhắm vào, xúc phạm hoặc quấy rối thành viên khác.',
                    '**02.03 — Không kỳ thị**\nKhông được có hành vi thù ghét hoặc phân biệt đối xử.'
                ]
            },
            {
                title: '💬・Giao tiếp',
                rules: [
                    '**02.04 — Không spam**\nKhông gửi hàng loạt tin nhắn lặp lại.',
                    '**02.05 — Không gây drama**\nKhông đưa tranh cãi cá nhân vào các kênh công khai.',
                    '**02.06 — Đúng chủ đề**\nSử dụng mỗi kênh đúng mục đích.'
                ]
            }
        ]
    },
    {
        title: '💬・LUẬT CHAT',
        sections: [
            {
                title: '📝・Kênh văn bản',
                rules: [
                    '**03.01 — Không flood tin nhắn**\nKhông gửi quá nhiều tin nhắn liên tục.',
                    '**03.02 — Không lạm dụng CAPS**\nHạn chế sử dụng quá nhiều chữ in hoa.',
                    '**03.03 — Không lạm dụng mention**\nKhông mention người dùng hoặc role liên tục khi không cần thiết.'
                ]
            },
            {
                title: '🖼️・Media',
                rules: [
                    '**03.04 — Nội dung phù hợp**\nChỉ chia sẻ nội dung phù hợp với kênh.',
                    '**03.05 — Không đăng nội dung gây khó chịu**\nKhông cố ý đăng nội dung nhằm gây sốc hoặc làm phiền thành viên.'
                ]
            }
        ]
    },
    {
        title: '🔊・LUẬT VOICE',
        sections: [
            {
                title: '🎙️・Voice Chat',
                rules: [
                    '**04.01 — Tôn trọng người khác**\nKhông cố ý phá cuộc trò chuyện.',
                    '**04.02 — Không spam mic**\nKhông tạo âm thanh lớn hoặc lặp đi lặp lại.',
                    '**04.03 — Không lạm dụng âm thanh**\nKhông cố ý phát âm thanh gây khó chịu.'
                ]
            },
            {
                title: '🎧・Văn hóa Voice',
                rules: [
                    '**04.04 — Cho mọi người không gian**\nCho phép mọi người cùng tham gia cuộc trò chuyện.',
                    '**04.05 — Tuân thủ Staff**\nModerator có thể can thiệp khi voice trở nên mất trật tự.'
                ]
            }
        ]
    },
    {
        title: '📢・LUẬT QUẢNG CÁO',
        sections: [
            {
                title: '🚫・Quảng cáo',
                rules: [
                    '**05.01 — Không quảng cáo khi chưa được phép**\nKhông quảng cáo server, sản phẩm hoặc dịch vụ bên ngoài khi chưa được phép.',
                    '**05.02 — Không quảng cáo qua DM**\nKhông tự ý sử dụng thành viên server để quảng cáo.',
                    '**05.03 — Không spam quảng bá**\nKhông gửi quảng cáo lặp lại.'
                ]
            },
            {
                title: '🔗・Liên kết',
                rules: [
                    '**05.04 — Link đáng ngờ**\nKhông chia sẻ liên kết đáng ngờ hoặc độc hại.',
                    '**05.05 — Invite không được phép**\nKhông liên tục đăng Discord invite không liên quan.'
                ]
            }
        ]
    },
    {
        title: '🛡️・STAFF & MODERATION',
        sections: [
            {
                title: '👮・Quản lý',
                rules: [
                    '**06.01 — Tuân thủ moderation**\nThành viên cần tuân thủ hướng dẫn hợp lý từ staff.',
                    '**06.02 — Không giả mạo Staff**\nKhông giả danh moderator hoặc administrator.',
                    '**06.03 — Báo cáo vấn đề**\nLiên hệ staff khi gặp vi phạm nghiêm trọng.'
                ]
            },
            {
                title: '📋・Báo cáo',
                rules: [
                    '**06.04 — Cung cấp bằng chứng**\nKhi báo cáo, hãy cung cấp thông tin hữu ích nếu có thể.',
                    '**06.05 — Không lạm dụng report**\nKhông gửi report giả hoặc spam report.'
                ]
            }
        ]
    },
    {
        title: '⚠️・HÌNH PHẠT',
        sections: [
            {
                title: '📌・Biện pháp xử lý',
                rules: [
                    '**07.01 — Cảnh cáo**\nVi phạm nhẹ có thể nhận cảnh cáo.',
                    '**07.02 — Timeout**\nHành vi lặp lại hoặc gây rối có thể bị timeout.',
                    '**07.03 — Loại khỏi server**\nVi phạm nghiêm trọng có thể dẫn đến việc bị loại khỏi server.'
                ]
            },
            {
                title: '🔒・Quan trọng',
                rules: [
                    '**07.04 — Xử lý theo từng trường hợp**\nBiện pháp xử lý có thể phụ thuộc vào mức độ và hoàn cảnh.',
                    '**07.05 — Vi phạm nhiều lần**\nVi phạm lặp lại có thể dẫn đến biện pháp xử lý nghiêm khắc hơn.'
                ]
            }
        ]
    }
];

function getPages(language) {
    if (pages[language]) return pages[language];
    return pages.en;
}

function createEmbed(language, pageIndex) {
    const lang = languages[language];
    const currentPages = getPages(language);
    const page = currentPages[pageIndex];

    const embed = new EmbedBuilder()
        .setColor(0x5865F2)
        .setTitle(`🐟 ${lang.rulebook}`)
        .setDescription(`${page.title}\n\n${lang.description}`)
        .setFooter({
            text: `FISHORA • ${lang.page} ${pageIndex + 1} / ${currentPages.length}`
        })
        .setTimestamp();

    for (const section of page.sections) {
        embed.addFields({
            name: section.title,
            value: section.rules.join('\n\n'),
            inline: false
        });
    }

    return embed;
}

function createButtons(language, pageIndex) {
    const lang = languages[language];
    const currentPages = getPages(language);

    return new ActionRowBuilder().addComponents(
        new ButtonBuilder()
            .setCustomId('rules_prev')
            .setLabel(lang.previous)
            .setEmoji('◀️')
            .setStyle(ButtonStyle.Secondary)
            .setDisabled(pageIndex === 0),

        new ButtonBuilder()
            .setCustomId('rules_home')
            .setLabel(lang.home)
            .setEmoji('🏠')
            .setStyle(ButtonStyle.Primary),

        new ButtonBuilder()
            .setCustomId('rules_next')
            .setLabel(lang.next)
            .setEmoji('▶️')
            .setStyle(ButtonStyle.Secondary)
            .setDisabled(pageIndex >= currentPages.length - 1)
    );
}

function createPageMenu(language, pageIndex) {
    const lang = languages[language];
    const currentPages = getPages(language);

    const menu = new StringSelectMenuBuilder()
        .setCustomId('rules_page')
        .setPlaceholder(`📑 ${lang.pages}`)
        .addOptions(
            currentPages.map((page, index) => ({
                label: page.title.replace(/^[^\s]+\s*・/, '').slice(0, 100),
                description: `${lang.page} ${index + 1}`,
                value: String(index),
                default: index === pageIndex
            }))
        );

    return new ActionRowBuilder().addComponents(menu);
}

function createLanguageMenu(language) {
    const menu = new StringSelectMenuBuilder()
        .setCustomId('rules_language')
        .setPlaceholder('🌐 Language')
        .addOptions(
            Object.entries(languages).map(([code, data]) => ({
                label: data.name,
                value: code,
                default: code === language
            }))
        );

    return new ActionRowBuilder().addComponents(menu);
}

function createComponents(language, pageIndex) {
    return [
        createButtons(language, pageIndex),
        createPageMenu(language, pageIndex),
        createLanguageMenu(language)
    ];
}

const commands = [
    new SlashCommandBuilder()
        .setName('rules')
        .setDescription('Open the FISHORA rulebook')
        .toJSON()
];

const rest = new REST({ version: '10' }).setToken(TOKEN);

async function registerCommands() {
    await rest.put(
        Routes.applicationGuildCommands(CLIENT_ID, GUILD_ID),
        { body: commands }
    );

    console.log('✅ /rules đã được đăng ký.');
}

client.once('clientReady', async () => {
    console.log(`🐟 FISHORA BOT ONLINE: ${client.user.tag}`);

    try {
        await registerCommands();
    } catch (error) {
        console.error('❌ Không đăng ký được /rules:', error);
    }
});

client.on('interactionCreate', async interaction => {
    try {
        if (interaction.isChatInputCommand()) {
            if (interaction.commandName !== 'rules') return;

            const language = 'en';
            const pageIndex = 0;

            await interaction.reply({
                embeds: [createEmbed(language, pageIndex)],
                components: createComponents(language, pageIndex)
            });

            return;
        }

        if (!interaction.isButton() && !interaction.isStringSelectMenu()) {
            return;
        }

        const message = interaction.message;

        let language = message.embeds[0]?.footer?.text?.includes('Trang')
            ? 'vi'
            : 'en';

        if (!languages[language]) language = 'en';

        let pageIndex = 0;

        const footer = message.embeds[0]?.footer?.text || '';
        const match = footer.match(/(\d+)\s*\/\s*(\d+)/);

        if (match) {
            pageIndex = Math.max(0, Number(match[1]) - 1);
        }

        if (interaction.customId === 'rules_prev') {
            pageIndex--;
        }

        if (interaction.customId === 'rules_next') {
            pageIndex++;
        }

        if (interaction.customId === 'rules_home') {
            pageIndex = 0;
        }

        if (interaction.customId === 'rules_page') {
            pageIndex = Number(interaction.values[0]);
        }

        if (interaction.customId === 'rules_language') {
            language = interaction.values[0];
        }

        const currentPages = getPages(language);

        pageIndex = Math.max(
            0,
            Math.min(pageIndex, currentPages.length - 1)
        );

        await interaction.update({
            embeds: [createEmbed(language, pageIndex)],
            components: createComponents(language, pageIndex)
        });
    } catch (error) {
        console.error('❌ Interaction error:', error);

        if (!interaction.replied && !interaction.deferred) {
            await interaction.reply({
                content: '❌ Something went wrong.',
                ephemeral: true
            }).catch(() => {});
        }
    }
});

client.login(TOKEN);
