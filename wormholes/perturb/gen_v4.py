"""
    UNTARGETTED attacks on RestrictedImageNet
"""
    
"""
GenV4 focuses exclusively on untargeted attacks, where the adversarial example aims to make the model misclassify without targeting a specific incorrect label.
Contrast-blend attacks (used in GenV3) are disabled.
"""   
    
from wormholes.perturb.utils import *
from wormholes.perturb.gen_v3 import GenV3


class GenV4(GenV3):
    # The __init__ method initializes the class and sets up attack parameters. eps (maximum allowable pert)
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.attack_hparams_tup_list = [namedtuple('attack_hparams', ['eps', 'step_size', 'n_iter'])(*x) 
                                        for x in [(300, 4, 10_000), (200, 3, 10_000), (150, 2, 10_000), 
                                                  (100, 2, 5000), (50, 2, 2000), (40, 2, 2000), (30, 2, 2000), (25, .5, 1000), (20, .5, 1000), 
                                                  (15, .5, 500), (10, .5, 500), (7.5, .5, 500), (5, .5, 500), 
                                                  (3., .3, 200), (2., .3, 200), (1., .3, 200), (.5, .1, 200), (.1, .02, 200),
                                                  (0., 0., 0)
                                                  ]]
        # Discard contrast-blend (which means that two images cannot be mixed into one)
        self.interp_hparams_tup_list = []

    #This method prepares the data to be used for untargeted attacks.
    def get_data(self, n_sample_class=30):
        # Convert labels to class names and balance sample count by the minimum per class (because RIN has different class sizes)
        triplet_paths_list = []
        for i, (class_name, image_paths) in enumerate(self.data_dict.items()):
            for j in range(n_sample_class):
                seed = i * n_sample_class + j
                img_src_tup = (np.random.RandomState(seed).choice(image_paths)[len(f"{self.data_root}/"):], class_name) #randomly select images for each class
                # Untargetted attack against the grount-truth label
                triplet_paths_list.append([img_src_tup, class_name])
        return triplet_paths_list
    
    #this method generates avdersarial examples
    def make_adv(self, ds, g, attacker_model, cnk, images_source, target_class_indices):
        assert np.isnan(g.interp_alpha)
        im_adv, budget_usage = attacker_model.attack_target(images_source, target_class_indices, 
                                                            eps=g.budget, 
                                                            step_size=g.step_size, 
                                                            n_iter=g.n_iter, 
                                                            targeted=False,
                                                            do_tqdm=True)
        return im_adv, budget_usage
    