import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/widgets/job_templates_full.dart';
import '../../../../core/widgets/job_templates_small.dart';
import '../../../../core/widgets/offer_templates.dart';

class HomeJobCard extends StatelessWidget {
  final dynamic job;

  const HomeJobCard({
    super.key,
    required this.job,
  });

  @override
  Widget build(BuildContext context) {
    Widget card;

    switch (job['temp_id']) {
      case 'T001':
        card = JobTemplatesSmall.templateT001(job, context);
        break;
      case 'T002':
        card = JobTemplatesSmall.templateT002(job, context);
        break;
      case 'T003':
        card = JobTemplatesSmall.templateT003(job, context);
        break;
      case 'T004':
        card = JobTemplatesSmall.templateT004(job, context);
        break;
      default:
        card = JobTemplates.defaultTemplate(job, context);
    }

    return AspectRatio(
      aspectRatio: 0.65,
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: card,
            ),
          ),
          Positioned(
            top: 7,
            right: 7,
            child: _buildViewCount(job['view_count']),
          ),
        ],
      ),
    );
  }

  Widget _buildViewCount(dynamic count) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 7,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            CupertinoIcons.eye_fill,
            size: 10,
            color: Colors.white,
          ),
          const SizedBox(width: 3),
          Text(
            "${count ?? 0}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 9,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class HomeOfferCard extends StatelessWidget {
  final dynamic offer;

  const HomeOfferCard({
    super.key,
    required this.offer,
  });

  @override
  Widget build(BuildContext context) {
    Widget card;

    switch (offer['temp_id']) {
      case 'T001':
        card = OfferTemplates.templateT001(offer, context);
        break;
      case 'T002':
        card = OfferTemplates.templateT002(offer, context);
        break;
      case 'T003':
        card = OfferTemplates.templateT003(offer, context);
        break;
      case 'T004':
        card = OfferTemplates.templateT004(offer, context);
        break;
      default:
        card = OfferTemplates.defaultTemplate(offer, context);
    }

    return AspectRatio(
      aspectRatio: 0.65,
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: card,
            ),
          ),
          Positioned(
            top: 7,
            right: 7,
            child: _buildViewCount(offer['view_count']),
          ),
        ],
      ),
    );
  }

  Widget _buildViewCount(dynamic count) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 7,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            CupertinoIcons.eye_fill,
            size: 10,
            color: Colors.white,
          ),
          const SizedBox(width: 3),
          Text(
            "${count ?? 0}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 9,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}