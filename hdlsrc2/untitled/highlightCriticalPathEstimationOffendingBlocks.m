open_system('untitled');
open_system('gm_untitled');
cs.HiliteType = 'user2';
cs.ForegroundColor = 'black';
cs.BackgroundColor = 'gray';
set_param(0, 'HiliteAncestorsData', cs);
hilite_system('gm_untitled/butterbp/filter', 'user2');
annotate_port('gm_untitled/butterbp/filter', 1, 1, 'Block not characterized');
hilite_system('untitled/butterbp/filter', 'user2');
annotate_port('untitled/butterbp/filter', 1, 1, 'Block not characterized');